import 'package:flutter/material.dart';

import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';

import 'package:ta_mobile_disposisi_surat/shared/auth/sharepage/home.dart';
import 'package:ta_mobile_disposisi_surat/shared/auth/sharepage/profile.dart';

void handleNavbarTap(
  BuildContext context,
  int index,
  Role role,
  String nama,
  String email,
  String jabatan,
) {
  switch (index) {

    /// HOME
    case 0:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Home(
            role: role,
            nama: nama,
            email: email,
            jabatan: jabatan,
          ),
        ),
      );
      break;

    /// HISTORY
    case 1:

      if (role == Role.tu) {
        Navigator.pushReplacementNamed(context, '/history_tu');

      } else if (role == Role.kepsek) {
        Navigator.pushReplacementNamed(context, '/history_kepsek');

      } else {
        Navigator.pushReplacementNamed(context, '/history_other');
      }

      break;

    /// PROFILE
    case 2:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProfilePage(
            nama: nama,
            email: email,
            jabatan: jabatan,
            role: role,
          ),
        ),
      );
      break;
  }
}