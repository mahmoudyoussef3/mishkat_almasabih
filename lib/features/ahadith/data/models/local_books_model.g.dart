// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_books_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalHadithResponse _$LocalHadithResponseFromJson(Map<String, dynamic> json) =>
    LocalHadithResponse(
      status: (json['status'] as num?)?.toInt(),
      hadiths:
          json['hadiths'] == null
              ? null
              : LocalHadithsWrapper.fromJson(
                json['hadiths'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$LocalHadithResponseToJson(
  LocalHadithResponse instance,
) => <String, dynamic>{'status': instance.status, 'hadiths': instance.hadiths};

LocalHadithsWrapper _$LocalHadithsWrapperFromJson(Map<String, dynamic> json) =>
    LocalHadithsWrapper(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => LocalHadith.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$LocalHadithsWrapperToJson(
  LocalHadithsWrapper instance,
) => <String, dynamic>{'data': instance.data};

LocalHadith _$LocalHadithFromJson(Map<String, dynamic> json) => LocalHadith(
  id: (json['id'] as num?)?.toInt(),
  idInBook: (json['idInBook'] as num?)?.toInt(),
  chapterId: (json['chapterId'] as num?)?.toInt(),
  bookId: (json['bookId'] as num?)?.toInt(),
  arabic: json['arabic'] as String?,
  english:
      json['english'] == null
          ? null
          : EnglishHadith.fromJson(json['english'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LocalHadithToJson(LocalHadith instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idInBook': instance.idInBook,
      'chapterId': instance.chapterId,
      'bookId': instance.bookId,
      'arabic': instance.arabic,
      'english': instance.english,
    };

EnglishHadith _$EnglishHadithFromJson(Map<String, dynamic> json) =>
    EnglishHadith(
      narrator: json['narrator'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$EnglishHadithToJson(EnglishHadith instance) =>
    <String, dynamic>{'narrator': instance.narrator, 'text': instance.text};
