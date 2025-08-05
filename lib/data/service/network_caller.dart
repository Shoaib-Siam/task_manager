import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';

import '../../app.dart';
import '../../ui/screens/sign_in_screen.dart';

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
  static const String _unAuthorizedErrorMessage = 'un-authorized';

  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      Response response = await get(uri);

      _logRequest('GET', url, null, null);
      _logResponse(url, response);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          success: true,
          statusCode: response.statusCode,
          body: decodedJson,
          errorMessage: '',
        );
      } else if (response.statusCode == 401) {
        await _onUnAuthorized();
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          success: false,
          statusCode: response.statusCode,
          body: {},
          errorMessage:
              decodedJson['data']?.toString() ?? _unAuthorizedErrorMessage,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          success: false,
          statusCode: response.statusCode,
          body: {},
          errorMessage: decodedJson['data']?.toString() ?? _defaultErrorMessage,
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
    bool isFromLogin = false,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      final encodedBody = jsonEncode(body);

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'token': AuthController.accessToken ?? '',
      };

      _logRequest('POST', url, body, headers);

      Response response = await post(uri, body: encodedBody, headers: headers);

      _logResponse(url, response);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          success: true,
          statusCode: response.statusCode,
          body: decodedJson,
          errorMessage: '',
        );
      } else if (response.statusCode == 401) {
        if (isFromLogin == false) {
          await _onUnAuthorized();
        }
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          success: false,
          statusCode: response.statusCode,
          body: {},
          errorMessage:
              decodedJson['data']?.toString() ?? _unAuthorizedErrorMessage,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          success: false,
          statusCode: response.statusCode,
          body: {},
          errorMessage: decodedJson['data']?.toString() ?? _defaultErrorMessage,
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

  static void _logRequest(
    String method,
    String url,
    Map<String, String>? body,
    Map<String, String>? headers,
  ) {
    debugPrint(
      '========== Request =========='
      '\nMethod: $method'
      '\nURL: $url'
      '\nHeaders: ${headers?.toString() ?? 'No headers'}'
      '\nBody: ${body?.toString() ?? 'No body'}'
      '\n=============================',
    );
  }

  static void _logResponse(String url, Response response) {
    debugPrint(
      '========== Response =========='
      '\nURL: $url'
      '\nStatus Code: ${response.statusCode}'
      '\nBody: ${response.body}'
      '\n==============================',
    );
  }

  static Future<void> _onUnAuthorized() async {
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
      TaskManagerApp.navigator.currentContext!,
      SignInScreen.routeName,
      (predicate) => false,
    );
  }
}
