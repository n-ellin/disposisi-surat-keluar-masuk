import 'package:flutter/material.dart';

import 'core/constants/role.dart';

// ── AUTH ─────────────────────────────────────────────────────────────────────
import 'shared/auth/pages/splash_screen.dart';
import 'shared/auth/login_page.dart';
import 'shared/auth/change_password_page.dart';

// ── SHARED ───────────────────────────────────────────────────────────────────
import 'shared/auth/profile_page.dart';
import 'shared/widgets/notification_page.dart';

// ── TATA USAHA ───────────────────────────────────────────────────────────────
import 'features/tata usaha/pages/menuTU.dart';
import 'features/tata usaha/pages/history_tu.dart';
import 'features/tata usaha/pages/hasil_pengajuan_surat_keluar_page.dart';
import 'features/tata usaha/pages/hasil_disposisi_surat_masuk_page.dart';

// ── KEPALA SEKOLAH ───────────────────────────────────────────────────────────
import 'features/kepsek/pages/menu_kepsek_page.dart';
import 'features/kepsek/pages/disposisi_suratmasuk.dart';
import 'features/kepsek/pages/pengajuan_suratkeluar.dart';
import 'features/kepsek/pages/history_kepsek_page.dart';

// ── USER / OTHER ─────────────────────────────────────────────────────────────
import 'features/users/pages/menu_user_page.dart';
import 'features/users/pages/history_user_page.dart';
import 'features/users/pages/detail_surat_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Disposisi',

      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.black26,
          selectionHandleColor: Colors.black,
        ),
      ),

      initialRoute: '/splash_screen',

      routes: {
        // ── AUTH ───────────────────────────────────────────────────────────
        '/splash_screen': (context) => const SplashScreen(),
        '/signin':        (context) => const Login(),
        '/gantipw':       (context) => const GantiKataSandiPage(),

        // ── SHARED ─────────────────────────────────────────────────────────
        '/profile': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return ProfilePage(
            role:    args['role']    as Role,
            nama:    args['nama']    as String,
            email:   args['email']   as String,
            jabatan: args['jabatan'] as String,
          );
        },
        '/notif': (context) =>
            NotificationPage(role: Role.tu, notifications: const []),

        // ── TATA USAHA ─────────────────────────────────────────────────────
        '/menu_tu':    (context) => const TuDashboardPage(jenisSurat: 'Surat Masuk'),
        '/history_tu': (context) => const HistoryTUPage(),
        '/output_suratmasuk': (context) => const OutputSuratmasuk(
          isApproved:   true,
          catatan:      '-',
          tujuan:       '-',
          instruksi:    '-',
          koordinasi:   '-',
          diteruskanKe: '-',
        ),
        '/output_suratkeluar': (context) =>
            const OutputSuratkeluar(catatan: '-'),

        // ── KEPALA SEKOLAH ─────────────────────────────────────────────────
        '/menu_kepsek':    (context) => const KepsekDashboardPage(jenisSurat: 'Surat Masuk'),
        '/history_kepsek': (context) => const HistoryKepsekPage(),
        '/input_suratmasuk': (context) {
          final surat = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return InputSuratMasuk(surat: surat);
        },
        '/input_suratkeluar': (context) => const InputSuratKeluar(),

        // ── USER / OTHER ───────────────────────────────────────────────────
        '/menu_other':    (context) => const MenuUser(),
        '/history_other': (context) => const HistoryUsersPage(),
        '/detail_suratUsers': (context) {
          final surat = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return DetailSuratUsers(surat: surat);
        },
      },
    );
  }
}