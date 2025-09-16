import 'package:json_annotation/json_annotation.dart';

part 'local_books_model.g.dart';

@JsonSerializable()
class LocalHadithResponse {
  final int? status;
  final LocalHadithsWrapper? hadiths;

  LocalHadithResponse({this.status, this.hadiths});

  factory LocalHadithResponse.fromJson(Map<String, dynamic> json) =>
      _$LocalHadithResponseFromJson(json);
                      Map<String,dynamic> toJson()=>_$LocalHadithResponseToJson(this);

}

@JsonSerializable()
class LocalHadithsWrapper {
  final List<LocalHadith>? data;

  LocalHadithsWrapper({this.data});

  factory LocalHadithsWrapper.fromJson(Map<String, dynamic> json) =>
      _$LocalHadithsWrapperFromJson(json);
                            Map<String,dynamic> toJson()=>_$LocalHadithsWrapperToJson(this);

}

@JsonSerializable()
class LocalHadith {
  final int? id;
  final int? idInBook;
  final int? chapterId;
  final int? bookId;
  final String? arabic;
  final EnglishHadith? english;

  LocalHadith({
    this.id,
    this.idInBook,
    this.chapterId,
    this.bookId,
    this.arabic,
    this.english,
  });

  factory LocalHadith.fromJson(Map<String, dynamic> json) =>
      _$LocalHadithFromJson(json);

                                  Map<String,dynamic> toJson()=>_$LocalHadithToJson(this);

}

@JsonSerializable()
class EnglishHadith {
  final String? narrator;
  final String? text;

  EnglishHadith({this.narrator, this.text});

  factory EnglishHadith.fromJson(Map<String, dynamic> json) =>
      _$EnglishHadithFromJson(json);
                                        Map<String,dynamic> toJson()=>_$EnglishHadithToJson(this);

}