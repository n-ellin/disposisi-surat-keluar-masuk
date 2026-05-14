import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';

enum CardRole { tu, kepsek, other }

enum CardType { home, menu, history }

class SuratCard extends StatelessWidget {
  final String jenisSurat;
  final String tanggal;
  final Map<String, String> data;
  final CardRole role;
  final CardType type;
  final String? status;
  final VoidCallback onDetail;

  const SuratCard({
    super.key,
    required this.jenisSurat,
    required this.tanggal,
    required this.data,
    required this.role,
    required this.type,
    required this.onDetail,
    this.status,
  });

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
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.038,
          vertical: w * 0.042,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(w * 0.04),
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
    final isMasuk = jenisSurat == 'Surat Masuk';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// ICON
        Container(
          width: w * 0.10,
          height: w * 0.10,
          decoration: BoxDecoration(
            color: isMasuk ? const Color(0xFFE7F6F8) : const Color(0xFFFFF1E3),
            borderRadius: BorderRadius.circular(w * 0.03),
          ),
          child: Center(
            child: SvgPicture.asset(
              isMasuk
                  ? "assets/icons/ic_inmail.svg"
                  : "assets/icons/ic_outmail.svg",
              width: w * 0.05,
              height: w * 0.05,
              colorFilter: ColorFilter.mode(
                isMasuk ? AppColors.bluePrimary : AppColors.orangePrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),

        SizedBox(width: w * 0.03),

        /// KIRI: Perihal + Dari
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data['Perihal'] ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: w * 0.033,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: w * 0.005),
              Text(
                data['Dari'] ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: w * 0.028,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: w * 0.02),

        /// KANAN: Tanggal + Badge
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tanggal,
              style: TextStyle(
                fontSize: w * 0.024,
                color: Colors.grey.shade500,
              ),
            ),
            if (showStatus && status != null) ...[
              SizedBox(height: w * 0.006),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.022,
                  vertical: w * 0.005,
                ),
                decoration: BoxDecoration(
                  color: _bgColor(),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  _label(),
                  style: TextStyle(
                    fontSize: w * 0.022,
                    fontWeight: FontWeight.w700,
                    color: _textColor(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// ================= MENU & HISTORY =================
  Widget _buildDefaultCard(double w) {
    final isMasuk = jenisSurat == 'Surat Masuk';

    // Layout kanan: tanggal + tombol Detail (sama untuk menu & history)
    Widget rightColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          tanggal,
          style: TextStyle(
            fontSize: w * 0.024,
            color: Colors.grey.shade500,
          ),
        ),
        SizedBox(height: w * 0.02),
        ElevatedButton(
          onPressed: onDetail,
          style: ElevatedButton.styleFrom(
            backgroundColor: _buttonColor(),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.03,
              vertical: w * 0.015,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(w * 0.03),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Detail", style: TextStyle(fontSize: w * 0.03)),
              SizedBox(width: w * 0.01),
              Icon(Icons.arrow_forward_rounded, size: w * 0.035),
            ],
          ),
        ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// ICON kiri
        Container(
          width: w * 0.11,
          height: w * 0.11,
          decoration: BoxDecoration(
            color: isMasuk
                ? const Color(0xFFE7F6F8)
                : const Color(0xFFFFF1E3),
            borderRadius: BorderRadius.circular(w * 0.03),
          ),
          child: Center(
            child: SvgPicture.asset(
              isMasuk
                  ? "assets/icons/ic_inmail.svg"
                  : "assets/icons/ic_outmail.svg",
              width: w * 0.045,
              height: w * 0.045,
              colorFilter: ColorFilter.mode(
                isMasuk ? AppColors.bluePrimary : AppColors.orangePrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),

        SizedBox(width: w * 0.03),

        /// TENGAH: jenis + badge + perihal + dari
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      jenisSurat,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: w * 0.037,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.02),
                  if (showStatus && status != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.025,
                        vertical: w * 0.008,
                      ),
                      decoration: BoxDecoration(
                        color: _bgColor(),
                        borderRadius: BorderRadius.circular(w * 0.05),
                      ),
                      child: Text(
                        _label(),
                        style: TextStyle(
                          fontSize: w * 0.024,
                          fontWeight: FontWeight.w700,
                          color: _textColor(),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: w * 0.008),
              Text(
                data['Perihal'] ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: w * 0.031,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: w * 0.004),
              Text(
                data['Dari'] ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: w * 0.028,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: w * 0.02),

        rightColumn,
      ],
    );
  }

  /// ================= INFO =================
  Widget _infoText(String label, String? value, double w) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.018),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: w * 0.034, color: Colors.black87),
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