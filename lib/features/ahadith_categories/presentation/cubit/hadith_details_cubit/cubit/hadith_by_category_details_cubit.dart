

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/features/ahadith_categories/domain/repositories/hadith_by_category_details_repo.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/new_daily_hadith_model.dart';

part 'hadith_by_category_details_state.dart';

class HadithByCategoryDetailsCubit extends Cubit<HadithByCategoryDetailsState> {
  final HadithByCategoryDetailsRepo _repo;
  HadithByCategoryDetailsCubit(this._repo) : super(HadithByCategoryDetailsInitial());
  Future<void> fetchById(String id) async {
    // Try cache first
    final cached = await _repo.getCachedHadith(id);
    
    if (cached != null) {
      // Emit cached data immediately
      emit(HadithByCategoryDetailsLoaded(cached));
      
      // Perform background refresh
      _backgroundRefresh(id);
    } else {
      // No cache, fetch from API
      emit(HadithByCategoryDetailsLoading());
      try {
        final fetched = await _repo.fetchHadith(id);
        if (fetched != null) {
          emit(HadithByCategoryDetailsLoaded(fetched));
        } else {
          emit(HadithByCategoryDetailsError('تعذر تحميل حديث اليوم'));
        }
      } catch (e) {
        emit(HadithByCategoryDetailsError('تعذر تحميل حديث اليوم'));
      }
    }
  }

  Future<void> _backgroundRefresh(String id) async {
    try {
      final fetched = await _repo.fetchHadith(id);
      if (fetched != null) {
        emit(HadithByCategoryDetailsLoaded(fetched));
      }
    } catch (e) {
      // Background refresh failed, fail silently to keep cached data
      debugPrint("Background refresh failed: $e");
    }
  }
}
