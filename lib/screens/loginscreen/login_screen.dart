import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:accomodation_app/screens/homescreen/new_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../local_storage/shared_helpher.dart';
import '../bottomnavbar/bottom_nav_bar.dart';
import 'login_model.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  String LOGINKEY = "isLogin";
  bool? isLogin = false;

  void login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(LOGINKEY, true);
    Get.to( SignInScreen());
  }

  void logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(LOGINKEY, false);
  }
  Future<bool> loginUser() async {
    var url = "https://beds-accomodation.vercel.app/api/empLogin";
    var data = {"email": email.text, "password": password.text};
    var body = json.encode(data);
    var urlParse = Uri.parse(url);
    var response = await http.post(
      urlParse,
      body: body,
      headers: {"Content-Type": "application/json"},
    );

    try{
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        // Parse the response body
        var responseData = json.decode(response.body);
        var loginModel = LoginModel.fromJson(responseData);
        if (loginModel.success == 1) {
          print('Login successful');
          print('Response data: ${loginModel.message}');
          return true; // Indicate success
        } else {
          print('Login failed: ${loginModel.message}');
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login failed: ${loginModel.message}')));
          return false;
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('HTTP Error: ${response.statusCode}')));
        return false;
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('HTTP Error: ${response.statusCode}')));
      print("Exception: $e");
      return false;
    }

  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.withOpacity(0.6),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text(
                  "HSM",
                  style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 40.0),
                      TextFormField(
                        controller: email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black26,
                          ),
                          hintText: 'Enter Email',
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      TextFormField(
                        controller: password,
                        // obscureText: true,
                        // obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black26,
                          ),
                          hintText: 'Enter Password',
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Row(
                          //   children: [
                          //     Checkbox(
                          //       value: rememberPassword,
                          //       onChanged: (bool? value) {
                          //         setState(() {
                          //           rememberPassword = value!;
                          //         });
                          //       },
                          //       activeColor: Colors.black,
                          //     ),
                          //     Text(
                          //       'Remember me',
                          //       style: GoogleFonts.poppins(
                          //           fontSize: 14, color: Colors.black),
                          //     ),
                          //   ],
                          // ),
                          GestureDetector(
                            child: Text(
                              'Forget password?',
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          // onPressed: ()  async {
                          //  // loginUser();
                          //  // print("on pressed");
                          //   var loginSuccess =  loginUser();
                          //   if (await loginSuccess) {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 const BottomNavBar()));
                          //   }
                          // },
                          onPressed: () async {
                            bool loginSuccess = await loginUser();
                            if (loginSuccess) {
                              MySharedPref.setLoginStatus(true);
                              print("login status: ${MySharedPref.getLoginStatus()}");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const BottomNavBar()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
