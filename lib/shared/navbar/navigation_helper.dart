import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/navbar_role.dart';

void handleNavbarTap(
  BuildContext context,
  int index,
  NavbarRole role,
) {
  if (role == NavbarRole.tu) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/history_tu');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  } else if (role == NavbarRole.kepsek){
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/history_kepsek');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  else{ 
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/history_other');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }
}