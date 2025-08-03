import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/models/user_model.dart';

class AuthController {
  static UserModel? userModel;
  static String? accessToken;

  static const String _userDataKey = 'user-data';
  static const String _tokenKey = 'token';

  static Future<void> saveUserData(UserModel model, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(model.toJson()));
    await prefs.setString(_tokenKey, token);
    userModel = model;
    accessToken = token;
  }

  static Future<UserModel?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userModel = UserModel.fromJson(jsonDecode(prefs.getString(_userDataKey)!));
    accessToken = prefs.getString(_tokenKey);
    return userModel;
  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_tokenKey);
    if(token != null){
      await getUserData();
      return true;

    }else{
      return false;
    }
  }

  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user-data');
    await prefs.remove('token');
  }
}
