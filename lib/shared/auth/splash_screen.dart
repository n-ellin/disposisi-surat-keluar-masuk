import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- TAMBAHKAN INI
import 'welcome.dart'; // pastikan path ini sesuai

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // status bar
  @override
  void initState() {
    super.initState();

    // 🔵 Ubah warna status bar di sini
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFE3F2FD),
        statusBarIconBrightness: Brightness.light, // ikon putih
      ),
    );

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Welcome()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Color(0xFF90CAF9)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: size.width * 0.4,
              height: size.height * 0.25,
              errorBuilder: (context, error, stack) {
                return const Text(
                  "LOGO TIDAK DITEMUKAN!",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Simdis',
              style: TextStyle(
                fontSize: size.width * 0.08,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: const [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
