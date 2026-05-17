import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';

// ── ENUMS ─────────────────────────────────────────────────────────────────────

enum CardRole { tu, kepsek, Users }

enum CardType { home, menu, history }

// ── WIDGET ────────────────────────────────────────────────────────────────────

class SuratCard extends StatelessWidget {
  final String jenisSurat;
  final String tanggal;
  final Map<String, String> data;
  final CardRole role;
  final CardType type;
  final String? status;
  final String? diteruskanKe;
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
    this.diteruskanKe,
  });

  // ── GETTERS ──────────────────────────────────────────────────────────────────

  bool get showStatus => role == CardRole.tu;
  bool get isHome => type == CardType.home;
  bool get isHistory => type == CardType.history;
  bool get showDiteruskanKe =>
      role == CardRole.Users &&
      diteruskanKe != null &&
      diteruskanKe!.isNotEmpty;

  // ── STATUS HELPERS ───────────────────────────────────────────────────────────

  String _label() {
    switch (status?.toLowerCase()) {
      case 'disetujui':
        return 'Disetujui';
      case 'ditolak':
        return 'Ditolak';
      case 'menunggu':
      case 'diproses':
        return 'Diproses';
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
      case 'diproses':
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
      case 'diproses':
        return const Color(0xFF8A6D1F);
      default:
        return Colors.grey;
    }
  }

  Color _buttonColor() {
    return jenisSurat.toLowerCase() == 'surat keluar'
        ? AppColors.orangePrimary
        : AppColors.bluePrimary;
  }

  // ── BUILD ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: isHome ? onDetail : null,
      child: Container(
        margin: EdgeInsets.only(bottom: w * 0.025),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(w * 0.04),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left stroke — history only
                if (isHistory)
                  Container(width: w * 0.015, color: _buttonColor()),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isHistory ? w * 0.03 : w * 0.045,
                      vertical: isHistory ? w * 0.025 : w * 0.038,
                    ),
                    child: isHome
                        ? _buildHomeCard(w)
                        : isHistory
                            ? _buildHistoryCard(w)
                            : _buildMenuCard(w),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── HOME CARD ────────────────────────────────────────────────────────────────
  // Layout visual:
  //   [Icon]  [Perihal ............] [tanggal ]
  //           [Dari ................] [badge   ]
  //
  // Kolom kanan (tanggal + badge) menggunakan CrossAxisAlignment.end
  // dan tinggi tiap slot menyesuaikan tinggi baris kiri (Perihal & Dari).

  Widget _buildHomeCard(double w) {
    final isMasuk = jenisSurat == 'Surat Masuk';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Icon ──
        Container(
          width: w * 0.11,
          height: w * 0.11,
          decoration: BoxDecoration(
            color: isMasuk ? const Color(0xFFE7F6F8) : const Color(0xFFFFF1E3),
            borderRadius: BorderRadius.circular(w * 0.035),
          ),
          child: Center(
            child: SvgPicture.asset(
              isMasuk
                  ? 'assets/icons/ic_inmail.svg'
                  : 'assets/icons/ic_outmail.svg',
              width: w * 0.055,
              height: w * 0.055,
              colorFilter: ColorFilter.mode(
                isMasuk ? AppColors.bluePrimary : AppColors.orangePrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),

        SizedBox(width: w * 0.035),

        // ── Perihal & Dari ──
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Baris Perihal
              Text(
                data['Perihal'] ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: w * 0.036,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: w * 0.007),
              // Baris Dari
              Text(
                data['Dari'] ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: w * 0.030,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: w * 0.02),

        // ── Kolom kanan: tanggal (sejajar Perihal) + badge (sejajar Dari) ──
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tanggal — tinggi sama dengan baris Perihal
            SizedBox(
              height: w * 0.036 * 1.4,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  tanggal,
                  style: TextStyle(
                    fontSize: w * 0.032,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),
            SizedBox(height: w * 0.007),
            // Badge status — tinggi sama dengan baris Dari
            SizedBox(
              height: w * 0.030 * 1.4,
              child: Align(
                alignment: Alignment.centerRight,
                child: showStatus && status != null
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: w * 0.03,
                          vertical: w * 0.004,
                        ),
                        decoration: BoxDecoration(
                          color: _bgColor(),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          _label(),
                          style: TextStyle(
                            fontSize: w * 0.028,
                            fontWeight: FontWeight.w700,
                            color: _textColor(),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── HISTORY CARD ─────────────────────────────────────────────────────────────

  Widget _buildHistoryCard(double w) {
    final isMasuk = jenisSurat == 'Surat Masuk';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── BARIS ATAS: icon + jenis surat + badge status + tanggal ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: w * 0.07,
                    height: w * 0.07,
                    decoration: BoxDecoration(
                      color: isMasuk
                          ? const Color(0xFFE7F6F8)
                          : const Color(0xFFFFF1E3),
                      borderRadius: BorderRadius.circular(w * 0.02),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        isMasuk
                            ? 'assets/icons/ic_inmail.svg'
                            : 'assets/icons/ic_outmail.svg',
                        width: w * 0.035,
                        height: w * 0.035,
                        colorFilter: ColorFilter.mode(
                          isMasuk
                              ? AppColors.bluePrimary
                              : AppColors.orangePrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.02),
                  Text(
                    jenisSurat,
                    style: TextStyle(
                      fontSize: w * 0.036,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  // Badge status setelah label jenis surat
                  if (showStatus && status != null) ...[
                    SizedBox(width: w * 0.018),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.025,
                        vertical: w * 0.006,
                      ),
                      decoration: BoxDecoration(
                        color: _bgColor(),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        _label(),
                        style: TextStyle(
                          fontSize: w * 0.026,
                          fontWeight: FontWeight.w700,
                          color: _textColor(),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Tanggal
            Text(
              tanggal,
              style: TextStyle(
                fontSize: w * 0.032,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),

        SizedBox(height: w * 0.018),
        Divider(height: 1, color: Colors.grey.shade100),
        SizedBox(height: w * 0.018),

        // ── BARIS BAWAH: perihal + dari + eye button ──
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                      fontSize: w * 0.034,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: w * 0.005),
                  Text(
                    data['Dari'] ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: w * 0.029,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: w * 0.02),

            // Eye button
            GestureDetector(
              onTap: onDetail,
              child: Container(
                width: w * 0.085,
                height: w * 0.085,
                decoration: BoxDecoration(
                  color: _buttonColor().withOpacity(0.12),
                  borderRadius: BorderRadius.circular(w * 0.025),
                ),
                child: Center(
                  child: Icon(
                    Icons.remove_red_eye_rounded,
                    color: _buttonColor(),
                    size: w * 0.045,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── MENU CARD ────────────────────────────────────────────────────────────────
  // Layout visual:
  //   [Icon]  [Surat Masuk  badge] [tanggal      ]
  //           [Perihal            ] [              ]
  //           [Dari               ] [button Detail ]
  //
  // Kolom kanan: tanggal sejajar baris jenis surat, button sejajar Perihal+Dari.

  Widget _buildMenuCard(double w) {
    final isMasuk = jenisSurat == 'Surat Masuk';

    // Tinggi baris "Jenis Surat" agar tanggal & button bisa disejajarkan
    final double rowJenisSuratH = w * 0.042 * 1.4;
    // Tinggi gabungan Perihal + gap + Dari
    final double rowPerihalDariH =
        (w * 0.036 * 1.4) + (w * 0.003) + (w * 0.032 * 1.4);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Icon — sejajar tengah dengan seluruh kolom teks ──
        Container(
          width: w * 0.13,
          height: w * 0.13,
          decoration: BoxDecoration(
            color: isMasuk
                ? const Color(0xFFE7F6F8)
                : const Color(0xFFFFF1E3),
            borderRadius: BorderRadius.circular(w * 0.03),
          ),
          child: Center(
            child: SvgPicture.asset(
              isMasuk
                  ? 'assets/icons/ic_inmail.svg'
                  : 'assets/icons/ic_outmail.svg',
              width: w * 0.058,
              height: w * 0.058,
              colorFilter: ColorFilter.mode(
                isMasuk ? AppColors.bluePrimary : AppColors.orangePrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),

        SizedBox(width: w * 0.03),

        // ── Konten tengah ──
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Baris 1: Jenis surat + badge
              SizedBox(
                height: rowJenisSuratH,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    if (showStatus && status != null) ...[
                      SizedBox(width: w * 0.02),
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
                            fontSize: w * 0.026,
                            fontWeight: FontWeight.w700,
                            color: _textColor(),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: w * 0.006),

              // Baris 2: Perihal
              Text(
                data['Perihal'] ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: w * 0.036,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: w * 0.003),

              // Baris 3: Dari
              Text(
                data['Dari'] ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: w * 0.032,
                  color: Colors.grey.shade600,
                ),
              ),

              if (showDiteruskanKe) ...[
                SizedBox(height: w * 0.012),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.022,
                    vertical: w * 0.007,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(w * 0.02),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: w * 0.033,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: w * 0.01),
                      Flexible(
                        child: Text(
                          'Untuk: ${diteruskanKe!}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: w * 0.027,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        SizedBox(width: w * 0.02),

        // ── Kolom kanan: tanggal sejajar jenis surat, button sejajar perihal+dari ──
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tanggal — tinggi = tinggi baris jenis surat
            SizedBox(
              height: rowJenisSuratH,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  tanggal,
                  style: TextStyle(
                    fontSize: w * 0.032,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),

            SizedBox(height: w * 0.006),

            // Button Detail — tinggi = tinggi perihal + gap + dari
            SizedBox(
              height: rowPerihalDariH,
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: onDetail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _buttonColor(),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: Size(0, w * 0.078),
                    padding: EdgeInsets.symmetric(horizontal: w * 0.032),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.022),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Detail',
                        style: TextStyle(
                          fontSize: w * 0.030,
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                      SizedBox(width: w * 0.006),
                      Icon(Icons.arrow_forward_rounded, size: w * 0.031),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}