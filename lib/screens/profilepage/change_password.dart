
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  var _isObscured;
  var _isObscured2;
  var _isObscured3;

  @override
  void initState() {
    // TODO: implement initState
    _isObscured = true;
    _isObscured2 = true;
    _isObscured3 = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 5,
        backgroundColor: Colors.white
        ,
        title:  Text(
          "Change Password",
          style:  GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _buildPasswordFields(),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.orange,
                  foregroundColor: Colors.white, backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                  onPressed: _changePassword,
                  child: const Text(

                    "Change Password",
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: _isObscured,
                decoration: InputDecoration(
                    labelText: "Old Password",
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                      icon: _isObscured
                          ? const Icon(
                        Icons.visibility_off,
                        size: 25,
                      )
                          : const Icon(
                        Icons.visibility,
                        size: 25,
                      ),
                    )),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _isObscured2,
                decoration: InputDecoration(
                    labelText: "New Password",
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscured2 = !_isObscured2;
                        });
                      },
                      icon: _isObscured2
                          ? const Icon(
                        Icons.visibility_off,
                        size: 25,
                      )
                          : const Icon(
                        Icons.visibility,
                        size: 25,
                      ),
                    )),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _isObscured3,
                decoration: InputDecoration(
                    labelText: "Confirm New Password",
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscured3 = !_isObscured3;
                        });
                      },
                      icon: _isObscured3
                          ? const Icon(
                        Icons.visibility_off,
                        size: 25,
                      )
                          : const Icon(
                        Icons.visibility,
                        size: 25,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _changePassword() {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    String fakeOldPassword = "oldpassword123";

    if (oldPassword != fakeOldPassword) {
      _showDialog("Error", "Old password is incorrect.");
    } else if (newPassword != confirmPassword) {
      _showDialog("Error", "New password and confirm password do not match.");
    } else {
      // Simulate a successful password change
      _showDialog("Success", "Password changed successfully.");
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
