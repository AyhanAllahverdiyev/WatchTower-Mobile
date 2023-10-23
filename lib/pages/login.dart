
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import './signUp.dart';
import '../services/http_service.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  final httpService = HttpServices();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(36, 32, 50, 1000),
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
                        'Username',
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
                      controller: userNameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Username',
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
                      height: 20.0,
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
            SizedBox(
              height: 8.0,
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
                    String userName = userNameController.text;
                    String password = passwordController.text;
                    print(
                        "//////////////////////////////////////////////////////////////////////////");
                    bool loginTest =
                        await HttpServices().loginPost(userName, password);
                    print(loginTest);
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
                height: 270,
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
