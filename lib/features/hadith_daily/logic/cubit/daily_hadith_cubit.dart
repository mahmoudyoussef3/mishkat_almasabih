import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/save_hadith_daily_repo.dart';

part 'daily_hadith_state.dart';

class DailyHadithCubit extends Cubit<DailyHadithState> {
  DailyHadithCubit() : super(DailyHadithInitial());

  Timer? _refreshTimer;

  // تحميل الحديث لأول مرة وبدء التايمر
  Future<void> startListeningForUpdates() async {
    debugPrint('🔄 Starting to listen for hadith updates...');
    
    // تحميل البيانات أول مرة
    await _loadSavedHadith();
    
    // بدء التايمر للتحديث كل 35 ثانية (أقل من الـ background service)
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 35),
      (timer) {
        debugPrint('⏰ Timer triggered - checking for new hadith...');
        _loadSavedHadith();
      },
    );
  }

  // تحميل الحديث المحفوظ فقط من الـ local storage
  Future<void> _loadSavedHadith() async {
    try {
      debugPrint('📖 Loading saved hadith...');
      final saved = await SaveHadithDailyRepo().getHadith();
      
      if (saved != null) {
        debugPrint('✅ Hadith loaded successfully: ${saved.data?.hadith?.substring(0, 50) ?? 'No content'}...');
        emit(DailyHadithSuccess(saved));
      } else {
        debugPrint('❌ No saved hadith found');
        emit(DailyHadithFailure('لا توجد بيانات محفوظة'));
      }
    } catch (e) {
      debugPrint('❌ Error loading hadith: $e');
      emit(DailyHadithFailure('حدث خطأ في تحميل البيانات'));
    }
  }

  // تحديث فوري للبيانات (للاستخدام من UI)
  Future<void> refreshNow() async {
    debugPrint('🔄 Manual refresh requested...');
    await _loadSavedHadith();
  }

  // إيقاف التايمر عند عدم الحاجة
  void stopListening() {
    debugPrint('🛑 Stopping hadith updates listener...');
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}