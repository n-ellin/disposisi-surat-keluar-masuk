import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'welcome.dart';
import 'signin_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> {
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;
  String? selectedRole;

  final _formKey = GlobalKey<FormState>();

  // Controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
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
          MaterialPageRoute(builder: (_) => const Welcome()),
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
                colors: [Color(0xFFEBF4F5), Color(0xFF147A94)],
                stops: [0.18, 0.65],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.10),
                        child: Image.asset(
                          "assets/images/rasi2.png",
                          height: height * 0.25,
                          fit: BoxFit.contain,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                            ),
                            constraints: const BoxConstraints(maxWidth: 500),
                            padding: EdgeInsets.symmetric(
                              vertical: height * 0.02,
                              horizontal: width * 0.06,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.25),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
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

                                _buildTextFormField(
                                  label: "Nama",
                                  icon: Icons.person_outline,
                                  width: width,
                                  controller: _nameController,
                                ),
                                SizedBox(height: height * 0.02),

                                _buildTextFormField(
                                  label: "Email",
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  width: width,
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return "Email wajib diisi";
                                    if (!value.contains("@"))
                                      return "Email tidak valid";
                                    return null;
                                  },
                                ),
                                SizedBox(height: height * 0.02),

                                _buildPasswordFormField(
                                  label: "Kata Sandi",
                                  obscure: _obscurePass,
                                  onTap: () => setState(
                                    () => _obscurePass = !_obscurePass,
                                  ),
                                  width: width,
                                  controller: _passwordController,
                                ),
                                SizedBox(height: height * 0.02),

                                _buildPasswordFormField(
                                  label: "Ulangi kata sandi",
                                  obscure: _obscureConfirmPass,
                                  onTap: () => setState(
                                    () => _obscureConfirmPass =
                                        !_obscureConfirmPass,
                                  ),
                                  width: width,
                                  controller: _confirmPasswordController,
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return "Konfirmasi sandi wajib diisi";
                                    if (value != _passwordController.text) {
                                      return "Konfirmasi sandi tidak sesuai";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: height * 0.02),

                                _buildDropdown(width),
                                SizedBox(height: height * 0.03),

                                SizedBox(
                                  width: double.infinity,
                                  height: height * 0.065,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0XFF2575A0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _onSignUpPressed();
                                      }
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
                                          color: const Color(0XFF2575A0),
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
      ),
    );
  }

  // ================= SIGN UP LOGIC =================
  void _onSignUpPressed() {
    if (selectedRole == "Kepala Tata Usaha" ||
        selectedRole == "Kepala Sekolah" ||
        selectedRole == "Tata Usaha") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignIn()),
      );
    } else {
      // Tampilkan custom popup untuk jabatan lainnya
      _showPendingApprovalPopup();
    }
  }

  // ================= CUSTOM POPUP =================
  void _showPendingApprovalPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header berwarna dengan ikon ──
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: height * 0.025),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF147A94), Color(0xFF2575A0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Ikon utama (lingkaran putih dengan ikon jam/pending)
                      Container(
                        width: width * 0.18,
                        height: width * 0.18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.hourglass_top_rounded,
                          size: width * 0.10,
                          color: const Color(0xFFF5A623),
                        ),
                      ),
                      SizedBox(height: height * 0.015),
                      Text(
                        "Pendaftaran Telah\nDiajukan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: width * 0.052,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Body / pesan ──
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.07,
                    vertical: height * 0.025,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Akun kamu sudah berhasil didaftarkan. Silakan menunggu konfirmasi dan aktivasi dari admin dalam waktu",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: width * 0.036,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      // Badge waktu
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                          vertical: height * 0.008,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFF5A623).withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              color: Color(0xFFF5A623),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Maks. 2 × 24 jam",
                              style: TextStyle(
                                fontSize: width * 0.036,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFF5A623),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.008),
                      Text(
                        "Kamu akan mendapat notifikasi setelah akun diaktifkan.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: width * 0.033,
                          color: Colors.black45,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: height * 0.025),

                      // ── Tombol Mengerti ──
                      SizedBox(
                        width: double.infinity,
                        height: height * 0.058,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2575A0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.pop(context); // tutup dialog
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Welcome(),
                              ),
                            );
                          },
                          child: Text(
                            "Mengerti",
                            style: TextStyle(
                              fontSize: width * 0.042,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================== INPUT WIDGET ==================
  Widget _buildTextFormField({
    required String label,
    required IconData icon,
    required double width,
    TextInputType keyboardType = TextInputType.text,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.blue,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: width * 0.038),
      validator:
          validator ??
          (value) {
            if (value!.isEmpty) return "$label wajib diisi";
            return null;
          },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.black54, size: width * 0.06),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black26),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: const TextStyle(color: Colors.red),
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

  Widget _buildPasswordFormField({
    required String label,
    required bool obscure,
    required VoidCallback onTap,
    required double width,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator:
          validator ??
          (value) {
            if (value!.isEmpty) return "$label wajib diisi";
            return null;
          },
      cursorColor: const Color.fromARGB(255, 82, 128, 165),
      style: TextStyle(fontSize: width * 0.038),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Colors.black54,
          size: width * 0.06,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.black54,
            size: width * 0.06,
          ),
          onPressed: onTap,
        ),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black26),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: const TextStyle(color: Colors.red),
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

  Widget _buildDropdown(double width) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      validator: (value) => value == null ? "Silakan pilih jabatan" : null,
      decoration: InputDecoration(
        labelText: "Jabatan",
        floatingLabelBehavior: FloatingLabelBehavior.auto,

        prefixIcon: Icon(
          Icons.person_2_outlined,
          color: Colors.black54,
          size: width * 0.06,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      items: const [
        DropdownMenuItem(
          value: "Kepala Tata Usaha",
          child: Text("Kepala Tata Usaha"),
        ),
        DropdownMenuItem(
          value: "Kepala Sekolah",
          child: Text("Kepala Sekolah"),
        ),
        DropdownMenuItem(value: "Tata Usaha", child: Text("Tata Usaha")),
        DropdownMenuItem(
          value: "Waka Kurikulum",
          child: Text("Waka Kurikulum"),
        ),
        DropdownMenuItem(
          value: "Waka Kesiswaan",
          child: Text("Waka Kesiswaan"),
        ),
        DropdownMenuItem(value: "Waka Humas", child: Text("Waka Humas")),
        DropdownMenuItem(value: "Waka Sarpras", child: Text("Waka Sarpras")),
        DropdownMenuItem(
          value: "Waka Konseling",
          child: Text("Waka Konseling"),
        ),
        DropdownMenuItem(value: "BK", child: Text("BK")),
        DropdownMenuItem(value: "BKK", child: Text("BKK")),
        DropdownMenuItem(value: "Koordinator", child: Text("Koordinator")),
        DropdownMenuItem(value: "Prakerin", child: Text("Prakerin")),
        DropdownMenuItem(
          value: "Kepala Perpustakaan",
          child: Text("Kepala Perpustakaan"),
        ),
      ],
      value: selectedRole,
      onChanged: (value) {
        setState(() {
          selectedRole = value;
        });
      },
    );
  }
}
