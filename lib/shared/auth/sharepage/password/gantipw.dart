import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';

class GantiKataSandiPage extends StatefulWidget {
  const GantiKataSandiPage({super.key});

  @override
  State<GantiKataSandiPage> createState() =>
      _GantiKataSandiPageState();
}

class _GantiKataSandiPageState
    extends State<GantiKataSandiPage> {
  final TextEditingController oldPassC =
      TextEditingController();

  final TextEditingController newPassC =
      TextEditingController();

  final TextEditingController confirmPassC =
      TextEditingController();

  bool obscureOld = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  // VALIDASI
  bool hasNumber = false;
  bool min8Char = false;
  bool hasUpperLower = false;
  bool passwordMatch = false;

  void validatePassword(String value) {
    setState(() {
      hasNumber =
          RegExp(r'[0-9]').hasMatch(value);

      min8Char = value.length >= 8;

      hasUpperLower =
          RegExp(r'(?=.*[a-z])(?=.*[A-Z])')
              .hasMatch(value);

      passwordMatch =
          value == confirmPassC.text;
    });
  }

  void validateConfirm(String value) {
    setState(() {
      passwordMatch =
          newPassC.text == value;
    });
  }

  bool get isValid =>
      hasNumber &&
      min8Char &&
      hasUpperLower &&
      passwordMatch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xfff5f6fa),

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
          ),

          child: Column(
            children: [
              const SizedBox(height: 16),

              // HEADER
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.bluePrimary,
                    ),
                  ),

                  const SizedBox(width: 4),

                  const Text(
                    "Ganti Kata Sandi",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bluePrimary
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      const Text(
                        "Keamanan Akun",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 14),

                      const Text(
                        "Perbarui kata sandi Anda secara berkala untuk menjaga keamanan data akademik dan finansial.",
                        style: TextStyle(
                          fontSize: 18,
                          color:
                              Colors.black54,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(
                          height: 34),

                      // CARD
                      Container(
                        padding:
                            const EdgeInsets.all(
                          22,
                        ),

                        decoration:
                            BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            28,
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            buildLabel(
                              "KATA SANDI LAMA",
                            ),

                            const SizedBox(
                                height: 12),

                            buildField(
                              controller:
                                  oldPassC,

                              hint:
                                  "Masukkan kata sandi lama",

                              obscure:
                                  obscureOld,

                              onTap: () {
                                setState(() {
                                  obscureOld =
                                      !obscureOld;
                                });
                              },
                            ),

                            const SizedBox(
                                height: 26),

                            buildLabel(
                              "KATA SANDI BARU",
                            ),

                            const SizedBox(
                                height: 12),

                            buildField(
                              controller:
                                  newPassC,

                              hint:
                                  "Masukkan kata sandi baru",

                              obscure:
                                  obscureNew,

                              onChanged:
                                  validatePassword,

                              onTap: () {
                                setState(() {
                                  obscureNew =
                                      !obscureNew;
                                });
                              },
                            ),

                            // VALIDASI REALTIME
                            if (newPassC
                                .text
                                .isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.only(
                                  top: 14,
                                ),

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

                            const SizedBox(
                                height: 26),

                            buildLabel(
                              "KONFIRMASI KATA SANDI BARU",
                            ),

                            const SizedBox(
                                height: 12),

                            buildField(
                              controller:
                                  confirmPassC,

                              hint:
                                  "Ulangi kata sandi baru",

                              obscure:
                                  obscureConfirm,

                              onChanged:
                                  validateConfirm,

                              onTap: () {
                                setState(() {
                                  obscureConfirm =
                                      !obscureConfirm;
                                });
                              },
                            ),

                            if (confirmPassC
                                .text
                                .isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.only(
                                  top: 14,
                                ),

                                child:
                                    buildValidation(
                                  passwordMatch
                                      ? "Konfirmasi password cocok"
                                      : "Konfirmasi password tidak cocok",

                                  passwordMatch,
                                ),
                              ),

                            const SizedBox(
                                height: 18),

                            Align(
                              alignment:
                                  Alignment
                                      .centerRight,

                              child: TextButton(
                                onPressed:
                                    () {},

                                child: const Text(
                                  "Lupa kata sandi?",
                                  style:
                                      TextStyle(
                                    color:
                                        AppColors.bluePrimary,

                                    fontSize:
                                        16,
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
                padding:
                    const EdgeInsets.only(
                  bottom: 24,
                  top: 20,
                ),

                child: SizedBox(
                  width: double.infinity,
                  height: 62,

                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      elevation: 0,

                      backgroundColor:
                          isValid
                              ? AppColors.bluePrimary
                              : Colors.grey
                                  .shade400,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),
                      ),
                    ),

                    onPressed:
                        isValid ? () {} : null,

                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: const [
                        Text(
                          "Simpan Perubahan",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight
                                    .bold,

                            color:
                                Colors.white,
                          ),
                        ),

                        SizedBox(width: 10),

                        Icon(
                          Icons.check_circle_outline,
                          color:
                              Colors.white,
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
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,

      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.black54,
        letterSpacing: 1,
      ),
    );
  }

  Widget buildField({
    required TextEditingController
        controller,

    required String hint,

    required bool obscure,

    required VoidCallback onTap,

    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: TextStyle(
          color: Colors.grey.shade400,
        ),

        filled: true,

        fillColor:
            const Color(0xfff3f4f7),

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),

        suffixIcon: IconButton(
          onPressed: onTap,

          icon: Icon(
            obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,

            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget buildValidation(
    String text,
    bool isValid,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 8,
      ),

      child: Row(
        children: [
          Icon(
            isValid
                ? Icons.check_circle
                : Icons.error_outline,

            color:
                isValid
                    ? Colors.green
                    : Colors.red,

            size: 18,
          ),

          const SizedBox(width: 8),

          Text(
            text,

            style: TextStyle(
              color:
                  isValid
                      ? Colors.green
                      : Colors.red,

              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}