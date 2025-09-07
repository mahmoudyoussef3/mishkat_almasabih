// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponseModel _$UserResponseModelFromJson(
  Map<String, dynamic> json,
) => UserResponseModel(
  id: (json['id'] as num?)?.toInt(),
  username: json['username'] as String?,
  email: json['email'] as String?,
  password: json['password'] as String?,
  role: json['role'] as String?,
  googleId: json['google_id'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  createdAt: json['created_at'] as String?,
  bonusPoints: (json['bonus_points'] as num?)?.toInt(),
  weeklyAchievementCount: (json['weekly_achievement_count'] as num?)?.toInt(),
  lastWhiteDaysFastingDate: json['last_white_days_fasting_date'] as String?,
  whiteDaysFastingStreak: (json['white_days_fasting_streak'] as num?)?.toInt(),
  whiteDaysFastingSubscription:
      (json['white_days_fasting_subscription'] as num?)?.toInt(),
  dailyHadithEmailEnabled:
      (json['daily_hadith_email_enabled'] as num?)?.toInt(),
  googleAccessToken: json['google_access_token'] as String?,
  googleRefreshToken: json['google_refresh_token'] as String?,
  googleTokenExpiry: json['google_token_expiry'] as String?,
);

Map<String, dynamic> _$UserResponseModelToJson(UserResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'role': instance.role,
      'google_id': instance.googleId,
      'avatar_url': instance.avatarUrl,
      'created_at': instance.createdAt,
      'bonus_points': instance.bonusPoints,
      'weekly_achievement_count': instance.weeklyAchievementCount,
      'last_white_days_fasting_date': instance.lastWhiteDaysFastingDate,
      'white_days_fasting_streak': instance.whiteDaysFastingStreak,
      'white_days_fasting_subscription': instance.whiteDaysFastingSubscription,
      'daily_hadith_email_enabled': instance.dailyHadithEmailEnabled,
      'google_access_token': instance.googleAccessToken,
      'google_refresh_token': instance.googleRefreshToken,
      'google_token_expiry': instance.googleTokenExpiry,
    };
