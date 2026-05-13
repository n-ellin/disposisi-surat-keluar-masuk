import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';

enum CardRole { tu, kepsek, other }

enum CardType {
  home,
  menu,
  history,
}

class SuratCard extends StatelessWidget {
  final String jenisSurat;
  final String tanggal;
  final Map<String, String> data;

  final CardRole role;
  final CardType type;

  final String? status;

  final VoidCallback onDetail;
  final VoidCallback? onDelete;

  const SuratCard({
    super.key,
    required this.jenisSurat,
    required this.tanggal,
    required this.data,
    required this.role,
    required this.type,
    required this.onDetail,
    this.onDelete,
    this.status,
  });

  /// ================= STATUS =================

  bool get showStatus => role == CardRole.tu;

  bool get isHome => type == CardType.home;
  bool get isMenu => type == CardType.menu;
  bool get isHistory => type == CardType.history;

  String _label() {
    switch (status?.toLowerCase()) {
      case 'disetujui':
        return 'Disetujui';
      case 'ditolak':
        return 'Ditolak';
      case 'menunggu':
        return 'Menunggu';
      default:
        return '';
    }
  }

  Color _bgColor() {
    switch (status?.toLowerCase()) {
      case 'disetujui':
        return const Color(0xFFDDEEDC);
      case 'ditolak':
        return const Color(0xFFF4D6D8);
      case 'menunggu':
        return const Color(0xFFF1E2BF);
      default:
        return Colors.grey.shade200;
    }
  }

  Color _textColor() {
    switch (status?.toLowerCase()) {
      case 'disetujui':
        return const Color(0xFF2E7D32);
      case 'ditolak':
        return const Color(0xFFB4232C);
      case 'menunggu':
        return const Color(0xFF8A6D1F);
      default:
        return Colors.grey;
    }
  }

  Color _buttonColor() {
    if (jenisSurat.toLowerCase() == 'surat keluar') {
      return AppColors.orangePrimary;
    }
    return AppColors.bluePrimary;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: isHome ? onDetail : null,
      child: Container(
        margin: EdgeInsets.only(bottom: w * 0.045),
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(w * 0.05),
          border: Border.all(color: const Color(0xFFEAEAEA)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: w * 0.05,
              offset: Offset(0, w * 0.025),
            ),
          ],
        ),
        child: isHome ? _buildHomeCard(w) : _buildDefaultCard(w),
      ),
    );
  }

  /// ================= HOME CARD =================

  Widget _buildHomeCard(double w) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(w * 0.028),
          decoration: BoxDecoration(
            color: jenisSurat == 'Surat Masuk'
                ? const Color(0xFF0F6E7A).withOpacity(0.12)
                : const Color(0xFFDA7B17).withOpacity(0.12),
            borderRadius: BorderRadius.circular(w * 0.03),
          ),
          child: Icon(
            jenisSurat == 'Surat Masuk'
                ? Icons.mail_outline
                : Icons.outgoing_mail,
            color: jenisSurat == 'Surat Masuk'
                ? AppColors.bluePrimary
                : AppColors.orangePrimary,
          ),
        ),

        SizedBox(width: w * 0.035),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['Perihal'] ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: w * 0.038,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: w * 0.01),
              Text(
                data['Dari'] ?? '-',
                style: TextStyle(
                  fontSize: w * 0.032,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        if (showStatus && status != null)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.03,
              vertical: w * 0.012,
            ),
            decoration: BoxDecoration(
              color: _bgColor(),
              borderRadius: BorderRadius.circular(w * 0.05),
            ),
            child: Text(
              _label(),
              style: TextStyle(
                fontSize: w * 0.028,
                fontWeight: FontWeight.w700,
                color: _textColor(),
              ),
            ),
          ),
      ],
    );
  }

  /// ================= MENU & HISTORY =================

  Widget _buildDefaultCard(double w) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      jenisSurat,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: w * 0.042,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  SizedBox(width: w * 0.02),

                  if (showStatus && status != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.03,
                        vertical: w * 0.012,
                      ),
                      decoration: BoxDecoration(
                        color: _bgColor(),
                        borderRadius: BorderRadius.circular(w * 0.05),
                      ),
                      child: Text(
                        _label(),
                        style: TextStyle(
                          fontSize: w * 0.028,
                          fontWeight: FontWeight.w700,
                          color: _textColor(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: w * 0.015),

        Text(
          tanggal,
          style: TextStyle(
            fontSize: w * 0.03,
            color: Colors.grey.shade500,
          ),
        ),

        SizedBox(height: w * 0.04),

        _infoText("Dari", data['Dari'], w),
        _infoText("Perihal", data['Perihal'], w),

        SizedBox(height: w * 0.04),

        Align(
          alignment: Alignment.centerRight,
          child: isHistory
              ? InkWell(
                  onTap: onDetail,
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    padding: EdgeInsets.all(w * 0.028),
                    decoration: BoxDecoration(
                      color: _buttonColor(),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.visibility_outlined,
                      color: Colors.white,
                      size: w * 0.045,
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: onDetail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _buttonColor(),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.03),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Detail"),
                      SizedBox(width: w * 0.015),
                      const Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  /// ================= INFO =================

  Widget _infoText(String label, String? value, double w) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.018),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: w * 0.034,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: "$label : ",
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value ?? '-'),
          ],
        ),
      ),
    );
  }
}