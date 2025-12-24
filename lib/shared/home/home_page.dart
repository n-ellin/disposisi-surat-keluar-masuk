import 'package:flutter/material.dart';
import '../auth/signup_page.dart';
import '../auth/signin_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final textScale = width / 380;
    final imageScale = width / 350;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        /// === BACKGROUND GRADIENT ===
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD), // biru muda
              Color(0xFF90CAF9), // biru medium
            ],
          ),
        ),

        child: Column(
          children: [
            SizedBox(height: height * 0.09),

            // ==== JUDUL ====
            Column(
              children: [
                Text(
                  "Disposisi",
                  style: TextStyle(
                    color: Color(0xFF1E3A5F),
                    fontSize: 40 * textScale,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "Surat Masuk",
                  style: TextStyle(
                    color: Color(0xFF1E3A5F),
                    fontSize: 40 * textScale,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "Surat Keluar",
                  style: TextStyle(
                    color: Color(0xFF1E3A5F),
                    fontSize: 40 * textScale,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),

            SizedBox(height: height * 0.04),

            // ==== MASKOT ====
            SizedBox(
              height: height * 0.28,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/images/rasi.png',
                      height: 195 * imageScale,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/images/ino.png',
                      height: 200 * imageScale,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.05) ,

            // ==== CARD BAWAH ====
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: height * 0.04),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 35,
                      offset: Offset(0, -8),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// === SIGN UP ===
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUp()),
                        );
                      },
                      child: Container(
                        width: width * 0.65,
                        padding: EdgeInsets.symmetric(vertical: height * 0.015),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF64B5F6), Color(0xFF1E88E5)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Daftar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24 * textScale,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.035),

                    /// === SIGN IN ===
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignIn()),
                        );
                      },
                      child: Container(
                        width: width * 0.65,
                        padding: EdgeInsets.symmetric(vertical: height * 0.015),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF64B5F6), Color(0xFF1E88E5)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Masuk",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24 * textScale,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
