import 'package:flutter/material.dart';
import '../custom_navbar.dart';
import '../../../modules/tata_usaha/dashboard/menuTU.dart';
import '../../../pages/tu/tu_history.dart';
import '../../../pages/tu/tu_profile.dart';
import '../../../pages/tu/tu_surat_masuk.dart';
import '../../../pages/tu/tu_surat_keluar.dart';

class TemplateTU extends StatefulWidget {
  const TemplateTU({super.key});

  @override
  State<TemplateTU> createState() => _TemplateTUState();
}

class _TemplateTUState extends State<TemplateTU> {
  int currentIndex = 0;

  final pages = const [
    TUHomePage(),
    TUHistory(),
    TUProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F4),
      body: pages[currentIndex],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: CustomNavbar(
          selectedIndex: currentIndex,
          onTap: (i) => setState(() => currentIndex = i),
          hasFloatingMenu: true,
          icons: const [
            Icons.home,
            Icons.history,
            Icons.person,
          ],
          onMenu1: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const TUSuratMasuk()));
          },
          onMenu2: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const TUSuratKeluar()));
          },
        ),
      ),
    );
  }
}