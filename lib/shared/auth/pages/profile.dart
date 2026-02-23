import 'package:flutter/material.dart';

import 'package:ta_mobile_disposisi_surat/core/constants/navigation_helper.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/shared/models/navbar_role.dart';

class ProfilePage extends StatelessWidget {
  final String nama;
  final String email;
  final String jabatan;
  final String imagePath;
  final NavbarRole role;

  const ProfilePage({
    super.key,
    required this.nama,
    required this.email,
    required this.jabatan,
    required this.imagePath,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            color: const Color(0xFF1E6D7B), // blue primary kamu
            fontSize: w * 0.055,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: h * 0.04),

            // Avatar
            Center(
              child: CircleAvatar(
                radius: w * 0.14,
                backgroundImage: AssetImage(imagePath),
              ),
            ),

            SizedBox(height: h * 0.06),

            _label("Nama"),
            _inputBox(nama, w),

            SizedBox(height: h * 0.025),

            _label("Email"),
            _inputBox(email, w),

            SizedBox(height: h * 0.025),

            _label("Jabatan"),
            _inputBox(jabatan, w),

            SizedBox(height: h * 0.06),

            // Logout
            InkWell(
              onTap: () {
                // TODO: logic logout
              },
              child: Row(
                children: const [
                  Icon(Icons.logout, color: Colors.black54),
                  SizedBox(width: 10),
                  Text("Keluar dari akun", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Hapus akun
            InkWell(
              onTap: () {
                // TODO: popup hapus akun
              },
              child: const Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 10),
                  Text(
                    "hapus akun",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.12),
          ],
        ),
      ),

      // ================= NAVBAR =================
      bottomNavigationBar: CustomNavbar(
        currentIndex: role == NavbarRole.tu ? 3 : 2,
        role: role,
        onTap: (index) {
          handleNavbarTap(context, index, role);
        },
      ),
    );
  }

  // ================= WIDGET LABEL =================
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ================= WIDGET INPUT BOX =================
  Widget _inputBox(String value, double w) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        value,
        style: TextStyle(fontSize: w * 0.038, color: Colors.black87),
      ),
    );
  }
}
