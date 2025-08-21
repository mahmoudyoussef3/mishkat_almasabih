import 'package:json_annotation/json_annotation.dart';
part 'book_mark_response.g.dart';
@JsonSerializable()
class AddBookmarkResponse {
  final String? message;
  final int? bookmarkId;

  AddBookmarkResponse({this.message, this.bookmarkId});

  factory AddBookmarkResponse.fromJson(Map<String, dynamic> json) =>
      _$AddBookmarkResponseFromJson(json);
}
