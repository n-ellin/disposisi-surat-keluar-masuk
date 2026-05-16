import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/shared/auth/login_page.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _passwordController = TextEditingController();

  final _confirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _showPassword = false;
  bool _showConfirm = false;
  bool _isLoading = false;

  // VALIDATION
  bool hasNumber = false;
  bool min8Char = false;
  bool hasUpperLower = false;
  bool passwordMatch = false;

  void validatePassword(String value) {
    setState(() {
      hasNumber = RegExp(r'[0-9]').hasMatch(value);

      min8Char = value.length >= 8;

      hasUpperLower = RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(value);

      passwordMatch = value == _confirmController.text;
    });
  }

  void validateConfirm(String value) {
    setState(() {
      passwordMatch = _passwordController.text == value;
    });
  }

  bool get isValid {
    return hasNumber && min8Char && hasUpperLower && passwordMatch;
  }

  void _savePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

        contentPadding: const EdgeInsets.all(24),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 64,
              height: 64,

              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(50),
              ),

              child: Icon(
                Icons.check_circle_outline,
                color: AppColors.bluePrimary,
                size: 36,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Password Berhasil Diubah!',
              textAlign: TextAlign.center,

              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),

            const SizedBox(height: 8),

            const Text(
              'Silakan login menggunakan\npassword baru kamu.',

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 13,
                color: Colors.black45,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 44,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Login()),
                    (route) => false,
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bluePrimary,

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                child: const Text(
                  'Ke Halaman Login',

                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();

    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),

      prefixIcon: Icon(prefixIcon, size: 20, color: Colors.black38),

      suffixIcon: suffixIcon,

      filled: true,
      fillColor: const Color(0xFFF9FAFB),

      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: BorderSide(color: AppColors.bluePrimary, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),

        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black87,
          ),

          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 20),

                // ICON
                Container(
                  width: 56,
                  height: 56,

                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),

                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.bluePrimary,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 24),

                // TITLE
                const Text(
                  'Password Baru',

                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Buat password baru untuk akunmu.\nPastikan mudah diingat tapi sulit ditebak.',

                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 36),

                // PASSWORD
                const Text(
                  'Password Baru',

                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _passwordController,

                  obscureText: !_showPassword,

                  onChanged: validatePassword,

                  decoration: _inputDecoration(
                    hint: 'Minimal 8 karakter',

                    prefixIcon: Icons.lock_outline,

                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,

                        size: 20,
                        color: Colors.black38,
                      ),

                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }

                    return null;
                  },
                ),

                if (_passwordController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),

                    child: Column(
                      children: [
                        buildValidation(
                          "Mengandung minimal satu angka",
                          hasNumber,
                        ),

                        buildValidation("Minimal 8 karakter", min8Char),

                        buildValidation("Huruf besar & kecil", hasUpperLower),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // CONFIRM
                const Text(
                  'Konfirmasi Password',

                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _confirmController,

                  obscureText: !_showConfirm,

                  onChanged: validateConfirm,

                  decoration: _inputDecoration(
                    hint: 'Ulangi password baru',

                    prefixIcon: Icons.lock_outline,

                    suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,

                        size: 20,
                        color: Colors.black38,
                      ),

                      onPressed: () {
                        setState(() {
                          _showConfirm = !_showConfirm;
                        });
                      },
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi password wajib diisi';
                    }

                    return null;
                  },
                ),

                if (_confirmController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),

                    child: buildValidation(
                      passwordMatch
                          ? "Konfirmasi password cocok"
                          : "Konfirmasi password tidak cocok",

                      passwordMatch,
                    ),
                  ),

                const Spacer(),

                // BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    onPressed: (_isLoading || !isValid) ? null : _savePassword,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bluePrimary,

                      foregroundColor: Colors.white,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      disabledBackgroundColor: const Color(0xFF93C5FD),
                    ),

                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,

                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Simpan Password',

                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildValidation(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),

      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.error_outline,

            color: isValid ? Colors.green : Colors.red,

            size: 16,
          ),

          const SizedBox(width: 6),

          Text(
            text,

            style: TextStyle(
              fontSize: 13,

              color: isValid ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
