import 'dart:convert';

import 'package:http/http.dart';

class NetworkResponse {
  final bool success;
  final int statusCode;
  final Map<String, dynamic> body;
  final String errorMessage;

  NetworkResponse({
    required this.success,
    required this.statusCode,
    required this.body,
    required this.errorMessage,
  });
}

class NetworkCaller {
  static const String _defaultErrorMessage = 'Something went wrong';
  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      Response response = await get(uri);
      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          success: true,
          statusCode: response.statusCode,
          body: decodedJson,
          errorMessage: '',
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          success: false,
          statusCode: response.statusCode,
          body: {},
          errorMessage: decodedJson['data'] ?? _defaultErrorMessage,
        );
      }
    } catch (e) {
      return NetworkResponse(
        success: false,
        statusCode: -1,
        body: {},
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest({
    required String url,
    required Map<String, String>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      Response response = await post(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          success: true,
          statusCode: response.statusCode,
          body: decodedJson,
          errorMessage: '',
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          success: false,
          statusCode: response.statusCode,
          body: {},
          errorMessage: decodedJson['data'] ?? _defaultErrorMessage,
        );
      }
    } catch (e) {
      return NetworkResponse(
        success: false,
        statusCode: -1,
        body: {},
        errorMessage: e.toString(),
      );
    }
  }
}
