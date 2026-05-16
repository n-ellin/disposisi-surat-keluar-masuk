import 'package:flutter/material.dart';

import 'core/constants/role.dart';

// AUTH
import 'shared/auth/pages/splash_screen.dart';
import 'shared/auth/login_page.dart';
import 'shared/auth/change_password_page.dart';

// SHARED PAGE
import 'shared/auth/profile_page.dart';
import 'shared/widgets/notification_page.dart';

// TATA USAHA
import 'features/tata usaha/pages/menuTU.dart';
import 'features/tata usaha/pages/history_tu.dart';
import 'features/tata usaha/pages/hasil_pengajuan_surat_keluar_page.dart';
import 'features/tata usaha/pages/hasil_disposisi_surat_masuk_page.dart';

// KEPSEK
import 'features/kepsek/pages/menu_kepsek_page.dart';
import 'features/kepsek/pages/disposisi_suratmasuk.dart';
import 'features/kepsek/pages/pengajuan_suratkeluar.dart';
import 'features/kepsek/pages/history_kepsek_page.dart';

// OTHER
import 'features/users/pages/menu_user_page.dart';
import 'features/users/pages/history_user_page.dart';
import 'features/users/pages/detail_surat_page.dart';

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
        '/notif': (context) =>
            NotificationPage(role: Role.tu, notifications: []),

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

        '/menu_other': (context) => const MenuUser(),

        // ================= OTHER =================
        '/detail_suratUsers': (context) {
          final surat =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return DetailSuratUsers(surat: surat);
        },
      },
    );
  }
}
