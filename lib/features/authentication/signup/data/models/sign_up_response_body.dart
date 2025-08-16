import 'package:json_annotation/json_annotation.dart';
part 'sign_up_response_body.g.dart';

@JsonSerializable()
class SignUpResponseBody {
  String? msg;
  @JsonKey(name: 'data')
  UserData? userData;
  bool? status;
  int? code;

  SignUpResponseBody({this.msg, this.userData, this.status, this.code});

  factory SignUpResponseBody.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseBodyFromJson(json);
}

@JsonSerializable()
class UserData {
  String? token;
  @JsonKey(name: 'username')
  String? userName;

  UserData({this.token, this.userName});

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
