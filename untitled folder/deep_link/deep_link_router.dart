import 'package:qixer/midas_misr/core/routing/routes.dart';
import 'package:qixer/midas_misr/core/config/flavor_config.dart';

class DeepLinkRouter {
  static final String apiHost = Uri.parse(AppConfig.baseUrl).host;
  static const String _legacyTestHost = 'test.midas-misr.com';
  static const String _servicePath = 'service';
  static const String _servicesPath = 'services';
  static const String _stayPath = 'stay';

  static DeepLinkAction? parse(Uri uri) {
    if (!_isValidUri(uri)) return null;

    final segments = _segments(uri);
    if (segments.isEmpty) return null;

    final type = segments.first.toLowerCase();

    final id = segments.length > 1
        ? segments[1]
        : uri.queryParameters['id'] ??
            uri.queryParameters['service_id'] ??
            uri.queryParameters['order_id'];

    final providerId =
        uri.queryParameters['provider_id'] ?? uri.queryParameters['providerId'];

    switch (type) {
      case _servicePath:
      case _servicesPath:
        if (!_isValidId(id)) return null;
        if (!_isNumericId(id)) return null;
        if (providerId != null && !_isNumericId(providerId)) return null;
        return OpenServiceDetails(
          serviceId: id!,
          providerId: providerId,
        );

      case _stayPath:
        if (id != null && !_isNumericId(id)) return null;
        final mode = _parseStayMode(uri.queryParameters['mode']);
        if (mode == null) return null;
        return OpenStayServiceDetails(serviceId: id, mode: mode);

      default:
        return null;
    }
  }

  static DeepLinkRoute toRoute(DeepLinkAction action) {
    switch (action) {
      case OpenServiceDetails(:final serviceId, :final providerId):
        return DeepLinkRoute(
          routeName: Routes.serviceDetailsScreen,
          arguments: ServiceDeepLinkArgs(
            serviceId: int.parse(serviceId),
            providerId: providerId != null ? int.parse(providerId) : null,
          ),
        );
      case OpenStayServiceDetails(:final serviceId, :final mode):
        return DeepLinkRoute(
          routeName: Routes.stayServiceDetailsScreen,
          arguments: StayDeepLinkArgs(
            serviceId: serviceId != null ? int.parse(serviceId) : null,
            mode: mode,
          ),
        );
    }
  }

  static bool _isValidUri(Uri uri) {
    final host = uri.host.toLowerCase();
    final normalizedApiHost = apiHost.toLowerCase();
    final allowedHosts = <String>{
      normalizedApiHost,
      'www.$normalizedApiHost',
      _legacyTestHost,
      'www.$_legacyTestHost',
    };
    return uri.scheme == 'https' && allowedHosts.contains(host);
  }

  static List<String> _segments(Uri uri) {
    return uri.pathSegments
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static bool _isValidId(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static bool _isNumericId(String? value) {
    return int.tryParse(value ?? '') != null;
  }

  static StayMode? _parseStayMode(String? mode) {
    switch (mode?.toLowerCase()) {
      case 'stay_in':
        return StayMode.stayIn;
      case 'stay_out':
        return StayMode.stayOut;
      default:
        return null;
    }
  }

  static Uri buildServiceDetailsLink({
    required int serviceId,
    int? providerId,
  }) {
    final params = <String, String>{};
    if (providerId != null) {
      params['provider_id'] = providerId.toString();
    }
    return Uri.https(
      apiHost,
      '/$_servicePath/$serviceId',
      params.isEmpty ? null : params,
    );
  }

  static Uri buildStayServiceDetailsLink({
    int? serviceId,
    required StayMode mode,
  }) {
    final path = serviceId != null ? '/$_stayPath/$serviceId' : '/$_stayPath';
    return Uri.https(
      apiHost,
      path,
      {'mode': mode.queryValue},
    );
  }
}

sealed class DeepLinkAction {
  const DeepLinkAction();
}

final class OpenServiceDetails extends DeepLinkAction {
  final String serviceId;
  final String? providerId;

  const OpenServiceDetails({
    required this.serviceId,
    this.providerId,
  });
}

final class OpenStayServiceDetails extends DeepLinkAction {
  final String? serviceId;
  final StayMode mode;

  const OpenStayServiceDetails({
    this.serviceId,
    required this.mode,
  });
}

enum StayMode {
  stayIn('stay_in', 'in'),
  stayOut('stay_out', 'out');

  final String queryValue;
  final String serviceTypeValue;
  const StayMode(this.queryValue, this.serviceTypeValue);
}

class ServiceDeepLinkArgs {
  final int serviceId;
  final int? providerId;

  const ServiceDeepLinkArgs({
    required this.serviceId,
    this.providerId,
  });
}

class StayDeepLinkArgs {
  final int? serviceId;
  final StayMode mode;

  const StayDeepLinkArgs({
    required this.serviceId,
    required this.mode,
  });
}

class DeepLinkRoute {
  final String routeName;
  final Object? arguments;

  const DeepLinkRoute({
    required this.routeName,
    this.arguments,
  });
}
