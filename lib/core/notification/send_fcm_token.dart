import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mishkat_almasabih/core/networking/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateFcmToken {
  static Future<void> sendFcmToken(String newFcmToken) async {
    final prefs = await SharedPreferences.getInstance();

    Response response;
    String url = '${ApiConstants.apiBaseUrl}/fcm-token';

    var data = {'fcm_token': newFcmToken};
    String? token = prefs.getString('token');
    var header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      response = await Dio().post(
        url,
        data: data,
        options: Options(headers: header),
      );
      if (response.statusCode == 200) {
        log(newFcmToken);
      } else {
        log('fcm failed to update');
      }
    } catch (e) {
      if (Dio is Error) {
        log('Dio error occurred: $e');
      } else if (e is Exception) {
        log('Exception occurred: $e');
      } else {
        log('Unknown error occurred: $e');
      }
      debugPrint('error occurred:$e');
    }
  }
}
