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
        backgroundColor: Color.fromARGB(57, 108, 126, 241),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Change password',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
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
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
                    labelText: 'Confirm New Password',
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
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
                child: Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBarWidget(
        pageName: "ProfilePage",
      ),
    );
  }
}
