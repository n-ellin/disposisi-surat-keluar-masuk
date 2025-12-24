import 'package:flutter/material.dart';

// IMPORT DASHBOARD PER ROLE
import '../../modules/tata_usaha/dashboard/menuTU.dart';
import '../../modules/kepsek/dashboard/menuukepsek.dart';
import '../../modules/other/dashboard/menuother.dart';

class AuthController {
  // SIMPAN ROLE (DUMMY)
  static String? currentRole;

  // LOGIN DUMMYkasih putih
  static Future<void> login({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    // SIMULASI DELAY LOGIN
    await Future.delayed(const Duration(seconds: 1));

    // LOGIKA DUMMY ROLE
    if (username == 'tu') {
      currentRole = 'tu';
      _goToDashboard(context, const TuDashboardPage());
    } else if (username == 'kepsek') {
      currentRole = 'kepsek';
      _goToDashboard(context, const KepsekDashboardPage());
    } else {
      currentRole = 'other';
      _goToDashboard(context, const OtherDashboardPage());
    }
  }

  // NAVIGASI KE DASHBOARD
  static void _goToDashboard(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // LOGOUT
  static void logout(BuildContext context) {
    currentRole = null;
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
