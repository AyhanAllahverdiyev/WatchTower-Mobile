// ignore_for_file: override_on_non_overriding_member

import 'dart:convert';

import '../services/login_Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginError {
  bool isLoginDone = false;
  String errorEmailMessage = '';
  String errorPasswordMessage = '';

  setisLoginDone(bool value) {
    isLoginDone = value;
  }

  setErrorEmailMessage(String value) {
    errorEmailMessage = value;
  }

  setErrorPasswordMessage(String value) {
    errorPasswordMessage = value;
  }
}

class Credentials {
  String email;
  String password;
  bool rememberMe;

  Credentials(this.email, this.password, this.rememberMe);
}

class LoginUtils {
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  String baseUrl = 'http://192.168.1.141:3000/';
  Future<void> setBaseUrl(String newBaseUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseUrl', newBaseUrl);
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<LoginError> getLoginError(ApiResponse httpResponce) async {
    final jsonData = jsonDecode(httpResponce.response);
    LoginError loginError = LoginError();

    if (httpResponce.statusCode >= 399) {
      if (jsonData.containsKey('errors')) {
        var errors = jsonData['errors'];
        loginError.setErrorEmailMessage(errors['email']);
        loginError.setErrorPasswordMessage(errors['password']);
      }
    } else {
      if (jsonData.containsKey('user')) {
        loginError.setisLoginDone(true);
        var authLevel = jsonData['auth_level'];
        var user = jsonData['user'];

        saveUserInfo(authLevel, user);
      }
    }

    return loginError;
  }

  Future<Credentials> loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    String mailController = prefs.getString('email') ?? '';
    String passwordController = prefs.getString('password') ?? '';
    bool checkedValue = prefs.getBool('rememberMe') ?? false;

    return Credentials(mailController, passwordController, checkedValue);
  }

  Future<void> saveCredentials(
      String mail, String password, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      prefs.setString('email', mail);
      prefs.setString('password', password);
      prefs.setBool('rememberMe', true);
    } else {
      prefs.remove('email');
      prefs.remove('password');
      prefs.setBool('rememberMe', false);
      prefs.setString('id', "null");
    }
  }

  void printAllSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final allPrefs = prefs.getKeys();

    print('======= All SharedPreferences =======');
    for (var key in allPrefs) {
      final value = prefs.get(key);
      print('$key: $value');
    }
    print('======= End of SharedPreferences =======');
  }

  Future<void> saveUserInfo(String authLevel, String user) async {
    final prefsUser = await SharedPreferences.getInstance();
    prefsUser.setString('authLevel', authLevel);
    prefsUser.setString('user', user);
  }

  Future<String> getAuthLevel() async {
    final prefsUser = await SharedPreferences.getInstance();
    String authLevel = prefsUser.getString('authLevel') ?? 'user';
    return authLevel;
  }

  Future<String> getUserId() async {
    final prefsUser = await SharedPreferences.getInstance();
    String user = prefsUser.getString('user') ?? 'user';
    return user;
  }
}
