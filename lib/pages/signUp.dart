// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import './login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => __SignUpPageState();
}

class __SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
    TextEditingController userNameController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      
      child: Scaffold(  
        
        backgroundColor: const Color.fromARGB(36,32,50,1000),
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70.0), 
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                ),
              backgroundColor: Color.fromARGB(57, 108, 126, 241),
            )
        ),
body: SafeArea(
            child: Column(children: [
          Center(
            child: Container(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 8, left: 20, right: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
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
                        hintText: 'User Name',
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
                    controller: emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'E-mail',
                        prefixIconColor: Colors.grey,
                        filled: true,
                        fillColor: Color.fromARGB(57, 108, 126, 241),
                        prefixIcon: Icon(Icons.email),
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
                  SizedBox(
                    height: 8.0,
                  ),
                    TextField(
                    obscureText: !isPasswordVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Confirm Password',
                        prefixIconColor: Colors.grey,
                        filled: true,
                        fillColor: Color.fromARGB(57, 108, 126, 241),
                        prefixIcon: Icon(Icons.lock),
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
                    'SIGN UP',
                    style: TextStyle(),
                  ),
                ),
                onPressed: () {
                  String email = emailController.text;
                  String userName = userNameController.text;
                  String password = passwordController.text;
                },
              ),
            ),
          ),
          
        ])),
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
                    "Already have an account?",
                    style: TextStyle(
                      color: Colors.grey,
                      height: 0.05,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
                TextButton(
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      height: 0.05,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
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
