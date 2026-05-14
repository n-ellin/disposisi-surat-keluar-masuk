import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ta_mobile_disposisi_surat/shared/auth/sharepage/password/reset kata sandi/new_pw.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  int _timerSeconds = 120;
  int _attemptsLeft = 5;
  bool _isBlocked = false;
  DateTime? _blockUntil;
  Timer? _timer;
  Timer? _blockTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _timerSeconds = 120);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timerSeconds == 0) {
        t.cancel();
        setState(() {});
      } else {
        setState(() => _timerSeconds--);
      }
    });
  }

  void _startBlockTimer() {
    _blockUntil = DateTime.now().add(const Duration(hours: 1));
    _blockTimer = Timer.periodic(const Duration(minutes: 1), (t) {
      if (_blockUntil!.isBefore(DateTime.now())) {
        t.cancel();
        setState(() {
          _isBlocked = false;
          _attemptsLeft = 5;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda dapat mencoba lagi sekarang'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    });
  }

  String get _timerText {
    final m = (_timerSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_timerSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _blockTimerText {
    if (_blockUntil == null) return '';
    final diff = _blockUntil!.difference(DateTime.now());
    final m = (diff.inMinutes).toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _maskedEmail {
    final parts = widget.email.split('@');
    if (parts.length != 2) return widget.email;
    
    final local = parts[0];
    final domain = parts[1];
    
    if (local.length <= 2) return widget.email;
    
    final visible = local.substring(0, 2);
    final masked = '***';
    return '$visible$masked@$domain';
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    if (_otpCode.length < 6) {
      for (int i = 0; i < 6; i++) {
        if (_controllers[i].text.isEmpty) {
          _focusNodes[i].requestFocus();
          break;
        }
      }
      return;
    }

    if (_isBlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Akun diblokir. Tunggu $_blockTimerText'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
      _attemptsLeft--;
    });

    if (!mounted) return;

    if (_attemptsLeft <= 0) {
      _showAttemptsExhaustedDialog();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP salah. Sisa ${_attemptsLeft} percobaan'),
        backgroundColor: Color(0xFFEF4444),
      ),
    );
  }

  void _showAttemptsExhaustedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.block, color: Color(0xFFEF4444), size: 28),
            SizedBox(width: 12),
            Text(
              'Kesempatan Habis',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Anda telah melebihi batas percobaan. Akun akan diblokir selama 1 jam ke depan.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isBlocked = true);
              _startBlockTimer();
              _clearOtpFields();
            },
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }

  void _resendOtp() {
    _clearOtpFields();
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Kode OTP berhasil dikirim ulang'),
        backgroundColor: AppColors.bluePrimary,
      ),
    );
  }

  void _clearOtpFields() {
    for (var c in _controllers) c.clear();
    _focusNodes[0].requestFocus();
    setState(() {});
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    _timer?.cancel();
    _blockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.key_outlined, color: AppColors.bluePrimary, size: 28),
              ),
              const SizedBox(height: 24),
              const Text(
                'Verifikasi OTP',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 14, color: Colors.black45, height: 1.5),
                  children: [
                    const TextSpan(text: 'Kode OTP sudah dikirim ke\n'),
                    TextSpan(
                      text: _maskedEmail,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              const Text(
                'Kode OTP',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) => _buildOtpBox(i)),
              ),
              const SizedBox(height: 24), // Pindah ke atas tombol

              // Status display - DIPINDAH KE ATAS TOMBOL
              if (_isBlocked)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF59E0B), width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_clock, color: Color(0xFFF59E0B), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 13, color: Color(0xFF92400E)),
                            children: [
                              const TextSpan(text: 'Akun diblokir. Tunggu '),
                              TextSpan(
                                text: _blockTimerText,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Center(
                    child: _timerSeconds > 0
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 13, color: Colors.black45),
                              children: [
                                const TextSpan(text: 'Kode berlaku selama '),
                                TextSpan(
                                  text: _timerText,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Text(
                            'Kode sudah kadaluarsa',
                            style: TextStyle(fontSize: 13, color: Color(0xFFEF4444)),
                          ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 28),
                  child: Center(
                    child: Text(
                      'Sisa percobaan: $_attemptsLeft',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _attemptsLeft <= 2 ? const Color(0xFFEF4444) : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],

              // Tombol di atas resend
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (_isLoading || _timerSeconds == 0 || _isBlocked) ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bluePrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    disabledBackgroundColor: const Color(0xFF93C5FD),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          _isBlocked ? 'DIBLOKIR' : 'Verifikasi',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                ),
              ),

              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: (_timerSeconds == 0 && !_isBlocked) ? _resendOtp : null,
                  child: Text(
                    'Kirim ulang kode',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: (_timerSeconds == 0 && !_isBlocked)
                          ? AppColors.bluePrimary
                          : Colors.black26,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    final isEmpty = _controllers[index].text.isEmpty;

    return SizedBox(
      width: 46,
      height: 54,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.text,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
        ],
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: isEmpty ? const Color(0xFFFFFBEB) : const Color(0xFFF9FAFB),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isEmpty ? const Color(0xFFF59E0B) : const Color(0xFFE5E7EB),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isEmpty ? const Color(0xFFF59E0B) : const Color(0xFFE5E7EB),
              width: isEmpty ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.bluePrimary, width: 2),
          ),
        ),
        onChanged: (val) {
          if (val.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (val.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          setState(() {});
        },
      ),
    );
  }
}