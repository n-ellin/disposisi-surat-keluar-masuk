import 'package:flutter/material.dart';

// IMPORT HALAMAN ASLI
import 'package:ta_mobile_disposisi_surat/pages/signin/signin_page.dart';
import 'package:ta_mobile_disposisi_surat/pages/signup/signup_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND IMAGE GEDUNG
          Positioned.fill(
            child: Image.asset("assets/image/lobby.jpg", fit: BoxFit.cover),
          ),

          // OVERLAY GELAP
          Container(color: Colors.black.withOpacity(0.15)),

          // KONTEN UTAMA
          Column(
            children: [
              const SizedBox(height: 65), // Logo agak naik
              // LOGO SEKOLAH
              Image.asset("assets/image/logosmk.jpg", width: 150, height: 150),

              const Spacer(), // Spacer ini bikin tombol selalu di bawah
              // BUTTON LOGIN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SigninPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.7),
                      foregroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "LOG IN",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // BUTTON SIGN UP
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUpPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.7),
                      foregroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "SIGN UP",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40), // jarak bawah
            ],
          ),
        ],
      ),
    );
  }
}
