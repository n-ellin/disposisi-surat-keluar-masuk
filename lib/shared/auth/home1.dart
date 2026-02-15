import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth/signup_page.dart';
import '../auth/signin_page.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// MASKOT
              Image.asset(
                "assets/images/inorasi.png",
                height: height * 0.30,
                fit: BoxFit.contain,
              ),

              SizedBox(height: height * 0.05),

              /// TITLE
              Text(
                "Disposisi Surat",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.065,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: height * 0.015),

              /// SUBTITLE
              Text(
                "Sistem pengelolaan surat masuk\n dan surat keluar",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.038,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: height * 0.06),

              /// BUTTON DAFTAR
              SizedBox(
                width: double.infinity,
                height: height * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5E8FA8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUp()),
                    );
                  },
                  child: Text(
                    "Daftar",
                    style: TextStyle(
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.02),

              /// BUTTON MASUK OUTLINE
              SizedBox(
                width: double.infinity,
                height: height * 0.065,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF5E8FA8),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignIn()),
                    );
                  },
                  child: Text(
                    "Masuk",
                    style: TextStyle(
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5E8FA8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
