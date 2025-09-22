import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/save_hadith_daily_repo.dart';

part 'daily_hadith_state.dart';

class DailyHadithCubit extends Cubit<DailyHadithState> {
  final SaveHadithDailyRepo _repo;

  DailyHadithCubit(this._repo) : super(DailyHadithInitial());

   Future<void> fetchHadith() async {
    emit(DailyHaditLoading());
    try {
      final hadith = await _repo.fetchHadith();
      emit(DailyHadithSuccess(hadith));
    } catch (e) {
      emit(DailyHadithFailure(e.toString()));
    }
  }
}
