import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/navbar_role.dart';
import '../pages/home.dart';

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

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode(); // ← ZONA 1
  final FocusNode _passwordFocusNode = FocusNode();

  // ── ZONA 2: initState ──
  @override
  void initState() {
    super.initState();

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        _checkEmailExists(emailC.text.trim());
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        _checkPassword(passwordC.text.trim());
      }
    });
  }

  // ── ZONA 2: dispose ──
  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    emailC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: WillPopScope(
        onWillPop: () async {
          return true;
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
                stops: [0.0, 1.0],
                colors: [Color(0xFFEBF4F5), Color(0xFFE08A34)],
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

                                    // ── ZONA 3: focusNode dipasang di sini ──
                                    _buildTextField(
                                      controller: emailC,
                                      label: "Email",
                                      icon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                      focusNode: _emailFocusNode, // ← TAMBAHAN
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
                                      focusNode: _passwordFocusNode,
                                    ),

                                    if (_showEmptyPassError)
                                      _errorMessage("Isi kata sandi", width),
                                    if (_showError)
                                      _errorMessage("Kata sandi salah", width),

                                    SizedBox(height: height * 0.02),

                                    SizedBox(
                                      width: double.infinity,
                                      height: height * 0.065,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFE66D26,
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
                        color: Colors.black,
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

  // ── ZONA 4: _checkEmailExists ──
  void _checkEmailExists(String email) {
    if (email.isEmpty) return;

    final found = dummyUsers.any((user) => user["email"] == email);
    setState(() {
      _showEmailNotFoundError = !found;
    });
  }

  void _checkPassword(String password) {
    final email = emailC.text.trim();

    if (password.isEmpty || email.isEmpty) return;

    final user = dummyUsers.firstWhere(
      (user) => user["email"] == email,
      orElse: () => {},
    );

    if (user.isEmpty) return; // kalau email belum valid, skip

    setState(() {
      _showError = user["password"] != password;
    });
  }

  // ── ZONA 4: _buildTextField + focusNode ──
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    FocusNode? focusNode, // ← TAMBAHAN
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode, // ← TAMBAHAN
      cursorColor: Colors.blue,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      onChanged: (_) {
        // reset error saat user mulai ngetik ulang
        if (_showEmailNotFoundError) {
          setState(() => _showEmailNotFoundError = false);
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.black54),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black26),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required bool obscure,
    required VoidCallback onTap,
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      cursorColor: Colors.blue,
      style: const TextStyle(color: Colors.black),

      onChanged: (Value) {
        if (_showError) {
          setState(() => _showError = false);
        }
        _checkPassword(Value);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.black54,
          ),
          onPressed: onTap,
        ),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black26),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    final email = emailC.text.trim();
    final password = passwordC.text.trim();

    setState(() {
      _showEmptyEmailError = false;
      _showEmptyPassError = false;
      _showError = false;
      _showEmailNotFoundError = false;
    });

    if (email.isEmpty) {
      setState(() => _showEmptyEmailError = true);
      return;
    }
    if (password.isEmpty) {
      setState(() => _showEmptyPassError = true);
      return;
    }

    final userByEmail = dummyUsers.firstWhere(
      (user) => user["email"] == email,
      orElse: () => {},
    );

    if (userByEmail.isEmpty) {
      setState(() => _showEmailNotFoundError = true);
      return;
    }
    if (userByEmail["password"] != password) {
      setState(() => _showError = true);
      return;
    }

    final role = userByEmail['role'];

    NavbarRole navbarRole;

    if (role == "Tata Usaha" || role == "Kepala Tata Usaha") {
      navbarRole = NavbarRole.tu;
    } else if (role == "Kepala Sekolah") {
      navbarRole = NavbarRole.kepsek;
    } else {
      navbarRole = NavbarRole.other;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Home(role: navbarRole)),
    );
  }
}
