import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ta_mobile_disposisi_surat/pages/Home/home_page.dart';
import '../signin/signin_page.dart'; // import halaman SignIn

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> {
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;
  String? selectedRole; // untuk menyimpan dropdown

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFFE3F2FD),
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomePage()),
        );
        return false;
      },
      child: Scaffold(
        body: SizedBox(
          width: width,
          height: height,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE3F2FD), Color(0xFF90CAF9)],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.10),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.asset(
                          "assets/images/rasi2.png",
                          height: height * 0.25,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: width * 0.06),
                          padding: EdgeInsets.symmetric(
                              vertical: height * 0.02, horizontal: width * 0.06),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 253, 252, 252)
                                    .withOpacity(0.10),
                                blurRadius: 20,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Daftar",
                                style: TextStyle(
                                  fontSize: width * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: height * 0.02),
                              _buildTextField(
                                label: "Nama",
                                icon: Icons.person_outline,
                                width: width,
                              ),
                              SizedBox(height: height * 0.02),
                              _buildTextField(
                                label: "Email",
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                width: width,
                              ),
                              SizedBox(height: height * 0.02),
                              _buildPasswordField(
                                label: "Kata Sandi",
                                obscure: _obscurePass,
                                onTap: () => setState(
                                  () => _obscurePass = !_obscurePass,
                                ),
                                width: width,
                              ),
                              SizedBox(height: height * 0.02),
                              _buildPasswordField(
                                label: "Ulangi kata sandi",
                                obscure: _obscureConfirmPass,
                                onTap: () => setState(
                                  () => _obscureConfirmPass = !_obscureConfirmPass,
                                ),
                                width: width,
                              ),
                              SizedBox(height: height * 0.02),
                              _buildDropdown(width),
                              SizedBox(height: height * 0.03),
                              SizedBox(
                                width: double.infinity,
                                height: height * 0.065,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade400,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    // nanti di sini bisa kirim data ke backend
                                    print("Role terpilih: $selectedRole");
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
                              SizedBox(height: height * 0.015),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sudah memiliki akun? ",
                                    style: TextStyle(fontSize: width * 0.035),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const SignIn(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Masuk",
                                      style: TextStyle(
                                        color: const Color.fromARGB(255, 16, 85, 142),
                                        fontWeight: FontWeight.bold,
                                        fontSize: width * 0.038,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ========================= WIDGET REUSABLE =========================
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required double width,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      cursorColor: Colors.blue,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: width * 0.038),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black, size: width * 0.06),
        labelText: label,
        labelStyle: TextStyle(fontSize: width * 0.038, color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.grey, width: 1.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required bool obscure,
    required VoidCallback onTap,
    required double width,
  }) {
    return TextField(
      obscureText: obscure,
      cursorColor: const Color.fromARGB(255, 82, 128, 165),
      style: TextStyle(fontSize: width * 0.038),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline, color: Colors.black, size: width * 0.06),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
            size: width * 0.06,
          ),
          onPressed: onTap,
        ),
        labelText: label,
        labelStyle: TextStyle(fontSize: width * 0.038, color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.grey, width: 1.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
      ),
    );
  }

  Widget _buildDropdown(double width) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person_2_outlined, color: Colors.black, size: width * 0.06),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.grey, width: 1.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: const [
        DropdownMenuItem(value: "Tata Usaha", child: Text("Tata Usaha")),
        DropdownMenuItem(value: "Kepala Sekolah", child: Text("Kepala Sekolah")),
        DropdownMenuItem(value: "Lainnya", child: Text("Lainnya")),
      ],
      hint: Text("Jabatan", style: TextStyle(fontSize: width * 0.038)),
      value: selectedRole,
      onChanged: (value) {
        setState(() {
          selectedRole = value;
        });
      },
    );
  }
}
