import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/shared/models/navbar_role.dart';

class ApprovalPage extends StatefulWidget {
  final NavbarRole role;

  const ApprovalPage({super.key, required this.role});

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  int _currentIndex = 1;

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    // 🔥 Navigasi page sesuai index
    if (widget.role == NavbarRole.tu) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, '/history');
      } else if (index == 3) {
        Navigator.pushReplacementNamed(context, '/profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.03),

              /// TITLE
              Center(
                child: Text(
                  "Persetujuan Akun",
                  style: TextStyle(
                    fontSize: w * 0.065,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bluePrimary,
                  ),
                ),
              ),

              SizedBox(height: h * 0.03),

              /// CARD USER
              Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    /// AVATAR
                    CircleAvatar(
                      radius: w * 0.07,
                      backgroundColor: Colors.grey.shade400,
                      child: Icon(
                        Icons.person,
                        size: w * 0.08,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(width: w * 0.04),

                    /// NAMA
                    Expanded(
                      child: Text(
                        "Husna Yanif",
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.w600,
                          color: AppColors.bluePrimary,
                        ),
                      ),
                    ),

                    /// BUTTON STATUS
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.008,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bluePrimary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Disetujui",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.03,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// NAVBAR
      bottomNavigationBar: CustomNavbar(
        role: widget.role,
        currentIndex: _currentIndex,
        onTap: _onNavbarTap,
      ),
    );
  }
}