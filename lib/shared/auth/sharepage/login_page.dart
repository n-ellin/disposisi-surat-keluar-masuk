import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  bool obscure = true;

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFEFF3F7),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFEFF3F7),

        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  // LOGO / ICON
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F6E7A).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mail_outline_rounded,
                      size: 36,
                      color: Color(0xFF0F6E7A),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // TITLE
                  const Text(
                    "Masuk",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F6E7A),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Silakan login untuk melanjutkan",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.45),
                    ),
                  ),

                  const SizedBox(height: 34),

                  // LOGIN CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // EMAIL LABEL
                        const Text(
                          "ALAMAT EMAIL",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: Color(0xFF4D4D4D),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // EMAIL FIELD
                        _buildField(
                          controller: emailC,
                          hint: "Email",
                          icon: Icons.mail_outline_rounded,
                        ),

                        const SizedBox(height: 22),

                        // PASSWORD LABEL
                        const Text(
                          "PASSWORD",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: Color(0xFF4D4D4D),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // PASSWORD FIELD
                        _buildPasswordField(),

                        const SizedBox(height: 10),

                        // FORGOT PASSWORD
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              "Lupa password?",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F6E7A),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: () {
                              // LOGIN
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  const Color(0xFF0F6E7A),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              "Masuk",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // FOOTER
                  Text(
                    "© 2025 SMKN 2 Singosari",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.35),
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

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      cursorColor: const Color(0xFF0F6E7A),
      style: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,

        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.35),
        ),

        prefixIcon: Icon(
          icon,
          color: Colors.grey.shade600,
        ),

        filled: true,
        fillColor: const Color(0xFFF7F8FA),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF0F6E7A),
            width: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordC,
      obscureText: obscure,
      cursorColor: const Color(0xFF0F6E7A),
      style: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "••••••••",

        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.35),
        ),

        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: Colors.grey.shade600,
        ),

        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscure = !obscure;
            });
          },
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.grey.shade500,
          ),
        ),

        filled: true,
        fillColor: const Color(0xFFF7F8FA),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF0F6E7A),
            width: 1.4,
          ),
        ),
      ),
    );
  }
}