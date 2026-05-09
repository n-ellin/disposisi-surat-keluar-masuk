import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/navigation_helper.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';

class ProfilePage extends StatelessWidget {
  final String nama;
  final String email;
  final String jabatan;
  final Role role;

  const ProfilePage({
    super.key,
    required this.nama,
    required this.email,
    required this.jabatan,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    const primary = Color(0xFF1E6D7B);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            color: primary,
            fontSize: w * 0.055,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
        child: Column(
          children: [
            SizedBox(height: h * 0.03),

            // ✅ AVATAR
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: CircleAvatar(
                radius: w * 0.14,
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, size: w * 0.14, color: Colors.white),
              ),
            ),

            SizedBox(height: h * 0.05),

            // ✅ EMAIL + PASSWORD
            // ✅ DATA PROFILE
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  _inputTile(
                    icon: Icons.work_outline,
                    label: "Jabatan",
                    value: jabatan,
                  ),

                  const SizedBox(height: 12),

                  _inputTile(
                    icon: Icons.person_outline,
                    label: "Nama",
                    value: nama,
                  ),

                  const SizedBox(height: 12),

                  _inputTile(
                    icon: Icons.email_outlined,
                    label: "Email",
                    value: email,
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.04),

            // ✅ KEAMANAN
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Keamanan",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  InkWell(
                    onTap: () {
                      // TODO: ke halaman ubah password
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.lock_reset, color: primary),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(child: Text("Ubah Kata Sandi")),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.05),

            // ✅ LOGOUT
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: logout
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  "Keluar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),

            SizedBox(height: h * 0.12),
          ],
        ),
      ),

      bottomNavigationBar: CustomNavbar(
        currentIndex: role == Role.tu ? 3 : 2,
        role: role,
        onTap: (index) {
          handleNavbarTap(context, index, role);
        },
      ),
    );
  }

  // ✅ CARD STYLE BIAR CONSISTENT
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  // ✅ INPUT TILE
  Widget _inputTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, color: Colors.grey.shade600, size: 22),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
