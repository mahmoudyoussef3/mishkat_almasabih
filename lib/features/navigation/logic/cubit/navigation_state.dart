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


final class LocalNavigationSuccess extends NavigationState {

  
  final LocalNavigationHadithResponse navigationHadithResponse;
  LocalNavigationSuccess(this.navigationHadithResponse);
}

final class LocalNavigationFailure extends NavigationState {
  final String errMessage;
  LocalNavigationFailure(this.errMessage);
}

