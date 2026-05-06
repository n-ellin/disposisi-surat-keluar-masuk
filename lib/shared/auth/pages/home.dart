import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/modules/kepsek/menuukepsek.dart';
import 'package:ta_mobile_disposisi_surat/shared/auth/pages/notif.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/navbar_role.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/navigation_helper.dart';
import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/menuTU.dart';
import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/detail_surat/output_suratmasuk.dart';
import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/detail_surat/output_suratkeluar.dart';

class Home extends StatefulWidget {
  final NavbarRole role;
  const Home({super.key, required this.role});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ✅ dummy 5 surat terbaru
  final List<Map<String, dynamic>> _suratTerbaru = [
    {
      'jenis': 'Surat Masuk',
      'dari': 'Dinas Pendidikan',
      'perihal': 'Undangan Rapat',
      'tanggal': '10 Okt 2025',
      'status': 'disetujui',
      'catatan': 'Harap hadir tepat waktu',
      'tujuan': 'Kepala Sekolah',
      'instruksi': 'Disposisi segera',
      'koordinasi': 'Wakil Kepala Sekolah',
      'diteruskanKe': 'Kepala Sekolah',
      'sifat': 'Segera',
      'lampiran': ['assets/images/undangan.png'],
    },
    {
      'jenis': 'Surat Keluar',
      'dari': 'Tata Usaha',
      'perihal': 'Permohonan Izin',
      'tanggal': '8 Okt 2025',
      'status': 'ditolak',
      'catatan': 'Dokumen tidak lengkap',
      'lampiran': ['assets/images/undangan.png'],
    },
    {
      'jenis': 'Surat Masuk',
      'dari': 'Kemenag',
      'perihal': 'Laporan Tahunan',
      'tanggal': '5 Okt 2025',
      'status': 'diproses',
      'catatan': 'Segera ditindaklanjuti',
      'tujuan': '-',
      'instruksi': '-',
      'koordinasi': '-',
      'diteruskanKe': '-',
      'sifat': '-',
      'lampiran': [],
    },
    {
      'jenis': 'Surat Keluar',
      'dari': 'Tata Usaha',
      'perihal': 'Pengajuan Dana',
      'tanggal': '3 Okt 2025',
      'status': 'disetujui',
      'catatan': 'Dana telah disetujui',
      'lampiran': [],
    },
    {
      'jenis': 'Surat Masuk',
      'dari': 'Dinas Kesehatan',
      'perihal': 'Sosialisasi Kesehatan',
      'tanggal': '1 Okt 2025',
      'status': 'diproses',
      'catatan': 'Menunggu konfirmasi',
      'tujuan': '-',
      'instruksi': '-',
      'koordinasi': '-',
      'diteruskanKe': '-',
      'sifat': '-',
      'lampiran': [],
    },
  ];

  int jumlahSuratMasuk = 0;
  int jumlahSuratKeluar = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.03),

                // ── HEADER ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/logosmk.jpg",
                      width: w * 0.1,
                      height: w * 0.1,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NotificationPage(role: widget.role),
                          ),
                        );
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: w * 0.075,
                            color: AppColors.bluePrimary,
                          ),
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: const Center(
                                child: Text(
                                  "12",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                const Text(
                  "Disposisi Surat",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: h * 0.03),

                // ── STAT CARD (aktif, bisa diklik) ──
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // ✅ navigasi ke menu surat masuk
                          if (widget.role == NavbarRole.tu) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TuDashboardPage(
                                  jenisSurat: 'Surat Masuk',
                                ),
                              ),
                            );
                          } else if (widget.role == NavbarRole.kepsek) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const KepsekDashboardPage(
                                  jenisSurat: 'Surat Masuk',
                                ),
                              ),
                            );
                          }
                        },
                        child: _statCard(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6DA8B4), Color(0xFF0F6E7A)],
                          ),
                          iconPath: "assets/icons/ic_inmail.svg",
                          jumlah: "10",
                          label: "Surat Masuk",
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.04),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // ✅ navigasi ke menu surat keluar
                          if (widget.role == NavbarRole.tu) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TuDashboardPage(
                                  jenisSurat: 'Surat Keluar',
                                ),
                              ),
                            );
                          } else if (widget.role == NavbarRole.kepsek) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const KepsekDashboardPage(
                                  jenisSurat: 'Surat Keluar',
                                ),
                              ),
                            );
                          }
                        },
                        child: _statCard(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD6A66B), Color(0xFFDA7B17)],
                          ),
                          iconPath: "assets/icons/ic_outmail.svg",
                          jumlah: "10",
                          label: "Surat Keluar",
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: h * 0.04),

                // ── HEADER SURAT TERBARU ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Surat Terbaru",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: h * 0.015),

                // ── LIST 5 SURAT TERBARU ──
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _suratTerbaru.length,
                  itemBuilder: (context, index) {
                    final surat = _suratTerbaru[index];
                    return _suratTerbaruCard(surat);
                  },
                ),

                SizedBox(height: h * 0.03),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavbar(
        role: widget.role,
        currentIndex: 0,
        onTap: (index) {
          handleNavbarTap(context, index, widget.role);
        },
      ),
    );
  }

  Widget _suratTerbaruCard(Map<String, dynamic> surat) {
    final isMasuk = surat['jenis'] == 'Surat Masuk';

    Color statusColor;
    switch (surat['status']) {
      case 'disetujui':
        statusColor = const Color(0xFF3F9142);
        break;
      case 'ditolak':
        statusColor = const Color(0xFFB63A3A);
        break;
      default:
        statusColor = const Color(0xFFE08B2E);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => isMasuk
                ? OutputSuratmasuk(
                    isApproved: surat['status'] == 'disetujui',
                    catatan: surat['catatan'] ?? '-',
                    tujuan: surat['tujuan'] ?? '-',
                    instruksi: surat['instruksi'] ?? '-',
                    koordinasi: surat['koordinasi'] ?? '-',
                    diteruskanKe: surat['diteruskanKe'] ?? '-',
                    sifat: surat['sifat'] ?? '-',
                    isReadOnly: true,
                  )
                : OutputSuratkeluar(catatan: surat['catatan'] ?? '-'),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // ICON
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isMasuk
                    ? const Color(0xFF0F6E7A).withOpacity(0.12)
                    : const Color(0xFFDA7B17).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                isMasuk
                    ? "assets/icons/ic_inmail.svg"
                    : "assets/icons/ic_outmail.svg",
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isMasuk ? const Color(0xFF0F6E7A) : const Color(0xFFDA7B17),
                  BlendMode.srcIn,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surat['perihal'] ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    surat['dari'] ?? '-',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),

            // RIGHT SIDE (tanggal + status)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  surat['tanggal'] ?? '-',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    surat['status'][0].toUpperCase() +
                        surat['status'].substring(1),
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required LinearGradient gradient,
    required String iconPath,
    required String jumlah,
    required String label,
  }) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(w * 0.05),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.last.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jumlah,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
