// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseBody _$LoginResponseBodyFromJson(Map<String, dynamic> json) =>
    LoginResponseBody(
      message: json['message'] as String?,
      userData:
          json['data'] == null
              ? null
              : UserData.fromJson(json['data'] as Map<String, dynamic>),
      status: json['status'] as bool?,
      code: (json['code'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoginResponseBodyToJson(LoginResponseBody instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.userData,
      'status': instance.status,
      'code': instance.code,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  token: json['token'] as String?,
  userName: json['username'] as String?,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'token': instance.token,
  'username': instance.userName,
};
