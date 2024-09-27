import 'package:accomodation_app/screens/bottom_nav_bar.dart';
import 'package:accomodation_app/screens/login_screen.dart';
import 'package:accomodation_app/screens/new_home.dart';
import 'package:accomodation_app/screens/tp.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        // home: LoadMoreInfiniteScrollingDemo()
        // home: HSMAccommodation()
        home: SignInScreen()

    );
  }
}
