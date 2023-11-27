// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/pages/admin_home.dart';
import 'package:watch_tower_flutter/pages/home.dart';
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
    loginUtils.setBaseUrl('http://192.168.1.11:3000/');
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
        backgroundColor: Colors.black,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: AppBar(backgroundColor: Color.fromARGB(57, 108, 126, 241))),
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
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'E-mail',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: mailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Mail',
                          prefixIconColor: Colors.grey,
                          filled: true,
                          fillColor: Color.fromARGB(57, 108, 126, 241),
                          prefixIcon: Icon(Icons.person_rounded),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          )),
                      style: TextStyle(
                        color: Colors.white,
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
                      height: 18.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      obscureText: !isPasswordVisible,
                      controller: passwordController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                          prefixIconColor: Colors.grey,
                          suffixIconColor: Colors.grey,
                          filled: true,
                          fillColor: Color.fromARGB(57, 108, 126, 241),
                          prefixIcon: Icon(Icons.lock),
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
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          )),
                      style: TextStyle(
                        color: Colors.white,
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
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.grey,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
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
                      size: 16,
                      color: Colors.grey,
                    ),
                    Text(' Remember me'),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
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
                            MaterialPageRoute(
                                builder: (context) => HomePage()),
                          );
                        }
                      }
                    }
                  },
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 30.0,
                child: TextButton(
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      height: 1.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Image(
                height: 250,
                image: AssetImage('assets/images/login.png'),
              ),
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
                      color: Colors.lightBlueAccent,
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
