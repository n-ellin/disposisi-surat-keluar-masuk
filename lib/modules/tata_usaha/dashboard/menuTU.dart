import 'package:flutter/material.dart';
import '../../../core/widgets/layouts/navbarTU.dart';

class TuDashboardPage extends StatelessWidget {
  const TuDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard TU'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _menuItem(
              icon: Icons.mail,
              label: 'Disposisi',
              onTap: () {
                // NANTI KE HALAMAN DISPOSISI TU
              },
            ),
            _menuItem(
              icon: Icons.inbox,
              label: 'Surat Masuk',
              onTap: () {},
            ),
            _menuItem(
              icon: Icons.send,
              label: 'Surat Keluar',
              onTap: () {},
            ),
            _menuItem(
              icon: Icons.history,
              label: 'Riwayat',
              onTap: () {},
            ),
          ],
        ),
      ),

      bottomNavigationBar: NavbarTU(
        currentIndex: 0,
        onTap: (index) {
          // atur navigasi navbar
        },
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
