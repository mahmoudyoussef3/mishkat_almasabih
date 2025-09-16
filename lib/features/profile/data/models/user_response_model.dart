import 'package:json_annotation/json_annotation.dart';

part 'user_response_model.g.dart';

@JsonSerializable()
class UserResponseModel {
  final int? id;
  final String? username;
  final String? email;
  final String? password;
  final String? role;
  @JsonKey(name: 'google_id')
  final String? googleId;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'bonus_points')
  final int? bonusPoints;
  @JsonKey(name: 'weekly_achievement_count')
  final int? weeklyAchievementCount;
  @JsonKey(name: 'last_white_days_fasting_date')
  final String? lastWhiteDaysFastingDate;
  @JsonKey(name: 'white_days_fasting_streak')
  final int? whiteDaysFastingStreak;
  @JsonKey(name: 'white_days_fasting_subscription')
  final int? whiteDaysFastingSubscription;
  @JsonKey(name: 'daily_hadith_email_enabled')
  final int? dailyHadithEmailEnabled;
  @JsonKey(name: 'google_access_token')
  final String? googleAccessToken;
  @JsonKey(name: 'google_refresh_token')
  final String? googleRefreshToken;
  @JsonKey(name: 'google_token_expiry')
  final String? googleTokenExpiry;

  UserResponseModel({
    this.id,
    this.username,
    this.email,
    this.password,
    this.role,
    this.googleId,
    this.avatarUrl,
    this.createdAt,
    this.bonusPoints,
    this.weeklyAchievementCount,
    this.lastWhiteDaysFastingDate,
    this.whiteDaysFastingStreak,
    this.whiteDaysFastingSubscription,
    this.dailyHadithEmailEnabled,
    this.googleAccessToken,
    this.googleRefreshToken,
    this.googleTokenExpiry,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseModelToJson(this);
}