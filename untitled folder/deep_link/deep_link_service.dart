import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:qixer/midas_misr/core/config/app_constants.dart';
import 'package:qixer/midas_misr/core/deep_link/deep_link_router.dart';
import 'package:qixer/midas_misr/core/networking/cache_helper.dart';
import 'package:qixer/midas_misr/core/routing/routes.dart';
import 'package:qixer/midas_misr/features/service_details/ui/screen/service_details_screen.dart';

/// Production deep-link pipeline: one queue, URI + route dedupe, idempotent navigation.
class DeepLinkService with WidgetsBindingObserver {
  DeepLinkService._();
  static final DeepLinkService instance = DeepLinkService._();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  /// Multi-source race window (stream + resume + latest firing together).
  static const Duration _uriCoalesceWindow = Duration(seconds: 1);

  /// Route-level coalesce after a successful deep-link navigation.
  static const Duration _routeCoalesceWindow = Duration(seconds: 1);

  final Set<String> _queuedUriKeys = {};
  final List<Uri> _queue = [];
  bool _isDrainingQueue = false;

  /// Recently handled URIs (all sources) — prevents double processing.
  final Map<String, DateTime> _handledUriAt = {};

  String? _lastRouteKey;
  DateTime? _lastRouteAt;

  Uri? _pendingDeepLink;
  bool _isInitialized = false;

  bool get hasPendingDeepLink => _pendingDeepLink != null;

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    WidgetsBinding.instance.addObserver(this);
    _log('init → listeners registered');

