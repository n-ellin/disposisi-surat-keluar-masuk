import 'package:flutter/material.dart';

// Import semua halaman
import 'shared/splash/splash_screen.dart';
import 'shared/home/home_page.dart';
import 'shared/auth/signin_page.dart';
import 'shared/auth/signup_page.dart';
import 'modules/tata_usaha/dashboard/menuTU.dart';
import 'modules/kepsek/dashboard/menuukepsek.dart';
import 'modules/other/dashboard/menuother.dart';
import 'modules/profile/profile.dart';
import 'modules/other/notifotth.dart';

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
      home: const TuDashboardPage(),
    );
  }
}
