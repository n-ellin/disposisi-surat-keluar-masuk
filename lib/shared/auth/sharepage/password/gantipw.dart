import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/shared/auth/sharepage/password/reset kata sandi/input_email.dart';

class GantiKataSandiPage extends StatefulWidget {
  const GantiKataSandiPage({super.key});

  @override
  State<GantiKataSandiPage> createState() => _GantiKataSandiPageState();
}

class _GantiKataSandiPageState extends State<GantiKataSandiPage> {
  final TextEditingController oldPassC = TextEditingController();
  final TextEditingController newPassC = TextEditingController();
  final TextEditingController confirmPassC = TextEditingController();

  bool obscureOld = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  bool hasNumber = false;
  bool min8Char = false;
  bool hasUpperLower = false;
  bool passwordMatch = false;

  void validatePassword(String value) {
    setState(() {
      hasNumber = RegExp(r'[0-9]').hasMatch(value);
      min8Char = value.length >= 8;
      hasUpperLower = RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(value);
      passwordMatch = value == confirmPassC.text;
    });
  }

  void validateConfirm(String value) {
    setState(() {
      passwordMatch = newPassC.text == value;
    });
  }

  bool get isValid => hasNumber && min8Char && hasUpperLower && passwordMatch;

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

              // HEADER
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.bluePrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Text(
                    "Ganti Kata Sandi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bluePrimary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Keamanan Akun",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Perbarui kata sandi Anda secara berkala untuk menjaga keamanan data akademik dan finansial.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // CARD
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildLabel("KATA SANDI LAMA"),
                            const SizedBox(height: 8),
                            buildField(
                              controller: oldPassC,
                              hint: "Masukkan kata sandi lama",
                              obscure: obscureOld,
                              onTap: () =>
                                  setState(() => obscureOld = !obscureOld),
                            ),

                            const SizedBox(height: 20),

                            buildLabel("KATA SANDI BARU"),
                            const SizedBox(height: 8),
                            buildField(
                              controller: newPassC,
                              hint: "Masukkan kata sandi baru",
                              obscure: obscureNew,
                              onChanged: validatePassword,
                              onTap: () =>
                                  setState(() => obscureNew = !obscureNew),
                            ),

                            if (newPassC.text.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    buildValidation(
                                      "Mengandung minimal satu angka",
                                      hasNumber,
                                    ),
                                    buildValidation(
                                      "Terdiri dari minimal 8 karakter",
                                      min8Char,
                                    ),
                                    buildValidation(
                                      "Mengandung huruf besar & huruf kecil",
                                      hasUpperLower,
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 20),

                            buildLabel("KONFIRMASI KATA SANDI BARU"),
                            const SizedBox(height: 8),
                            buildField(
                              controller: confirmPassC,
                              hint: "Ulangi kata sandi baru",
                              obscure: obscureConfirm,
                              onChanged: validateConfirm,
                              onTap: () => setState(
                                () => obscureConfirm = !obscureConfirm,
                              ),
                            ),

                            if (confirmPassC.text.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: buildValidation(
                                  passwordMatch
                                      ? "Konfirmasi password cocok"
                                      : "Konfirmasi password tidak cocok",
                                  passwordMatch,
                                ),
                              ),

                            const SizedBox(height: 10),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Lupa kata sandi?",
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

              // BUTTON
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: isValid
                          ? AppColors.bluePrimary
                          : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: isValid ? () {} : null,
                    child: const Text(
                      "Simpan Perubahan",
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

  Widget buildLabel(String text) {
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

  Widget buildField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onTap,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: const Color(0xfff3f4f7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          onPressed: onTap,
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.grey,
            size: 20,
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
              color: isValid ? Colors.green : Colors.red,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
