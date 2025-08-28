part of 'navigation_cubit.dart';

@immutable
sealed class NavigationState {}

final class NavigationInitial extends NavigationState {}

final class NavigationLoading extends NavigationState {}

final class NavigationSuccess extends NavigationState {

  
  final NavigationHadithResponse navigationHadithResponse;
  NavigationSuccess(this.navigationHadithResponse);
}

final class NavigationFailure extends NavigationState {
  final String errMessage;
  NavigationFailure(this.errMessage);
}
