import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';
import 'package:ta_mobile_disposisi_surat/features/users/pages/menu_user_page.dart';
import 'package:ta_mobile_disposisi_surat/shared/auth/pages/home.dart';
import 'package:ta_mobile_disposisi_surat/shared/auth/reset%20kata%20sandi/input_email_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();

  String? _emailError;
  String? _passwordError;

  bool _obscure = true;
  bool _isLoading = false;

  static const List<String> _validEmails = [
    'kepsek@gmail.com',
    'tu@gmail.com',
    'user@gmail.com',
  ];

  @override
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() => _emailError = null);
  }

  Future<void> _login() async {
    if (_isLoading) return;

    final email = _emailC.text.trim();
    final password = _passwordC.text.trim();

    setState(() {
      _emailError = null;
      _passwordError = null;

      if (email.isEmpty) {
        _emailError = 'Email wajib diisi';
      } else if (!_validEmails.contains(email)) {
        _emailError = 'Email tidak ditemukan';
      }

      if (password.isEmpty) {
        _passwordError = 'Kata sandi wajib diisi';
      }
    });

    if (_emailError != null || _passwordError != null) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (email == 'kepsek@gmail.com' && password == '123456') {
      _navigateTo(
        Home(
          role: Role.kepsek,
          nama: 'Kepala Sekolah',
          email: email,
          jabatan: 'Kepala Sekolah',
        ),
      );
    } else if (email == 'tu@gmail.com' && password == '123456') {
      _navigateTo(
        Home(
          role: Role.tu,
          nama: 'Tata Usaha',
          email: email,
          jabatan: 'Tata Usaha',
        ),
      );
    } else if (email == 'user@gmail.com' && password == '123456') {
      _navigateTo(const MenuUser());
    } else {
      setState(() {
        _passwordError = 'Kata sandi salah';
        _isLoading = false;
      });
    }
  }

  void _navigateTo(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
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
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFF2F2F2),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // ================= ICON =================

                        Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF0F6E7A).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.mail_outline_rounded,
                            size: 38,
                            color: Color(0xFF0F6E7A),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ================= TITLE =================

                        const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F6E7A),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Silakan login untuk melanjutkan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.45),
                          ),
                        ),

                        const SizedBox(height: 34),

                        // ================= CARD =================

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
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // ================= EMAIL =================

                              const _FieldLabel(text: 'EMAIL'),

                              const SizedBox(height: 10),

                              _buildEmailField(),

                              const SizedBox(height: 22),

                              // ================= PASSWORD =================

                              const _FieldLabel(text: 'KATA SANDI'),

                              const SizedBox(height: 10),

                              _buildPasswordField(),

                              const SizedBox(height: 10),

                              // ================= FORGOT PASSWORD =================

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ForgotPasswordPage(),
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize
                                            .shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Lupa Kata sandi?',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          AppColors.bluePrimary,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // ================= LOGIN BUTTON =================

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed:
                                      _isLoading ? null : _login,
                                  style:
                                      ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        AppColors.bluePrimary,
                                    disabledBackgroundColor:
                                        AppColors.bluePrimary
                                            .withOpacity(0.7),
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                              18),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth: 2.4,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Masuk',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight:
                                                FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),

                // ================= COPYRIGHT =================

                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    '© 2025 SMKN 2 Singosari',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= FIELD BUILDERS =================

  Widget _buildEmailField() {
    return TextField(
      controller: _emailC,
      onChanged: (_) => _validateEmail(),
      cursorColor: AppColors.bluePrimary,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      decoration: _fieldDecoration(
        hint: 'Email',
        error: _emailError,
        prefixIcon: Icons.mail_outline_rounded,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordC,
      obscureText: _obscure,
      onChanged: (_) {
        setState(() {
          _passwordError = null;
        });
      },
      cursorColor: AppColors.bluePrimary,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      decoration: _fieldDecoration(
        hint: 'Kata sandi',
        error: _passwordError,
        prefixIcon: Icons.lock_outline_rounded,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
          icon: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.grey.shade500,
            size: 20,
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData prefixIcon,
    String? error,
    Widget? suffixIcon,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    );

    const focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(
        color: AppColors.bluePrimary,
        width: 1.4,
      ),
    );

    return InputDecoration(
      isDense: true,
      hintText: hint,
      errorText: error,
      hintStyle: TextStyle(
        color: AppColors.hinttext.withOpacity(0.35),
        fontSize: 14,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: Colors.grey.shade600,
        size: 20,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      enabledBorder: border,
      focusedBorder: focusedBorder,
      errorBorder: border,
      focusedErrorBorder: focusedBorder,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: AppColors.hinttext,
      ),
    );
  }
}