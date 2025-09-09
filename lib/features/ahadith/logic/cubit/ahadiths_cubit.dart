import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/core/cache/cache_mixin.dart';
import 'package:mishkat_almasabih/core/cache/cache_service.dart';
import 'package:mishkat_almasabih/features/ahadith/data/models/ahadiths_model.dart';
import 'package:mishkat_almasabih/features/ahadith/data/models/local_books_model.dart';
import 'package:mishkat_almasabih/features/ahadith/data/repos/ahadiths_repo.dart';

part 'ahadiths_state.dart';

class AhadithsCubit extends Cubit<AhadithsState> with CacheMixin {
  final AhadithsRepo _chapterAhadithsRepo;
  AhadithsCubit(this._chapterAhadithsRepo) : super(AhadithsInitial());

  Future<void> emitAhadiths({
    required String bookSlug,
    required int chapterId,
    required bool hadithLocal,
    required bool isArbainBooks,
    bool forceRefresh = false,
  }) async {
    emit(AhadithsLoading());

    if (isArbainBooks) {
      await _loadArbainBooks(bookSlug, chapterId, forceRefresh);
    } else if (hadithLocal) {
      await _loadLocalAhadith(bookSlug, chapterId, forceRefresh);
    } else {
      await _loadRegularAhadith(bookSlug, chapterId, forceRefresh);
    }
  }

  Future<void> _loadArbainBooks(
    String bookSlug,
    int chapterId,
    bool forceRefresh,
  ) async {
    final cacheKey = CacheService.generateCacheKey('arbain_ahadith', {
      'bookSlug': bookSlug,
      'chapterId': chapterId.toString(),
    });

    await loadWithCacheAndRefresh<LocalHadithResponse>(
      cacheKey: cacheKey,
      apiCall: () async {
        final result = await _chapterAhadithsRepo.getThreeBooksLocalAhadith(
          bookSlug: bookSlug,
          chapterId: chapterId,
        );
        return result.fold(
          (error) =>
              throw Exception(
                error.apiErrorModel.msg ?? 'Unknown error occurred',
              ),
          (data) => data,
        );
      },
      fromJson: (json) => LocalHadithResponse.fromJson(json),
      toJson: (data) => data.toJson(),
      onSuccess: (data) => emit(LocalAhadithsSuccess(data)),
      onError: (error) => emit(AhadithsFailure(error)),
      loadingState: () => AhadithsLoading(),
      forceRefresh: forceRefresh,
      customCacheDuration: 30, // 30 minutes cache for ahadith
    );
  }

  Future<void> _loadLocalAhadith(
    String bookSlug,
    int chapterId,
    bool forceRefresh,
  ) async {
    final cacheKey = CacheService.generateCacheKey('local_ahadith', {
      'bookSlug': bookSlug,
      'chapterId': chapterId.toString(),
    });

    await loadWithCacheAndRefresh<LocalHadithResponse>(
      cacheKey: cacheKey,
      apiCall: () async {
        final result = await _chapterAhadithsRepo.getLocalAhadith(
          bookSlug: bookSlug,
          chapterId: chapterId,
        );
        return result.fold(
          (error) =>
              throw Exception(
                error.apiErrorModel.msg ?? 'Unknown error occurred',
              ),
          (data) => data,
        );
      },
      fromJson: (json) => LocalHadithResponse.fromJson(json),
      toJson: (data) => data.toJson(),
      onSuccess: (data) => emit(LocalAhadithsSuccess(data)),
      onError: (error) => emit(AhadithsFailure(error)),
      loadingState: () => AhadithsLoading(),
      forceRefresh: forceRefresh,
      customCacheDuration: 30, // 30 minutes cache for ahadith
    );
  }

  Future<void> _loadRegularAhadith(
    String bookSlug,
    int chapterId,
    bool forceRefresh,
  ) async {
    final cacheKey = CacheService.generateCacheKey('regular_ahadith', {
      'bookSlug': bookSlug,
      'chapterId': chapterId.toString(),
    });

    await loadWithCacheAndRefresh<HadithResponse>(
      cacheKey: cacheKey,
      apiCall: () async {
        final result = await _chapterAhadithsRepo.getAhadith(
          bookSlug: bookSlug,
          chapterId: chapterId,
        );
        return result.fold(
          (error) =>
              throw Exception(
                error.apiErrorModel.msg ?? 'Unknown error occurred',
              ),
          (data) => data,
        );
      },
      fromJson: (json) => HadithResponse.fromJson(json),
      toJson: (data) => data.toJson(),
      onSuccess: (data) {
        final hadithsList = data.hadiths?.data ?? [];
        emit(
          AhadithsSuccess(
            filteredAhadith: hadithsList,
            allAhadith: hadithsList,
          ),
        );
      },
      onError: (error) => emit(AhadithsFailure(error)),
      loadingState: () => AhadithsLoading(),
      forceRefresh: forceRefresh,
      customCacheDuration: 30, // 30 minutes cache for ahadith
    );
  }

  void filterAhadith(String query) {
    final currentState = state;

    if (currentState is AhadithsSuccess) {
      final normalizedQuery = normalizeArabic(query);

      if (normalizedQuery.isEmpty) {
        emit(currentState.copyWith(filteredAhadith: currentState.allAhadith));
      } else {
        final filtered =
            currentState.allAhadith
                .where(
                  (hadith) =>
                      hadith.hadithArabic != null &&
                      normalizeArabic(
                        hadith.hadithArabic!,
                      ).contains(normalizedQuery),
                )
                .toList();

        emit(currentState.copyWith(filteredAhadith: filtered));
      }
    } else if (currentState is LocalAhadithsSuccess) {
      final normalizedQuery = normalizeArabic(query);
      final hadithsList = currentState.localHadithResponse.hadiths?.data ?? [];

      if (normalizedQuery.isEmpty) {
        emit(currentState);
      } else {
        final filtered =
            hadithsList
                .where(
                  (hadith) =>
                      hadith.arabic != null &&
                      normalizeArabic(
                        hadith.arabic!,
                      ).contains(normalizedQuery.trim()),
                )
                .toList();

        emit(currentState);
      }
    }
  }

  String normalizeArabic(String text) {
    final diacritics = RegExp(r'[\u0617-\u061A\u064B-\u0652]');
    String result = text.replaceAll(diacritics, '');

    // 2. توحيد الهمزات: أ إ آ -> ا
    result = result.replaceAll(RegExp('[إأآ]'), 'ا');

    // 3. شيل المدّة "ـ"
    result = result.replaceAll('ـ', '');

    // 4. Optional: lowercase (عشان لو فيه انجليزي)
    result = result.toLowerCase();

    return result.trim();
  }
}
