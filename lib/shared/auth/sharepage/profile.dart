import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/auth/sharepage/login.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/navigation_helper.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.055),

          child: Column(
            children: [
              SizedBox(height: h * 0.02),

              Text(
                "Profile",
                style: TextStyle(
                  color: AppColors.bluePrimary,
                  fontSize: w * 0.065,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: h * 0.03),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(w * 0.008),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                    ),

                    child: CircleAvatar(
                      radius: w * 0.10,
                      backgroundColor: Colors.grey.shade200,

                      child: Icon(
                        Icons.person,
                        size: w * 0.11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.035),

              _cardWrapper(
                child: Column(
                  children: [
                    _profileTile(
                      context,
                      icon: Icons.work_outline,
                      label: "JABATAN",
                      value: jabatan,
                    ),

                    SizedBox(height: h * 0.015),

                    _profileTile(
                      context,
                      icon: Icons.person_outline,
                      label: "NAMA",
                      value: nama,
                    ),

                    SizedBox(height: h * 0.015),

                    _profileTile(
                      context,
                      icon: Icons.email_outlined,
                      label: "EMAIL",
                      value: email,
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.025),

              _cardWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Keamanan",
                      style: TextStyle(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: h * 0.02),

                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {},

                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(w * 0.03),

                            decoration: BoxDecoration(
                              color: AppColors.bluePrimary.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: Icon(
                              Icons.lock_outline,
                              color: AppColors.bluePrimary,
                              size: w * 0.055,
                            ),
                          ),

                          SizedBox(width: w * 0.04),

                          Expanded(
                            child: Text(
                              "Ubah Kata Sandi",
                              style: TextStyle(
                                fontSize: w * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          Icon(
                            Icons.chevron_right,
                            size: w * 0.07,
                            color: Colors.grey.shade500,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.035),

              SizedBox(
                width: double.infinity,

                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: h * 0.018),
                    side: BorderSide(color: Colors.red.shade400, width: 1.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SignIn()),
                      (route) => false,
                    );
                  },

                  icon: Icon(Icons.logout, color: Colors.red, size: w * 0.05),

                  label: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.02),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomNavbar(
        currentIndex: 2,
        role: role,
        onTap: (index) {
          handleNavbarTap(context, index, role);
        },
      ),
    );
  }

  Widget _cardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: const Color(0xFFE5E7EB)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: child,
    );
  }

  Widget _profileTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: w * 0.025),

      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(w * 0.018),

            decoration: BoxDecoration(
              color: const Color(0xFFEDEFF3),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(icon, size: w * 0.045, color: AppColors.bluePrimary),
          ),

          SizedBox(width: w * 0.03),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: w * 0.025,
                    letterSpacing: 1,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: w * 0.008),

                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: w * 0.036,
                    fontWeight: FontWeight.w500,
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