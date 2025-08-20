// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_books_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalHadithResponse _$LocalHadithResponseFromJson(Map<String, dynamic> json) =>
    LocalHadithResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      data:
          json['data'] == null
              ? null
              : LocalHadithData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocalHadithResponseToJson(
  LocalHadithResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

LocalHadithData _$LocalHadithDataFromJson(Map<String, dynamic> json) =>
    LocalHadithData(
      currentPage: (json['currentPage'] as num?)?.toInt(),
      hadiths:
          (json['hadiths'] as List<dynamic>?)
              ?.map((e) => LocalHadith.fromJson(e as Map<String, dynamic>))
              .toList(),
      from: (json['from'] as num?)?.toInt(),
      to: (json['to'] as num?)?.toInt(),
      perPage: (json['perPage'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LocalHadithDataToJson(LocalHadithData instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'hadiths': instance.hadiths,
      'from': instance.from,
      'to': instance.to,
      'perPage': instance.perPage,
      'total': instance.total,
    };

LocalHadith _$LocalHadithFromJson(Map<String, dynamic> json) => LocalHadith(
  id: (json['id'] as num?)?.toInt(),
  hadithEnglish: json['hadithEnglish'] as String?,
  hadithUrdu: json['hadithUrdu'] as String?,
  hadithArabic: json['hadithArabic'] as String?,
  chapterId: json['chapterId'] as String?,
  bookSlug: json['bookSlug'] as String?,
);

Map<String, dynamic> _$LocalHadithToJson(LocalHadith instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hadithEnglish': instance.hadithEnglish,
      'hadithUrdu': instance.hadithUrdu,
      'hadithArabic': instance.hadithArabic,
      'chapterId': instance.chapterId,
      'bookSlug': instance.bookSlug,
    };
