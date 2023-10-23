import 'dart:convert';
import '../services/http_service.dart';

class SignupError {
  bool isSignupDone = false;
  String errorEmailMessage = '';
  String errorPasswordMessage = '';

  setSignupDone(bool value) {
    isSignupDone = value;
  }

  setErrorEmailMessage(String value) {
    errorEmailMessage = value;
  }

  setErrorPasswordMessage(String value) {
    errorPasswordMessage = value;
  }
}

class SignupUtils {
  Future<SignupError> getLoginError(ApiResponse httpResponce) async {
    final jsonData = jsonDecode(httpResponce.response);
    SignupError signupError = SignupError();

    if (httpResponce.statusCode >= 399) {
      if (jsonData.containsKey('errors')) {
        var errors = jsonData['errors'];
        signupError.setErrorEmailMessage(errors['email']);
        signupError.setErrorPasswordMessage(errors['password']);
      }
    } else {
      if (jsonData.containsKey('user')) {
        signupError.setSignupDone(true);
      }
    }

    return signupError;
  }
}
