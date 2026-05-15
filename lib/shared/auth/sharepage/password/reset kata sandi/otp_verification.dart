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
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  int _timerSeconds = 120;
  int _attemptsLeft = 5;

  bool _isBlocked = false;
  int _blockSeconds = 0;
  Timer? _timer;
  Timer? _blockTimer;

  String? _notifType;
  String? _notifMessage;

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
    setState(() {
      _isBlocked = true;
      _blockSeconds = 25 * 60; // ← 25 menit
    });

    _blockTimer?.cancel();
    _blockTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_blockSeconds <= 0) {
        t.cancel();
        setState(() {
          _isBlocked = false;
          _attemptsLeft = 5;
          _notifType = 'success';
          _notifMessage = 'Anda dapat mencoba kembali sekarang';
        });
      } else {
        setState(() => _blockSeconds--);
      }
    });
  }

  String get _timerText {
    final m = (_timerSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_timerSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _blockTimerText {
    final m = (_blockSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_blockSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _maskedEmail {
    final parts = widget.email.split('@');
    if (parts.length != 2) return widget.email;
    final local = parts[0];
    final domain = parts[1];
    if (local.length <= 2) return widget.email;
    return '${local.substring(0, 2)}***@$domain';
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  void _showNotif(String type, String message) {
    setState(() {
      _notifType = type;
      _notifMessage = message;
    });
    if (type != 'block') {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _notifType = null);
      });
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpCode.length < 6) {
      for (int i = 0; i < 6; i++) {
        if (_controllers[i].text.isEmpty) {
          _focusNodes[i].requestFocus();
          break;
        }
      }
      _showNotif('error', 'OTP salah. Silakan coba lagi.');
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
      _showLimitDialog();
      return;
    }

    _showNotif('error', 'OTP salah. Sisa $_attemptsLeft percobaan');
  }

  void _showLimitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFEF4444),
              size: 28,
            ),
            SizedBox(width: 12),
            Flexible(
              child: Text(
                'Batas OTP Tercapai',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),
          ],
        ),
        content: const Text(
          'Terlalu banyak percobaan. Tunggu 25 menit untuk mencoba lagi.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startBlockTimer();
              _clearOtpFields();
            },
            child: const Text(
              'OK',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resendOtp() {
    if (_isBlocked) return;

    _attemptsLeft--;

    if (_attemptsLeft <= 0) {
      _clearOtpFields();
      _showLimitDialog();
      return;
    }

    _clearOtpFields();
    _startTimer();
    setState(() {});
    _showNotif('success', 'Kode OTP berhasil dikirim ulang');
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── ICON ────────────────────────────────────────────────────
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.key_outlined,
                  color: AppColors.bluePrimary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 24),

              // ── TITLE ───────────────────────────────────────────────────
              const Text(
                'Verifikasi OTP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'Kode OTP sudah dikirim ke\n'),
                    TextSpan(
                      text: _maskedEmail,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // ── LABEL OTP ───────────────────────────────────────────────
              const Text(
                'Kode OTP',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // ── OTP BOXES ───────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) => _buildOtpBox(i)),
              ),
              const SizedBox(height: 16),

              // ── IN-PAGE NOTIF ─────────────────────────────────────────────
              if (_notifType != null) _buildNotifBanner(),

              const SizedBox(height: 8),

              // ── STATUS ────────────────────────────────────────────────────
              if (_isBlocked)
                _buildBlockedStatus()
              else ...[
                Center(
                  child: _timerSeconds > 0
                      ? RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black45,
                            ),
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
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Sisa percobaan: $_attemptsLeft',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _attemptsLeft <= 2
                          ? const Color(0xFFEF4444)
                          : Colors.black54,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // ── TOMBOL VERIFIKASI ──────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (_isLoading || _timerSeconds == 0 || _isBlocked)
                      ? null
                      : _verifyOtp,
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
                          'Verifikasi',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // ── KIRIM ULANG ────────────────────────────────────────────────
              Center(
                child: TextButton(
                  onPressed: (_timerSeconds == 0 && !_isBlocked)
                      ? _resendOtp
                      : null,
                  child: Text(
                    _isBlocked
                        ? 'Tunggu timer untuk kirim OTP baru'
                        : 'Kirim ulang kode',
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

  // ── IN-PAGE BANNER NOTIF ──────────────────────────────────────────────────
  Widget _buildNotifBanner() {
    final isSuccess = _notifType == 'success';

    final color = isSuccess ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            width: 6,
            height: 6,

            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),

          const SizedBox(width: 8),

          Text(
            _notifMessage ?? '',

            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── BLOCKED STATUS ────────────────────────────────────────────────────────
  Widget _buildBlockedStatus() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B)),
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
                  const TextSpan(text: 'Percobaan tercapai. Coba lagi dalam '),
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
    );
  }

  // ── OTP BOX ───────────────────────────────────────────────────────────────
  Widget _buildOtpBox(int index) {
    final isFilled = _controllers[index].text.isNotEmpty;

    return SizedBox(
      width: 46,
      height: 54,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              _controllers[index].text.isEmpty &&
              index > 0) {
            _focusNodes[index - 1].requestFocus();
            _controllers[index - 1].clear();
            setState(() {});
          }
        },
        child: TextFormField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          maxLength: 6,
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
            fillColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isFilled ? AppColors.bluePrimary : Colors.grey.shade300,
                width: isFilled ? 1.5 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.bluePrimary,
                width: 2,
              ),
            ),
          ),
          onChanged: (val) {
            if (val.length > 1) {
              final clean = val.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
              for (int i = 0; i < 6; i++) {
                _controllers[i].text = i < clean.length ? clean[i] : '';
              }
              _focusNodes[5].requestFocus();
              setState(() {});
              return;
            }

            if (val.isNotEmpty && index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else if (val.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
            setState(() {});
          },
        ),
      ),
    );
  }
}
