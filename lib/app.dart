import 'package:flutter/material.dart';

import 'shared/models/navbar_role.dart';

// import halaman di sini, bukan di main
import 'shared/auth/share/splash_screen.dart';
import 'shared/auth/share/signin_page.dart';
import 'shared/auth/share/signup_page.dart';

import 'modules/tata_usaha/menuTU.dart';
import 'modules/kepsek/menuukepsek.dart';
import 'modules/other/menuother.dart';

import 'shared/auth/pages/profile.dart';
import 'shared/auth/pages/notif.dart';

import 'shared/auth/pages/home.dart';
import 'shared/auth/share/welcome.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Simdis",
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const Home(role: NavbarRole.tu),
    );
  }
}
