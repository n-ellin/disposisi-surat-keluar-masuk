import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/shared/auth/reset%20kata%20sandi/input_email_page.dart';

class GantiKataSandiPage extends StatefulWidget {
  const GantiKataSandiPage({super.key});

  @override
  State<GantiKataSandiPage> createState() => _GantiKataSandiPageState();
}

class _GantiKataSandiPageState extends State<GantiKataSandiPage> {
  final TextEditingController _oldPassC = TextEditingController();
  final TextEditingController _newPassC = TextEditingController();
  final TextEditingController _confirmPassC = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _hasNumber = false;
  bool _min8Char = false;
  bool _hasUpperLower = false;
  bool _passwordMatch = false;
  bool _oldPassCorrect = false;

  // ── VALIDATION ───────────────────────────────────────────────────────────────

  void _validateOldPassword(String value) {
    setState(() => _oldPassCorrect = value == 'Admin123');
  }

  void _validateNewPassword(String value) {
    setState(() {
      _hasNumber = RegExp(r'[0-9]').hasMatch(value);
      _min8Char = value.length >= 8;
      _hasUpperLower = RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(value);
      _passwordMatch = value == _confirmPassC.text;
    });
  }

  void _validateConfirm(String value) {
    setState(() => _passwordMatch = _newPassC.text == value);
  }

  bool get _isValid =>
      _oldPassCorrect &&
      _hasNumber &&
      _min8Char &&
      _hasUpperLower &&
      _passwordMatch;

  // ── DIALOGS ──────────────────────────────────────────────────────────────────

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.bluePrimary,
                size: 40,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Password Berhasil Diubah',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Kata sandi akun kamu berhasil diperbarui.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bluePrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // tutup dialog
                  Navigator.pop(context); // kembali ke halaman sebelumnya
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── BUILD ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Header
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.bluePrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Ganti Kata Sandi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.bluePrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Keamanan Akun',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Perbarui kata sandi Anda secara berkala untuk menjaga keamanan data akademik dan finansial.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Form card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Kata sandi lama
                            _buildLabel('KATA SANDI LAMA'),
                            const SizedBox(height: 8),
                            _buildField(
                              controller: _oldPassC,
                              hint: 'Masukkan kata sandi lama',
                              obscure: _obscureOld,
                              onChanged: _validateOldPassword,
                              onToggle: () =>
                                  setState(() => _obscureOld = !_obscureOld),
                            ),
                            if (_oldPassC.text.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: _buildValidationRow(
                                  _oldPassCorrect
                                      ? 'Password lama benar'
                                      : 'Password lama salah',
                                  _oldPassCorrect,
                                ),
                              ),

                            const SizedBox(height: 20),

                            // Kata sandi baru
                            _buildLabel('KATA SANDI BARU'),
                            const SizedBox(height: 8),
                            _buildField(
                              controller: _newPassC,
                              hint: 'Masukkan kata sandi baru',
                              obscure: _obscureNew,
                              onChanged: _validateNewPassword,
                              onToggle: () =>
                                  setState(() => _obscureNew = !_obscureNew),
                            ),
                            if (_newPassC.text.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    _buildValidationRow(
                                      'Mengandung minimal satu angka',
                                      _hasNumber,
                                    ),
                                    _buildValidationRow(
                                      'Terdiri dari minimal 8 karakter',
                                      _min8Char,
                                    ),
                                    _buildValidationRow(
                                      'Mengandung huruf besar & huruf kecil',
                                      _hasUpperLower,
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 20),

                            // Konfirmasi kata sandi
                            _buildLabel('KONFIRMASI KATA SANDI BARU'),
                            const SizedBox(height: 8),
                            _buildField(
                              controller: _confirmPassC,
                              hint: 'Ulangi kata sandi baru',
                              obscure: _obscureConfirm,
                              onChanged: _validateConfirm,
                              onToggle: () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
                            ),
                            if (_confirmPassC.text.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: _buildValidationRow(
                                  _passwordMatch
                                      ? 'Konfirmasi password cocok'
                                      : 'Konfirmasi password tidak cocok',
                                  _passwordMatch,
                                ),
                              ),

                            const SizedBox(height: 10),

                            // Lupa kata sandi
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ForgotPasswordPage(),
                                  ),
                                ),
                                child: const Text(
                                  'Lupa kata sandi?',
                                  style: TextStyle(
                                    color: AppColors.bluePrimary,
                                    fontSize: 14,
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
              ),

              // Save button
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: _isValid
                          ? AppColors.bluePrimary
                          : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _isValid ? _showSuccessDialog : null,
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

  // ── WIDGET HELPERS ───────────────────────────────────────────────────────────

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.black54,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      enableSuggestions: false,
      autocorrect: false,
      contextMenuBuilder: (context, editableTextState) =>
          AdaptiveTextSelectionToolbar.editableText(
            editableTextState: editableTextState,
          ),
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.hinttext, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF3F4F7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.grey,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildValidationRow(String text, bool isValid) {
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
              color: isValid ? Colors.green : Colors.red,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
