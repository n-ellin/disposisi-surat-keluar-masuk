import 'package:flutter/material.dart';

import 'core/constants/role.dart';

// AUTH
import 'shared/auth/sharepage/splash_screen.dart';
import 'shared/auth/sharepage/login.dart';
import 'shared/auth/sharepage/password/gantipw.dart';

// SHARED PAGE
import 'shared/auth/sharepage/profile.dart';
import 'shared/auth/sharepage/notif.dart';

// TATA USAHA
import 'modules/tata_usaha/menuTU.dart';
import 'modules/tata_usaha/history_tu.dart';
import 'modules/tata_usaha/detail_surat/output_suratkeluar.dart';
import 'modules/tata_usaha/detail_surat/output_suratmasuk.dart';

// KEPSEK
import 'modules/kepsek/menuukepsek.dart';
import 'modules/kepsek/detail_surat/input_suratmasuk.dart';
import 'modules/kepsek/detail_surat/input_suratkeluar.dart';
import 'modules/kepsek/history_kepsek.dart';

// OTHER
import 'modules/other/menuother.dart';
import 'modules/other/history_other.dart';
import 'modules/other/detailsurat.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "E-Disposisi",

      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,

        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.black26,
          selectionHandleColor: Colors.black,
        ),
      ),

      /// HALAMAN PERTAMA
      initialRoute: '/signin',

      /// ROUTES
      routes: {
        // ================= AUTH =================
        '/splash_screen': (context) => const SplashScreen(),
        

        '/signin': (context) => const Login(),

        '/gantipw': (context) => const GantiKataSandiPage(),

        // ================= PROFILE =================
        '/profile': (context) => const ProfilePage(
          role: Role.tu,
          nama: 'Nama User',
          email: 'user@email.com',
          jabatan: 'Tata Usaha',
        ),

        // ================= NOTIFICATION =================
        '/notif': (context) => const NotificationPage(role: Role.tu),

        // ================= HISTORY =================
        '/history_tu': (context) => const HistoryTUPage(),

        '/history_kepsek': (context) => const HistoryKepsekPage(),

        '/history_other': (context) => const HistoryOtherPage(),

        // ================= DETAIL SURAT =================
        '/input_suratmasuk': (context) {
          final surat =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;

          return InputSuratMasuk(surat: surat);
        },

        '/input_suratkeluar': (context) => const InputSuratKeluar(),

        '/output_suratmasuk': (context) => const OutputSuratmasuk(
          isApproved: true,
          catatan: "iya",
          tujuan: "Waka Kurikulum",
          instruksi: "Tindak lanjuti",
          koordinasi: '',
          diteruskanKe: '',
        ),

        '/output_suratkeluar': (context) =>
            const OutputSuratkeluar(catatan: "iya"),

        // ================= MENU =================
        '/menu_tu': (context) => const TuDashboardPage(jenisSurat: 'Masuk'),

        '/menu_kepsek': (context) =>
            const KepsekDashboardPage(jenisSurat: 'Masuk'),

        '/menu_other': (context) => const MenuOther(),

        // ================= OTHER =================
        '/detail_suratOther': (context) => const DetailSuratOther(),
      },
    );
  }
}
