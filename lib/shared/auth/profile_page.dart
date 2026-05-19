import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';
import 'package:ta_mobile_disposisi_surat/core/helpers/navigation_helper.dart';
import 'package:ta_mobile_disposisi_surat/shared/auth/change_password_page.dart';
import 'package:ta_mobile_disposisi_surat/shared/auth/login_page.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';

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
    final size = MediaQuery.of(context).size;

    final w = size.width;
    final h = size.height;

    /// NOTE:
    /// responsive font scale
    double rf(double size) {
      return (w * (size / 375)).clamp(
        size * 0.9,
        size * 1.2,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),

            /// NOTE:
            /// maxWidth supaya tetap rapi di tablet
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.055,
              ),

              child: Column(
                children: [
                  SizedBox(height: h * 0.02),

                  /// TITLE
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: AppColors.bluePrimary,
                      fontSize: rf(24),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: h * 0.03),

                  /// AVATAR
                  Container(
                    padding: EdgeInsets.all(
                      (w * 0.008).clamp(3, 6),
                    ),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 2,
                      ),
                    ),

                    child: CircleAvatar(
                      radius: (w * 0.10).clamp(38, 52),

                      backgroundColor:
                          Colors.grey.shade200,

                      child: Icon(
                        Icons.person,

                        size: (w * 0.11).clamp(40, 56),

                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.035),

                  /// INFO CARD
                  _cardWrapper(
                    w: w,

                    child: Column(
                      children: [
                        _profileTile(
                          context,

                          icon: Icons.work_outline,

                          label: 'JABATAN',

                          value: jabatan,

                          rf: rf,
                        ),

                        SizedBox(height: h * 0.015),

                        _profileTile(
                          context,

                          icon: Icons.person_outline,

                          label: 'NAMA',

                          value: nama,

                          rf: rf,
                        ),

                        SizedBox(height: h * 0.015),

                        _profileTile(
                          context,

                          icon: Icons.email_outlined,

                          label: 'EMAIL',

                          value: email,

                          rf: rf,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: h * 0.025),

                  /// KEAMANAN CARD
                  _cardWrapper(
                    w: w,

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Keamanan',

                          style: TextStyle(
                            fontSize: rf(15),
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: h * 0.02),

                        InkWell(
                          borderRadius:
                              BorderRadius.circular(14),

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const GantiKataSandiPage(),
                              ),
                            );
                          },

                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                  (w * 0.03).clamp(
                                    10,
                                    14,
                                  ),
                                ),

                                decoration: BoxDecoration(
                                  color: AppColors
                                      .bluePrimary
                                      .withOpacity(0.10),

                                  borderRadius:
                                      BorderRadius.circular(
                                    12,
                                  ),
                                ),

                                child: Icon(
                                  Icons.lock_outline,

                                  color:
                                      AppColors.bluePrimary,

                                  size: rf(22),
                                ),
                              ),

                              SizedBox(width: w * 0.04),

                              Expanded(
                                child: Text(
                                  'Ubah Kata Sandi',

                                  overflow:
                                      TextOverflow.ellipsis,

                                  style: TextStyle(
                                    fontSize: rf(15),

                                    fontWeight:
                                        FontWeight.w500,
                                  ),
                                ),
                              ),

                              Icon(
                                Icons.chevron_right,

                                size: rf(28),

                                color:
                                    Colors.grey.shade500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: h * 0.035),

                  /// LOGOUT BUTTON
                  SizedBox(
                    width: double.infinity,

                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: h * 0.018,
                        ),

                        side: BorderSide(
                          color: Colors.red.shade400,
                          width: 1.4,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),

                      onPressed: () =>
                          _showLogoutDialog(context, rf),

                      child: Text(
                        'Keluar',

                        style: TextStyle(
                          color: Colors.red,

                          fontSize: rf(15),

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
        ),
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomNavbar(
            currentIndex: 2,
            role: role,
            onTap: (index) {
              handleNavbarTap(
                context,
                index,
                role,
                nama,
                email,
                jabatan,
              );
            },
          ),

          ColoredBox(
            color: AppColors.bg,

            child: SizedBox(
              height:
                  MediaQuery.of(context).padding.bottom,

              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }

  // ── LOGOUT DIALOG ─────────────────────────────────────────────────────────────

  void _showLogoutDialog(
    BuildContext context,
    double Function(double) rf,
  ) {
    final w = MediaQuery.of(context).size.width;

    showGeneralDialog(
      context: context,

      barrierDismissible: true,

      barrierLabel: "Logout",

      barrierColor: Colors.black.withOpacity(0.45),

      transitionDuration:
          const Duration(milliseconds: 180),

      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            color: Colors.transparent,

            child: Container(
              width: w * 0.82,

              constraints: const BoxConstraints(
                maxWidth: 340,
              ),

              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: w * 0.05,
              ),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  /// ICON
                  Container(
                    width: rf(54),
                    height: rf(54),

                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(
                        0.08,
                      ),

                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      Icons.logout_rounded,

                      color: const Color(0xFFE24B4A),

                      size: rf(25),
                    ),
                  ),

                  SizedBox(height: rf(16)),

                  /// TITLE
                  Text(
                    "Keluar dari akun?",

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: rf(20),

                      fontWeight: FontWeight.w700,

                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: rf(7)),

                  /// SUBTITLE
                  Text(
                    "Anda yakin ingin keluar?",

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: rf(14),

                      color: Colors.grey.shade600,

                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: rf(20)),

                  /// BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: rf(42),

                          child: OutlinedButton(
                            style:
                                OutlinedButton.styleFrom(
                              foregroundColor:
                                  Colors.grey.shade700,

                              side: BorderSide(
                                color:
                                    Colors.grey.shade300,
                              ),

                              padding: EdgeInsets.zero,

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  11,
                                ),
                              ),
                            ),

                            onPressed: () {
                              Navigator.pop(context);
                            },

                            child: Text(
                              "Batal",

                              style: TextStyle(
                                fontSize: rf(13),

                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: rf(10)),

                      Expanded(
                        child: SizedBox(
                          height: rf(42),

                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(
                                0xFFE24B4A,
                              ),

                              foregroundColor:
                                  Colors.white,

                              elevation: 0,

                              padding: EdgeInsets.zero,

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  11,
                                ),
                              ),
                            ),

                            onPressed: () {
                              Navigator.pop(context);

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const Login(),
                                ),
                                (route) => false,
                              );
                            },

                            child: Text(
                              "Keluar",

                              style: TextStyle(
                                fontSize: rf(13),

                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },

      transitionBuilder:
          (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,

          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.95,
              end: 1,
            ).animate(animation),

            child: child,
          ),
        );
      },
    );
  }

  // ── HELPERS ──────────────────────────────────────────────────────────────────

  Widget _cardWrapper({
    required Widget child,
    required double w,
  }) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(
        (w * 0.04).clamp(14, 22),
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),

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
    required double Function(double) rf,
  }) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.035,
        vertical: w * 0.025,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),

        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              (w * 0.018).clamp(8, 12),
            ),

            decoration: BoxDecoration(
              color: const Color(0xFFEDEFF3),

              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: Icon(
              icon,

              size: rf(18),

              color: AppColors.bluePrimary,
            ),
          ),

          SizedBox(width: w * 0.03),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  label,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: rf(10),

                    letterSpacing: 1,

                    color: Colors.grey.shade500,

                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: w * 0.008),

                Text(
                  value,

                  overflow: TextOverflow.ellipsis,

                  maxLines: 2,

                  style: TextStyle(
                    fontSize: rf(14),

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