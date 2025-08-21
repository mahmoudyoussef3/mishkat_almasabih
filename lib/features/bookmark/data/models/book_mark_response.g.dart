// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_mark_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddBookmarkResponse _$AddBookmarkResponseFromJson(Map<String, dynamic> json) =>
    AddBookmarkResponse(
      message: json['message'] as String?,
      bookmarkId: (json['bookmarkId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AddBookmarkResponseToJson(
  AddBookmarkResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'bookmarkId': instance.bookmarkId,
};
