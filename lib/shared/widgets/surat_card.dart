import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';

enum CardRole { tu, kepsek, other }

class SuratCard extends StatelessWidget {
  final String jenisSurat;
  final String tanggal;
  final Map<String, String> data;
  final CardRole role;
  final String? status;
  final VoidCallback? onDelete;
  final VoidCallback onDetail;

  const SuratCard({
    super.key,
    required this.jenisSurat,
    required this.tanggal,
    required this.data,
    required this.role,
    this.status,
    this.onDelete,
    required this.onDetail,
  });

  // ===== STATUS LABEL =====
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
    if (role == CardRole.kepsek) {
      if (jenisSurat.toLowerCase() == 'surat masuk') {
        return AppColors.bluePrimary;
      } else {
        return AppColors.orangePrimary;
      }
    }

    if (role == CardRole.other) {
      return AppColors.bluePrimary;
    }

    return AppColors.bluePrimary;
  }


  @override


  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    return GestureDetector(
      onTap: onDetail,
      child: Container(
        margin: EdgeInsets.only(bottom: w * 0.045),
        padding: EdgeInsets.fromLTRB(w * 0.04, w * 0.04, w * 0.04, w * 0.035),
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
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: w * 0.02,
              offset: Offset(0, w * 0.01),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= HEADER =================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          jenisSurat,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: w * 0.042,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.02),

                      if (role == CardRole.tu && status != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.03,
                            vertical: w * 0.012,
                          ),
                          decoration: BoxDecoration(
                            color: _bgColor(),
                            borderRadius: BorderRadius.circular(w * 0.06),
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

                SizedBox(width: w * 0.02),

                Text(
                  tanggal,
                  style: TextStyle(
                    fontSize: w * 0.03,
                    color: const Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            SizedBox(height: w * 0.03),

            /// ================= DETAIL =================
            _infoText("Dari", data['Dari'], w),
            _infoText("Perihal", data['Perihal'], w),

            SizedBox(height: w * 0.04),

            /// ================= FOOTER =================
            /// ================= FOOTER =================
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /// ===== ROLE TU =====
                if (role == CardRole.tu) ...[
                    OutlinedButton.icon(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete_outline, size: w * 0.045),
                      label: Text("Hapus", style: TextStyle(fontSize: w * 0.032)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: EdgeInsets.symmetric(
                          horizontal: w * 0.04,
                          vertical: w * 0.025,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(w * 0.04),
                        ),
                      ),
                    ),

                    SizedBox(width: w * 0.03),

                    CircleAvatar(
                      radius: w * 0.055,
                      backgroundColor: _buttonColor(),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: w * 0.055,
                      ),
                    ),
                  ]
                  /// ===== ROLE KEPSEK & OTHER =====
                  else ...[
                    SizedBox(
                      height: w * 0.085,
                      child: ElevatedButton(
                        onPressed: onDetail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _buttonColor(),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w * 0.03),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Detail",
                              style: TextStyle(
                                fontSize: w * 0.032,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: w * 0.02),
                            Icon(Icons.arrow_forward_rounded, size: w * 0.045),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper untuk teks detail
  Widget _infoText(String label, String? value, double w) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.02),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: w * 0.034, color: Colors.black87),
          children: [
            TextSpan(
              text: "$label : ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value ?? '-'),
          ],
        ),
      ),
    );
  }
}
