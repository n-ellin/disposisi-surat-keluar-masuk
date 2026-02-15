import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart'; // pastikan path sesuai

class Home extends StatefulWidget {
  const Home({super.key});

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
                const Text(
                  "Disposisi Surat",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: h * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6DA8B4), Color(0xFF0F6E7A)],
                        ),
                        icon: Icons.move_to_inbox,
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
                        icon: Icons.outbox,
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
                  icon: Icons.move_to_inbox,
                ),
                SizedBox(height: h * 0.02),
                _menuCard(
                  title: "Surat Keluar",
                  subtitle: "Lihat dan pantau Surat Keluar",
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD6A66B), Color(0xFFDA7B17)],
                  ),
                  icon: Icons.outbox,
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
        role: NavbarRole.kepsek,
        currentIndex: _currentIndex,
        onTap: _onNavbarTap,
      ),
    );
  }

  static Widget _statCard({
    required LinearGradient gradient,
    required IconData icon,
    required String jumlah,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
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
            child: Icon(icon, color: Colors.white),
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
    required IconData icon,
  }) {
    return Container(
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
            child: Icon(icon, color: gradient.colors.last),
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
    );
  }
}
