import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/modules/kepsek/detail_surat/input_suratkeluar.dart';

import 'shared/models/navbar_role.dart';

// import halaman di sini, bukan di main
import 'shared/auth/share/splash_screen.dart';
import 'shared/auth/share/signin_page.dart';
import 'shared/auth/share/signup_page.dart';

import 'modules/tata_usaha/menuTU.dart';
import 'modules/tata_usaha/approval.dart';
import 'modules/kepsek/menuukepsek.dart';
import 'modules/other/menuother.dart';

import 'modules/kepsek/detail_surat/input_suratmasuk.dart';
import 'modules/kepsek/detail_surat/input_suratkeluar.dart';

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

      /// HALAMAN AWAL
      initialRoute: '/input_suratmasuk',

      /// SEMUA ROUTE APLIKASI
      routes: {
        '/welcome': (context) => const Welcome(),
        '/signin': (context) => const SignIn(),
        '/signup': (context) => const SignUp(),

        '/home': (context) => const Home(role: NavbarRole.tu),
        '/history': (context) => const MenuOther(),
        '/approval': (context) => const ApprovalPage(role: NavbarRole.tu),

        '/profile': (context) => const ProfilePage(
          role: NavbarRole.tu,
          nama: 'Nama User',
          email: 'user@email.com',
          jabatan: 'Tata Usaha',
          imagePath: 'assets/images/profile.jpg',
        ),

        '/notif': (context) => const NotificationPage(role: NavbarRole.tu),
        '/input_suratmasuk': (context) => const InputSuratMasuk(),
        '/input_suratkeluar': (context) => const InputSuratKeluar(),
      },
    );
  }
}