    await _handleColdStartLink();
    _listenToRuntimeLinks();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _log('lifecycle → resumed');
      unawaited(_handleLatestLink());
    }
  }

  Future<void> processPendingDeepLink() async {
    final uri = _pendingDeepLink;
    if (uri == null) return;

    _pendingDeepLink = null;
    // Allow replay after login (URI may have been marked during auth gate).
    _handledUriAt.remove(_normalize(uri));
    _log('pending → processing after auth');
    await _enqueue(uri);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sub?.cancel();
    _sub = null;
    _isInitialized = false;
    _queue.clear();
    _queuedUriKeys.clear();
    _handledUriAt.clear();
    _log('dispose');
  }

  // ---------------------------------------------------------------------------
  // Ingress (all sources → single pipeline)
  // ---------------------------------------------------------------------------

  void _listenToRuntimeLinks() {
    _sub = _appLinks.uriLinkStream.listen(
      (uri) {
        _log('stream → $uri');
        unawaited(_enqueue(uri));
      },
      onError: (err) => _log('stream → error: $err', isError: true),
    );
  }

  Future<void> _handleLatestLink() async {
    try {
      final uri = await _appLinks.getLatestLink();
      if (uri != null) {
        _log('latest → $uri');
        await _enqueue(uri);
      }
    } catch (e) {
      _log('latest → error: $e', isError: true);
    }
  }

  Future<void> _handleColdStartLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _log('cold start → $uri');
        await _enqueue(uri);
      }
    } catch (e) {
      _log('cold start → error: $e', isError: true);
    }
  }

  /// Every source funnels here. Coalesces duplicate URIs in queue + global cache.
  Future<void> _enqueue(Uri uri) async {
    final uriKey = _normalize(uri);

    if (_queuedUriKeys.contains(uriKey)) {
      _log('enqueue → skip (already queued): $uriKey');
      return;
    }

    _queuedUriKeys.add(uriKey);
    _queue.add(uri);
    _log('enqueue → queued (${_queue.length}): $uriKey');

    if (_isDrainingQueue) return;

    _isDrainingQueue = true;
    try {
      while (_queue.isNotEmpty) {
        final next = _queue.removeAt(0);
        final key = _normalize(next);
        _queuedUriKeys.remove(key);
        await _processDeepLink(next);
      }
    } finally {
      _isDrainingQueue = false;
    }
  }

  Future<void> _processDeepLink(Uri uri) async {
    final uriKey = _normalize(uri);
    _log('process → $uriKey');

    if (!_isAuthenticated()) {
      _pendingDeepLink = uri;
      _log('auth → stored pending link');
      unawaited(_goToLogin());
      return;
    }

    if (!_claimUri(uriKey)) {
      _log('process → skip (URI coalesce): $uriKey');
      return;
    }

    await _navigateToDeepLink(uri);
  }

  // ---------------------------------------------------------------------------
  // Navigation (idempotent: one target screen, no duplicate stack)
  // ---------------------------------------------------------------------------

  Future<void> _navigateToDeepLink(Uri uri) async {
    final action = DeepLinkRouter.parse(uri);
    if (action == null) {
      _log('parse → rejected: $uri', isError: true);
      return;
    }

    _log('parse → $action');

    final route = DeepLinkRouter.toRoute(action);
    final routeKey = _buildRouteKey(route);
    _log('route → $routeKey');

    if (_isDuplicateRouteNavigation(routeKey)) {
      _log('navigate → skip (route coalesce): $routeKey');
      return;
    }

    if (!await _waitForNavigator()) {
      _log('navigate → aborted (navigator timeout)', isError: true);
      return;
    }

    await WidgetsBinding.instance.endOfFrame;

    final navigator = navigatorKey.currentState;
    if (navigator == null || !navigator.mounted) {
      _log('navigate → aborted (navigator unavailable)', isError: true);
      return;
    }

    final broughtToFront = _bringTargetToFrontOrPush(
      navigator,
      route.routeName,
      route.arguments,
    );

    if (broughtToFront) {
      _log('navigate → target already in stack, brought to front');
    } else {
      _log('navigate → pushing ${route.routeName}');
      try {
        unawaited(
          navigator.pushNamed(route.routeName, arguments: route.arguments).then(
            (_) {},
            onError: (Object e, StackTrace st) {
              _log('navigate → push failed: $e\n$st', isError: true);
            },
          ),
        );
      } catch (e, st) {
        _log('navigate → sync failure: $e\n$st', isError: true);
        return;
      }
    }

    _recordRouteNavigation(routeKey);
    _log('navigate → done');
  }

  /// Returns true if a matching route was found (and popUntil stopped there).
  bool _bringTargetToFrontOrPush(
    NavigatorState navigator,
    String routeName,
    Object? targetArgs,
  ) {
    var found = false;

    navigator.popUntil((route) {
      if (_routeMatchesTarget(route, routeName, targetArgs)) {
        found = true;
        return true;
      }
      return route.isFirst;
    });

    return found;
  }

  bool _routeMatchesTarget(
    Route<dynamic> route,
    String routeName,
    Object? targetArgs,
  ) {
    if (route.settings.name != routeName) return false;
    return _semanticArgsEqual(route.settings.arguments, targetArgs);
  }

  bool _semanticArgsEqual(Object? a, Object? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;

    final serviceA = _serviceIdentity(a);
    final serviceB = _serviceIdentity(b);
    if (serviceA != null && serviceB != null) {
      return serviceA.$1 == serviceB.$1 && serviceA.$2 == serviceB.$2;
    }

    final stayA = _stayIdentity(a);
    final stayB = _stayIdentity(b);
    if (stayA != null && stayB != null) {
      return stayA.$1 == stayB.$1 && stayA.$2 == stayB.$2;
    }

    return a == b;
  }

  (int serviceId, int? providerId)? _serviceIdentity(Object? args) {
    if (args is ServiceDeepLinkArgs) {
      return (args.serviceId, args.providerId);
    }
    if (args is ServiceDetailsArgs) {
      return (args.serviceId, args.providerId);
    }
    return null;
  }

  (StayMode mode, int? serviceId)? _stayIdentity(Object? args) {
    if (args is StayDeepLinkArgs) {
      return (args.mode, args.serviceId);
    }
    if (args is String) {
      if (args == 'in') return (StayMode.stayIn, null);
      if (args == 'out') return (StayMode.stayOut, null);
    }
    return null;
  }

  String _buildRouteKey(DeepLinkRoute route) {
    final args = route.arguments;
    final service = _serviceIdentity(args);
    if (service != null) {
      return '${route.routeName}|s=${service.$1}|p=${service.$2}';
    }
    final stay = _stayIdentity(args);
    if (stay != null) {
      return '${route.routeName}|mode=${stay.$1.queryValue}|id=${stay.$2}';
    }
    return '${route.routeName}|$args';
  }

  // ---------------------------------------------------------------------------
  // Dedupe layers
  // ---------------------------------------------------------------------------

  /// Claims URI for processing; false if same URI was handled within coalesce window.
  bool _claimUri(String uriKey) {
    _purgeExpiredEntries();
    final last = _handledUriAt[uriKey];
    if (last != null &&
        DateTime.now().difference(last) < _uriCoalesceWindow) {
      return false;
    }
    _handledUriAt[uriKey] = DateTime.now();
    return true;
  }

  bool _isDuplicateRouteNavigation(String routeKey) {
    if (_lastRouteKey != routeKey || _lastRouteAt == null) return false;
    return DateTime.now().difference(_lastRouteAt!) < _routeCoalesceWindow;
  }

  void _recordRouteNavigation(String routeKey) {
    _lastRouteKey = routeKey;
    _lastRouteAt = DateTime.now();
  }

  void _purgeExpiredEntries() {
    final now = DateTime.now();
    _handledUriAt.removeWhere(
      (_, at) => now.difference(at) > _uriCoalesceWindow,
    );
  }

  // ---------------------------------------------------------------------------
  // Auth / helpers
  // ---------------------------------------------------------------------------

  Future<void> _goToLogin() async {
    if (!await _waitForNavigator()) return;
    await WidgetsBinding.instance.endOfFrame;

    final navigator = navigatorKey.currentState;
    if (navigator == null || !navigator.mounted) return;

    _log('auth → login');
    try {
      navigator.pushNamedAndRemoveUntil(
        Routes.loginScreen,
        (route) => false,
      );
    } catch (e) {
      _log('auth → failed: $e', isError: true);
    }
  }

  bool _isAuthenticated() {
    final token = AppCache.getData(key: CacheStrings.token);
    return token != null && token.toString().isNotEmpty;
  }

  String _normalize(Uri uri) => uri.removeFragment().toString().trim();

  Future<bool> _waitForNavigator() async {
    const timeout = Duration(seconds: 8);
    const step = Duration(milliseconds: 50);
    final deadline = DateTime.now().add(timeout);

    while (navigatorKey.currentState == null) {
      if (DateTime.now().isAfter(deadline)) {
        _log('navigator → timeout', isError: true);
        return false;
      }
      await Future.delayed(step);
    }
    return true;
  }

  void _log(String message, {bool isError = false}) {
    if (!kDebugMode) return;
    debugPrint('${isError ? '❌' : '🔗'} [DeepLink] $message');
  }
}
