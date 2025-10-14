import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class SuggestionService {
  final Dio _dio = Dio();

  SuggestionService() {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
        compact: true,
      ),
    );
  }

  Future<bool> sendSuggestion(String suggestion) async {
    const String url =
        'https://script.google.com/macros/s/AKfycbxnb0r11KKu_kfalssuLIShI3emP_iJuKWTDtGjKM1KO3RwshWrtLuV8HpFTzY_Gd_IPA/exec';

    try {
      final response = await _dio.post(
        url,
        data: {'suggestion': suggestion},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          // السماح بالتحويل التلقائي في حالة 302
          followRedirects: false,
          validateStatus: (status) =>
              status != null && status < 400, // لا تعتبر 302 خطأ
          responseType: ResponseType.json,
        ),
      );

      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Data: ${response.data}');
      print('🔹 Redirect URL: ${response.headers['location']}');

      // التعامل مع حالة التحويل 302 يدويًا
      if (response.statusCode == 302) {
        final redirectUrl = response.headers['location']?.first;
        if (redirectUrl != null) {
          print('➡️ Redirecting to: $redirectUrl');
          final redirectedResponse = await _dio.get(redirectUrl);
          print('🔁 Redirected response: ${redirectedResponse.data}');
          return true;
        }
      }

      if (response.statusCode == 200) {
        if (response.data is Map && response.data['result'] == 'success') {
          print('✅ Suggestion sent successfully');
          return true;
        } else if (response.data is String &&
            response.data.contains('success')) {
          print('✅ Suggestion sent (HTML response)');
          return true;
        }
      }

      print('❌ Failed to send suggestion: ${response.statusCode}');
      return false;
    } catch (e) {
      print('⚠️ Error sending suggestion: $e');
      if (e is DioException) {
        print('Response: ${e.response?.data}');
      }
      return false;
    }
  }
}
