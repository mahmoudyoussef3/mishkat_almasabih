import 'package:json_annotation/json_annotation.dart';

part 'chapter_ahadiths_model.g.dart';

@JsonSerializable()
class HadithResponse {
  final int? status;
  final String? message;
  final Hadiths? hadiths;
  

  HadithResponse({this.status, this.message, this.hadiths});
  factory HadithResponse.fromJson(Map<String, dynamic> json) =>
      _$HadithResponseFromJson(json);
}

@JsonSerializable()
class Hadiths {
  final int? current_page;
  final List<Hadith>? data;
  final String? first_page_url;
  final int? from;
  final int? last_page;
  final String? last_page_url;
  final List<HadithLink>? links;
  final String? next_page_url;
  final String? path;
  final String? per_page;
  final String? prev_page_url;
  final int? to;
  final int? total;

  Hadiths({
    this.current_page,
    this.data,
    this.first_page_url,
    this.from,
    this.last_page,
    this.last_page_url,
    this.links,
    this.next_page_url,
    this.path,
    this.per_page,
    this.prev_page_url,
    this.to,
    this.total,
  });
  factory Hadiths.fromJson(Map<String, dynamic> json) =>
      _$HadithsFromJson(json);
}

@JsonSerializable()
class Hadith {
  final int? id;
  final String? hadithNumber;
  final String? englishNarrator;
  final String? hadithEnglish;
  final String? hadithUrdu;
  final String? urduNarrator;
  final String? hadithArabic;
  final String? headingArabic;
  final String? headingUrdu;
  final String? headingEnglish;
  final String? chapterId;
  final String? bookSlug;
  final String? volume;
  final String? status;
  final HadithBook? book;
  final HadithChapter? chapter;

  Hadith({
    this.id,
    this.hadithNumber,
    this.englishNarrator,
    this.hadithEnglish,
    this.hadithUrdu,
    this.urduNarrator,
    this.hadithArabic,
    this.headingArabic,
    this.headingUrdu,
    this.headingEnglish,
    this.chapterId,
    this.bookSlug,
    this.volume,
    this.status,
    this.book,
    this.chapter,
  });
  factory Hadith.fromJson(Map<String, dynamic> json) => _$HadithFromJson(json);
}

@JsonSerializable()
class HadithBook {
  final int? id;
  final String? bookName;
  final String? writerName;
  final String? aboutWriter;
  final String? writerDeath;
  final String? bookSlug;

  HadithBook({
    this.id,
    this.bookName,
    this.writerName,
    this.aboutWriter,
    this.writerDeath,
    this.bookSlug,
  });
  factory HadithBook.fromJson(Map<String, dynamic> json) =>
      _$HadithBookFromJson(json);
}

@JsonSerializable()
class HadithChapter {
  final int? id;
  final String? chapterNumber;
  final String? chapterEnglish;
  final String? chapterUrdu;
  final String? chapterArabic;
  final String? bookSlug;

  HadithChapter({
    this.id,
    this.chapterNumber,
    this.chapterEnglish,
    this.chapterUrdu,
    this.chapterArabic,
    this.bookSlug,
  });
  factory HadithChapter.fromJson(Map<String, dynamic> json) =>
      _$HadithChapterFromJson(json);
}

@JsonSerializable()
class HadithLink {
  final String? url;
  final String? label;
  final bool? active;

  HadithLink({this.url, this.label, this.active});
  factory HadithLink.fromJson(Map<String, dynamic> json) =>
      _$HadithLinkFromJson(json);
}
