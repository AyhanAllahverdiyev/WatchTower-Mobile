import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/pages/login.dart';
import 'package:watch_tower_flutter/utils/alert_utils.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';
import "../components/bottom_navigation.dart";
import '../services/login_Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _newpasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _oldPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Current Password',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                     
                      controller: _newpasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        
                          
                  
                        ),
                        labelText: 'New Password',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _confirmNewPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'Confirm New Password',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width -48,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String email = prefs.getString('email') ?? '';
                        if (email != '' &&
                            _newpasswordController.text.isNotEmpty &&
                            _confirmNewPasswordController.text.isNotEmpty &&
                            _newpasswordController.text ==
                                _confirmNewPasswordController.text) {
                          // ignore: use_build_context_synchronously
                          ApiResponse passwordChangeResult = await HttpServices()
                              .changePassword(
                                  context,
                                  email,
                                  _oldPasswordController.text,
                                  _newpasswordController.text);
                          if (passwordChangeResult.statusCode <= 399) {
                            prefs.remove('jwt');
                            prefs.setString("password", _newpasswordController.text);
                            await AlertUtils().successfulAlert(
                                passwordChangeResult.response, context);
                        
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                              (route) => false,
                            );
                          } else {
                            await AlertUtils()
                                .errorAlert(passwordChangeResult.response, context);
                          }
                        } else if (_confirmNewPasswordController.text.isNotEmpty &&
                            _newpasswordController.text !=
                                _confirmNewPasswordController.text) {
                          AlertUtils().errorAlert("Passwords do not match", context);
                        } else if (email == '' ||
                            _newpasswordController.text.isEmpty ||
                            _confirmNewPasswordController.text.isEmpty) {
                          AlertUtils().errorAlert("Please fill out all ", context);
                        }
                      },
                      child: Text('Confirm',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBarWidget(
        pageName: "ProfilePage",
      ),
    );
  }
}
