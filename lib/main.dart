import 'package:flutter/material.dart';

// Import semua halaman
import 'pages/splashsc/splash_screen.dart';
import 'pages/Home/home_page.dart';
import 'pages/signin/signin_page.dart';
import 'pages/signup/signup_page.dart';
import 'pages/TU/menu/menuTu.dart';
import 'pages/kepsek/menuukepsek.dart';
import 'pages/other/menuother.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Simdis",
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),

      // Halaman pertama
      home: const TUHomePage(),

      //routes: {
      //'splash': (_) => const SplashScreen(),
      //'/welcome': (_) => const WelcomePage(),
      //'/signin': (_) => const SignIn(),
      //'/signup': (_) => const SignUp(),
      //'/menu_tu': (_) => const TUHomePage(),
      //'/menu_kepsek': (_) => const KepsekMenu(),
      //'/menu_other': (_) => const MenuOther(),
      //},
    );
  }
}
