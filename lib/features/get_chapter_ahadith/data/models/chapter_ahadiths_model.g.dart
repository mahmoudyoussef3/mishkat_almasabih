// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_ahadiths_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HadithResponse _$HadithResponseFromJson(Map<String, dynamic> json) =>
    HadithResponse(
      status: (json['status'] as num).toInt(),
      hadiths: Hadiths.fromJson(json['hadiths'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HadithResponseToJson(HadithResponse instance) =>
    <String, dynamic>{'status': instance.status, 'hadiths': instance.hadiths};

Hadiths _$HadithsFromJson(Map<String, dynamic> json) => Hadiths(
  data:
      (json['data'] as List<dynamic>)
          .map((e) => Hadith.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$HadithsToJson(Hadiths instance) => <String, dynamic>{
  'data': instance.data,
};

Hadith _$HadithFromJson(Map<String, dynamic> json) => Hadith(
  id: (json['id'] as num).toInt(),
  idInBook: (json['idInBook'] as num).toInt(),
  chapterId: (json['chapterId'] as num).toInt(),
  bookId: (json['bookId'] as num).toInt(),
  arabic: json['arabic'] as String,
  english: HadithEnglish.fromJson(json['english'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HadithToJson(Hadith instance) => <String, dynamic>{
  'id': instance.id,
  'idInBook': instance.idInBook,
  'chapterId': instance.chapterId,
  'bookId': instance.bookId,
  'arabic': instance.arabic,
  'english': instance.english,
};

HadithEnglish _$HadithEnglishFromJson(Map<String, dynamic> json) =>
    HadithEnglish(
      narrator: json['narrator'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$HadithEnglishToJson(HadithEnglish instance) =>
    <String, dynamic>{'narrator': instance.narrator, 'text': instance.text};
