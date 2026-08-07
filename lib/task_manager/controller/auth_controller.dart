import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user_model.dart';

class AuthController {
  static UserModel? userModel;
  static String? accessToken;

  static Future<void> saveUserData(UserModel model, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user-data', jsonEncode(model.toJson()));
    await prefs.setString('token', token);

    userModel = model;
    accessToken = token;
  }

  static Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user-data');
    if (userDataString != null) {
      userModel = UserModel.fromJson(jsonDecode(userDataString));
    }
    accessToken = prefs.getString('token');
  }

  static Future<bool> isUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      await getUserData();
      return true;
    }
    return false;
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    userModel = null;
    accessToken = null;
  }
}
