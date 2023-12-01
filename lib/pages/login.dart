// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_tower_flutter/main.dart';
import 'package:watch_tower_flutter/pages/admin_home.dart';
import 'package:watch_tower_flutter/pages/home.dart';
import 'package:watch_tower_flutter/themes.dart';
import './signUp.dart';
import '../services/login_Services.dart';
import '../utils/login_utils.dart';
import '../utils/alert_utils.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_page';
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoginFailed = false;
  String errorEmailMessage = '';
  String errorPasswordMessage = '';
  bool checkedValue = false;
  final httpService = HttpServices();
  final loginUtils = LoginUtils();

  @override
  void initState() {
    canLogInWithJWT(context);
    loadSavedCredentials();
  }

  Future<bool> isJWTValid = HttpServices().checkIfTokenValid();
  Future<bool> canLogInWithJWT(BuildContext context) async {
    if (await isJWTValid) {
      String authLevel = await LoginUtils().getAuthLevel();
      if (authLevel == "admin" || authLevel == "super_admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      } else if (authLevel == "user") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }

      return true;
    } else {
      return false;
    }
  }

  Future<void> loadSavedCredentials() async {
    final credentials = await LoginUtils().loadSavedCredentials();

    setState(() {
      mailController.text = credentials.email;
      passwordController.text = credentials.password;
      checkedValue = credentials.rememberMe;
    });
  }

  void resetLoginPage() {
    setState(() {
      mailController.clear();
      passwordController.clear();
      checkedValue = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
              child: Column(children: [
            Center(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 8, left: 20, right: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image(
                        height: 100,
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Log in to continue',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: mailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'E-mail',
                          labelStyle:
                              TextStyle(color: Colors.blue, fontSize: 20),
                          prefixIconColor:
                              Theme.of(context).colorScheme.secondary,
                          prefixIcon: Icon(Icons.person_rounded),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    if (errorEmailMessage != '')
                      Text(
                        errorEmailMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        obscureText: !isPasswordVisible,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Password',
                          labelStyle:
                              TextStyle(color: Colors.blue, fontSize: 20),
                          prefixIcon: Icon(Icons.lock),
                          prefixIconColor:
                              Theme.of(context).colorScheme.secondary,
                          suffixIconColor:
                              Theme.of(context).colorScheme.secondary,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.remove_red_eye_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (errorPasswordMessage != '')
              Text(
                errorPasswordMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondary,
                      textStyle: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        checkedValue = !checkedValue;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          checkedValue
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 17,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        Text(' Remember me'),
                      ],
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5);
                        }
                        return null;
                      },
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(),
                    ),
                  ),
                  onPressed: () async {
                    String mail = mailController.text;
                    String password = passwordController.text;

                    print(
                        "//////////////////////////////////////////////////////////////////////////");
                    ApiResponse loginTest =
                        await HttpServices().loginPost(mail, password);
                    print(loginTest.statusCode);
                    if (loginTest.statusCode == 500 ||
                        loginTest.statusCode == -1) {
                      print("Login Failed!");
                      await AlertUtils().errorAlert("Login Failed!", context);
                    } else {
                      LoginError loginErrorResponse =
                          await LoginUtils().getLoginError(loginTest);
                      setState(() {
                        errorEmailMessage =
                            loginErrorResponse.errorEmailMessage;
                        errorPasswordMessage =
                            loginErrorResponse.errorPasswordMessage;
                      });
                      loginUtils.saveCredentials(
                        mail,
                        password,
                        checkedValue,
                      );

                      if (loginErrorResponse.isLoginDone &&
                          loginTest.statusCode <= 399 &&
                          loginTest.statusCode != -1) {
                        String authLevel = await LoginUtils().getAuthLevel();
                        if (authLevel == "admin" ||
                            authLevel == "super_admin") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminHomePage()),
                          );
                        } else if (authLevel == "user") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        }
                      }
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ])),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: SizedBox(
            height: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.grey,
                      height: 0.05,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                ),
                TextButton(
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.blue,
                      height: 0.05,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
