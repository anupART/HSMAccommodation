import 'package:accomodation_app/screens/bootomnavbar/bottom_nav_bar.dart';
import 'package:accomodation_app/screens/loginscreen/login_screen.dart';
import 'package:accomodation_app/screens/homescreen/new_home.dart';
import 'package:accomodation_app/screens/profilepage/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        // home: LoadMoreInfiniteScrollingDemo()
        home: HSMAccommodation()
        // home: ProfilePage()

    );
  }
}
