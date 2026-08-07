import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../controller/auth_controller.dart';
import '../models/api_response.dart';

/// The only file in the project allowed to import `http`.
/// Every screen/widget calls through here — never `http` directly.
class ApiCaller {
  static const Duration _timeout = Duration(seconds: 15);

  static Map<String, String> get _headers => {
        'content-type': 'application/json',
        'token': AuthController.accessToken ?? '',
      };

  static Future<ApiResponse> getRequest({required String URL}) async {
    try {
      final uri = Uri.parse(URL);
      final response = await http.get(uri, headers: _headers).timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static Future<ApiResponse> postRequest({
    required String URL,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse(URL);
      final response = await http
          .post(uri, headers: _headers, body: jsonEncode(body ?? {}))
          .timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static Future<ApiResponse> putRequest({
    required String URL,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse(URL);
      final response = await http
          .put(uri, headers: _headers, body: jsonEncode(body ?? {}))
          .timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static Future<ApiResponse> deleteRequest({required String URL}) async {
    try {
      final uri = Uri.parse(URL);
      final response = await http.delete(uri, headers: _headers).timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static ApiResponse _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      return ApiResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Un-Authorized Token',
      );
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        isSuccess: true,
        statusCode: response.statusCode,
        responseData: decoded,
      );
    }

    return ApiResponse(
      isSuccess: false,
      statusCode: response.statusCode,
      responseData: decoded,
      errorMessage: (decoded is Map && decoded['data'] is String)
          ? decoded['data']
          : 'Something went wrong',
    );
  }
}
