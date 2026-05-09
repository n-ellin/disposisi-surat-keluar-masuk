import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/modules/kepsek/menuukepsek.dart';
import 'package:ta_mobile_disposisi_surat/shared/auth/sharepage/notif.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/navigation_helper.dart';
import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/menuTU.dart';
import 'package:ta_mobile_disposisi_surat/modules/kepsek/menuukepsek.dart';
import 'package:ta_mobile_disposisi_surat/modules/other/menuother.dart';

class Home extends StatefulWidget {
  final Role role;
  const Home({super.key, required this.role});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final List<Map<String, dynamic>> _suratTerbaru = [
    {
      'jenis': 'Surat Masuk',
      'dari': 'Dinas Pendidikan',
      'perihal': 'Undangan Rapat',
      'tanggal': '10 Okt 2025',
      'status': 'disetujui',
    },
    {
      'jenis': 'Surat Keluar',
      'dari': 'Tata Usaha',
      'perihal': 'Permohonan Izin',
      'tanggal': '8 Okt 2025',
      'status': 'ditolak',
    },
    {
      'jenis': 'Surat Masuk',
      'dari': 'Kemenag',
      'perihal': 'Laporan Tahunan',
      'tanggal': '5 Okt 2025',
      'status': 'diproses',
    },
    {
      'jenis': 'Surat Keluar',
      'dari': 'Tata Usaha',
      'perihal': 'Pengajuan Dana',
      'tanggal': '3 Okt 2025',
      'status': 'disetujui',
    },
    {
      'jenis': 'Surat Masuk',
      'dari': 'Dinas Kesehatan',
      'perihal': 'Sosialisasi Kesehatan',
      'tanggal': '1 Okt 2025',
      'status': 'diproses',
    },
  ];

  /// ✅ Navigasi ke halaman menu sesuai role, dengan filter jenisSurat
  void _navigateToMenu(String jenisSurat) {
    switch (widget.role) {
      case Role.tu:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TuDashboardPage(jenisSurat: jenisSurat),
          ),
        );
        break;

      case Role.kepsek:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KepsekDashboardPage(jenisSurat: jenisSurat),
          ),
        );
        break;

      default:
        // NavbarRole.other atau role lainnya
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MenuOther(jenisSurat: jenisSurat),
          ),
        );
        break;
    }
  }

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                builder: (_) =>
                                    NotificationPage(role: widget.role),
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
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: h * 0.03),

                // ── STAT CARD ✅ Sekarang bisa diklik ──
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6DA8B4), Color(0xFF0F6E7A)],
                        ),
                        iconPath: "assets/icons/ic_inmail.svg",
                        jumlah: "10",
                        label: "Surat Masuk",
                        onTap: () => _navigateToMenu('Surat Masuk'), // ✅
                      ),
                    ),
                    SizedBox(width: w * 0.04),
                    Expanded(
                      child: _statCard(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD6A66B), Color(0xFFDA7B17)],
                        ),
                        iconPath: "assets/icons/ic_outmail.svg",
                        jumlah: "10",
                        label: "Surat Keluar",
                        onTap: () => _navigateToMenu('Surat Keluar'), // ✅
                      ),
                    ),
                  ],
                ),

                SizedBox(height: h * 0.04),

                // ── SURAT TERBARU ──
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
                    GestureDetector(
                      onTap: () => handleNavbarTap(context, 1, widget.role),
                      child: Text(
                        "Lihat Semua",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.bluePrimary,
                          fontWeight: FontWeight.w500,
                        ),
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

  // ── CARD SURAT TERBARU ──
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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isMasuk
                  ? const Color(0xFF0F6E7A).withOpacity(0.1)
                  : const Color(0xFFDA7B17).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              isMasuk
                  ? 'assets/icons/ic_inmail.svg'
                  : 'assets/icons/ic_outmail.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                isMasuk
                    ? const Color(0xFF0F6E7A)
                    : const Color(0xFFDA7B17),
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
                  surat['perihal'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  surat['dari'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                surat['tanggal'],
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
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
    );
  }

  // ✅ Tambahkan parameter onTap
  Widget _statCard({
    required LinearGradient gradient,
    required String iconPath,
    required String jumlah,
    required String label,
    required VoidCallback onTap,
  }) {
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap, // ✅ handle tap
      child: Container(
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
      ),
    );
  }
}