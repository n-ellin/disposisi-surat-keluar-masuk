import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/modules/kepsek/menuukepsek.dart';

import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart'; // pastikan path sesuai
import 'package:ta_mobile_disposisi_surat/shared/models/navbar_role.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/navigation_helper.dart';
import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/menuTU.dart';

class Home extends StatefulWidget {
  final NavbarRole role;

  const Home({super.key, required this.role});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          // Tambahkan SingleChildScrollView untuk mencegah overflow vertikal
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.03),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// BARIS ATAS (logo + notif)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/images/logosmk.jpg",
                          width: w * 0.1,
                          height: w * 0.1,
                        ),

                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: w * 0.075,
                              color: AppColors.bluePrimary,
                            ),

                            Positioned(
                              right: -2, // ⬅️ keluar dikit biar nempel pojok
                              top: -2, // ⬅️ keluar dikit biar rapi
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: const Center(
                                  child: Text(
                                    "12",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// TEXT JUDUL DI BAWAH
                    const Text(
                      "Disposisi Surat",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: h * 0.03),

                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6DA8B4), Color(0xFF0F6E7A)],
                        ),
                        iconPath: "assets/icons/ic_inmail.svg",
                        jumlah: "10",
                        label: "Surat Masuk",
                      ),
                    ),
                    SizedBox(width: w * 0.04),
                    Expanded(
                      child: _statCard(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD6A66B), Color(0xFFDA7B17)],
                        ),
                        iconPath: "assets/icons/ic_outmail.svg",
                        jumlah: "10",
                        label: "Surat Keluar",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.04),
                const Text(
                  "Menu Surat",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: h * 0.02),
                _menuCard(
                  title: "Surat Masuk",
                  subtitle: "Lihat dan pantau Surat Masuk",
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6DA8B4), Color(0xFF0F6E7A)],
                  ),
                  iconPath: "assets/icons/ic_inmail.svg",
                  onTap: () {
                    if (widget.role == NavbarRole.tu) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const TuDashboardPage(jenisSurat: 'Surat Masuk'),
                        ),
                      );
                    } else if (widget.role == NavbarRole.kepsek) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KepsekDashboardPage(
                            jenisSurat: 'Surat Masuk',
                          ),
                        ),
                      );
                    }
                  },
                ),

                SizedBox(height: h * 0.02),
                _menuCard(
                  title: "Surat Keluar",
                  subtitle: "Lihat dan pantau Surat Keluar",
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD6A66B), Color(0xFFDA7B17)],
                  ),
                  iconPath: "assets/icons/ic_outmail.svg",
                  onTap: () {
                    if (widget.role == NavbarRole.tu) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const TuDashboardPage(jenisSurat: 'Surat Keluar'),
                        ),
                      );
                    } else if (widget.role == NavbarRole.kepsek) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KepsekDashboardPage(
                            jenisSurat: 'Surat Keluar',
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: h * 0.03,
                ), // Tambahkan sedikit padding bawah untuk ruang ekstra
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavbar(
        currentIndex: 0,
        role: widget.role,
        onTap: (index) {
          handleNavbarTap(context, index, widget.role);
        },
      ),
    );
  }

  Widget _statCard({
    required LinearGradient gradient,
    required String iconPath,
    required String jumlah,
    required String label,
  }) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(w * 0.05),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.last.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              color: Colors.white, // optional kalau mau tint warna
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            // ✅ TAMBAH INI
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jumlah,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _menuCard({
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.last.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                color: gradient.colors.last,
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
