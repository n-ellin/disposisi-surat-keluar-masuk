import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants/role.dart';

// Shared Pages
import 'shared/auth/sharepage/splash_screen.dart';
import 'shared/auth/sharepage/login.dart';
import 'shared/auth/sharepage/profile.dart';
import 'shared/auth/sharepage/notif.dart';
import 'shared/auth/sharepage/home.dart';

// Tata Usaha
import 'modules/tata_usaha/menuTU.dart';
import 'modules/tata_usaha/detail_surat/output_suratkeluar.dart';
import 'modules/tata_usaha/detail_surat/output_suratmasuk.dart';
import 'modules/tata_usaha/history_tu.dart';

// Kepsek
import 'modules/kepsek/menuukepsek.dart';
import 'modules/kepsek/detail_surat/input_suratmasuk.dart';
import 'modules/kepsek/detail_surat/input_suratkeluar.dart';
import 'modules/kepsek/history_kepsek.dart';

// Other
import 'modules/other/menuother.dart';
import 'modules/other/history_other.dart';
import 'modules/other/detailsurat.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Simdis",

      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,

        scaffoldBackgroundColor: Colors.white,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,

          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),

        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.black26,
          selectionHandleColor: Colors.black,
        ),
      ),

      initialRoute: '/signin',

      routes: {
        // Splash & Auth
        '/splash_screen': (context) => const SplashScreen(),
        '/signin': (context) => const SignIn(),

        // Home
        '/home': (context) => const Home(
              role: Role.kepsek,
            ),

        // Profile
        '/profile': (context) => const ProfilePage(
              role: Role.tu,
              nama: 'Nama User',
              email: 'user@email.com',
              jabatan: 'Tata Usaha',
            ),

        // Notification
        '/notif': (context) => const NotificationPage(
              role: Role.tu,
            ),

        // Kepsek
        '/history_kepsek': (context) => const HistoryKepsekPage(),

        '/input_suratmasuk': (context) => const InputSuratMasuk(),

        '/input_suratkeluar': (context) => const InputSuratKeluar(),

        // Tata Usaha
        '/history_tu': (context) => const HistoryTUPage(),

        '/output_suratkeluar': (context) =>
            const OutputSuratkeluar(
              catatan: "iya",
            ),

        '/output_suratmasuk': (context) => const OutputSuratmasuk(
              isApproved: true,
              catatan: "iya",
              tujuan: "Waka Kurikulum",
              instruksi: "Tindak lanjuti",
              koordinasi: '',
              diteruskanKe: '',
              sifat: '',
            ),

        // Other
        '/history_other': (context) => const HistoryOtherPage(),

        '/detail_suratOther': (context) =>
            const DetailSuratOther(),
      },
    );
  }
}