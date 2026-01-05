import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Import halaman tujuan setelah user login berdasarkan role/jabatan
import '../../modules/tata_usaha/dashboard/menuTU.dart';
import '../../modules/kepsek/dashboard/menuukepsek.dart';
import '../../modules/other/dashboard/menuother.dart';
import 'signup_page.dart';
import '../home/home_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignIn> {
  final List<Map<String, String>> dummyUsers = [
    {"email": "deta002@gmail.com", "password": "deta002", "role": "Tata Usaha"},
    {
      "email": "kepsek@smk.com",
      "password": "kepsek123",
      "role": "Kepala Sekolah",
    },
    {"email": "user@smk.com", "password": "user123", "role": "Lainnya"},
  ];

  bool _obscurePass = true;
  bool _showError = false;
  bool _showEmptyPassError = false;
  bool _showEmptyEmailError = false;
  bool _showEmailNotFoundError = false;
  bool _showRoleMismatchError = false;

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  String? selectedRole;
  final List<String> roles = [
    "Kepala Tata Usaha",
    "Kepala Sekolah",
    "Tata Usaha",
    "Waka Kurikulum",
    "Waka Kesiswaan",
    "Waka Humas",
    "Waka Sarpras",
    "Ketua Konsli",
    "BK",
    "BKK",
    "Koordinator",
    "Prakerin",
    "Kepala Perpustakaan",
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFE3F2FD),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),

      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WelcomePage()),
          );
          return false;
        },

        child: Scaffold(
          resizeToAvoidBottomInset: false,

          body: Container(
            width: width,
            height: height,

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE3F2FD), Color.fromARGB(255, 255, 98, 50)],
              ),
            ),

            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.04),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.10,
                            ),
                            child: Transform.translate(
                              offset: Offset(0, height * 0.03),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Image.asset(
                                  "assets/images/ino1 (1).png",
                                  height: height * 0.50,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: height * 0.02),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.06,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: height * 0.03,
                                  horizontal: width * 0.06,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                    width: 1.5,
                                  ),
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        "Masuk",
                                        style: TextStyle(
                                          fontSize: width * 0.07,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.02),
                                    _buildTextField(
                                      controller: emailC,
                                      label: "Email",
                                      icon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                    ),

                                    if (_showEmptyEmailError)
                                      _errorMessage("Isi email", width),

                                    if (_showEmailNotFoundError)
                                      _errorMessage(
                                        "Email tidak ditemukan",
                                        width,
                                      ),

                                    SizedBox(height: height * 0.02),

                                    _buildPasswordField(
                                      controller: passwordC,
                                      label: "Kata Sandi",
                                      obscure: _obscurePass,
                                      onTap: () => setState(
                                        () => _obscurePass = !_obscurePass,
                                      ),
                                    ),

                                    if (_showEmptyPassError)
                                      _errorMessage("Isi kata sandi", width),

                                    if (_showError)
                                      _errorMessage("Kata sandi salah", width),

                                    SizedBox(height: height * 0.02),

                                    _buildDropdown(width),

                                    if (_showRoleMismatchError)
                                      _errorMessage(
                                        "Jabatan tidak sesuai",
                                        width,
                                      ),

                                    SizedBox(height: height * 0.03),

                                    SizedBox(
                                      width: double.infinity,
                                      height: height * 0.065,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFF56642,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        onPressed: () => loginUser(),
                                        child: Text(
                                          "Masuk",
                                          style: TextStyle(
                                            fontSize: width * 0.050,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: height * 0.03),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Belum memiliki akun? ",
                                          style: TextStyle(
                                            fontSize: width * 0.035,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => const SignUp(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Daftar",
                                            style: TextStyle(
                                              color: const Color(0xFFF56642),
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
                          SizedBox(height: height * 0.03),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.02),
                    child: Text(
                      "© 2025 SMKN 2 Singosari. All Rights Reserved",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: width * 0.033,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _errorMessage(String msg, double width) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        msg,
        style: TextStyle(color: Colors.red, fontSize: width * 0.035),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      cursorColor: Colors.blue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.black),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required bool obscure,
    required VoidCallback onTap,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),

        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
          ),
          onPressed: onTap,
        ),

        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
      ),
    );
  }

  Widget _buildDropdown(double width) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.black26),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_2_outlined, color: Colors.black54),
          const SizedBox(width: 8),

          Expanded(
            child: DropdownButton<String>(
              value: selectedRole,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Text(
                "Jabatan",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: width * 0.038,
                ),
              ),

              onChanged: (value) => setState(() => selectedRole = value),

              items: roles.map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loginUser() async {
    final email = emailC.text.trim();
    final password = passwordC.text.trim();
    final role = selectedRole;

    setState(() {
      _showEmptyEmailError = false;
      _showEmptyPassError = false;
      _showError = false;
      _showEmailNotFoundError = false;
      _showRoleMismatchError = false;
    });

    // email kosong
    if (email.isEmpty) {
      setState(() => _showEmptyEmailError = true);
      return;
    }

    // password kosong
    if (password.isEmpty) {
      setState(() => _showEmptyPassError = true);
      return;
    }

    // role kosong
    if (role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jabatan terlebih dahulu')),
      );
      return;
    }

    // cari user dari email
    final userByEmail = dummyUsers.firstWhere(
      (user) => user["email"] == email,
      orElse: () => {},
    );

    // email tidak terdaftar
    if (userByEmail.isEmpty) {
      setState(() => _showEmailNotFoundError = true);
      return;
    }

    // password salah (email benar)
    if (userByEmail["password"] != password) {
      setState(() => _showError = true); //kata sandi salah
      return;
    }

    // role salah (email dan password benar)
    if (userByEmail["role"] != role) {
      setState(() => _showRoleMismatchError = true);
      return;
    }

    //login berhasil
    if (role == "Tata Usaha" || role == "Kepala Tata Usaha") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TuDashboardPage()),
      );
    } else if (role == "Kepala Sekolah") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const KepsekDashboardPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MenuOther()),
      );
    }
  }
}
