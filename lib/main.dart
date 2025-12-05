import 'package:flutter/material.dart';

// Import semua halaman
import 'pages/splashsc/splash_screen.dart';
import 'pages/Home/home_page.dart';
import 'pages/signin/signin_page.dart';
import 'pages/signup/signup_page.dart';
import 'pages/TU/menuTU.dart';
import 'pages/kepsek/menuukepsek.dart';
import 'pages/other/menuother.dart';
import 'pages/profile/profile.dart';
import 'pages/other/notifotth.dart';

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

      // Halaman pertama → Splash
      home: const ProfilePage(),
    );
  }
}
