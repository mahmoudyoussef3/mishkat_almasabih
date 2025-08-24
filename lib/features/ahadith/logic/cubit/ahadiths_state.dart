part of 'ahadiths_cubit.dart';

@immutable
sealed class AhadithsState {}

final class AhadithsInitial extends AhadithsState {}

final class AhadithsLoading extends AhadithsState {}

final class AhadithsSuccess extends AhadithsState {
  final HadithResponse hadithResponse;
  AhadithsSuccess(this.hadithResponse);
}

final class LocalAhadithsSuccess extends AhadithsState {
  final LocalHadithResponse localHadithResponse;
  LocalAhadithsSuccess(this.localHadithResponse);
}

final class AhadithsFailure extends AhadithsState {
  final String error;
  AhadithsFailure(this.error);
}
