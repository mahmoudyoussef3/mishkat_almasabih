// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_hadith_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavigationHadithResponse _$NavigationHadithResponseFromJson(
  Map<String, dynamic> json,
) => NavigationHadithResponse(
  status: (json['status'] as num?)?.toInt(),
  book:
      json['book'] == null
          ? null
          : Book.fromJson(json['book'] as Map<String, dynamic>),
  nextHadith:
      json['nextHadith'] == null
          ? null
          : Hadith.fromJson(json['nextHadith'] as Map<String, dynamic>),
  prevHadith:
      json['prevHadith'] == null
          ? null
          : Hadith.fromJson(json['prevHadith'] as Map<String, dynamic>),
  currentHadithNumber: json['currentHadithNumber'] as String?,
  totalHadiths: (json['totalHadiths'] as num?)?.toInt(),
);

Map<String, dynamic> _$NavigationHadithResponseToJson(
  NavigationHadithResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'book': instance.book,
  'nextHadith': instance.nextHadith,
  'prevHadith': instance.prevHadith,
  'currentHadithNumber': instance.currentHadithNumber,
  'totalHadiths': instance.totalHadiths,
};

Book _$BookFromJson(Map<String, dynamic> json) => Book(
  bookName: json['bookName'] as String?,
  bookNameEn: json['bookNameEn'] as String?,
);

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
  'bookName': instance.bookName,
  'bookNameEn': instance.bookNameEn,
};

Hadith _$HadithFromJson(Map<String, dynamic> json) =>
    Hadith(id: json['id'] as String?, title: json['title'] as String?);

Map<String, dynamic> _$HadithToJson(Hadith instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
};
