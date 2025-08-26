part of 'get_collections_bookmark_cubit.dart';

@immutable
sealed class GetCollectionsBookmarkState {}

final class GetCollectionsBookmarkInitial extends GetCollectionsBookmarkState {}

final class GetCollectionsBookmarkLoading extends GetCollectionsBookmarkState {}

final class GetCollectionsBookmarkSuccess extends GetCollectionsBookmarkState {
  final CollectionsResponse collectionsResponse;
  GetCollectionsBookmarkSuccess(this.collectionsResponse);
}

final class GetCollectionsBookmarkError extends GetCollectionsBookmarkState {
  final String errMessage;
  GetCollectionsBookmarkError(this.errMessage);
}
