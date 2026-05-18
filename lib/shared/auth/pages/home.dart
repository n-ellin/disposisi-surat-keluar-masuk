import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';

import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';

import 'package:ta_mobile_disposisi_surat/shared/widgets/notification_page.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/core/helpers/navigation_helper.dart';

import 'package:ta_mobile_disposisi_surat/features/tata%20usaha/pages/menuTU.dart';
import 'package:ta_mobile_disposisi_surat/features/kepsek/pages/menu_kepsek_page.dart';

import 'package:ta_mobile_disposisi_surat/features/tata%20usaha/pages/hasil_disposisi_surat_masuk_page.dart';
import 'package:ta_mobile_disposisi_surat/features/tata%20usaha/pages/hasil_pengajuan_surat_keluar_page.dart';

import 'package:ta_mobile_disposisi_surat/features/kepsek/pages/disposisi_suratmasuk.dart';
import 'package:ta_mobile_disposisi_surat/features/kepsek/pages/pengajuan_suratkeluar.dart';

// Sesuaikan dengan ukuran CustomNavbar kamu:
// container height 70 + bottom padding 15 = 85
const double _kNavbarHeight = 85.0;

class Home extends StatefulWidget {
  final Role role;
  final String nama;
  final String email;
  final String jabatan;

  const Home({
    super.key,
    required this.role,
    required this.nama,
    required this.email,
    required this.jabatan,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Map<String, dynamic>> notifications;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  void _initNotifications() {
    if (widget.role == Role.tu) {
      notifications = [
        {
          "title": "Surat Masuk Ditolak",
          "desc":
              "Surat masuk telah ditolak Kepala Sekolah. Silakan periksa kembali dan tindak lanjuti.",
          "color": Colors.red,
          "createdAt": DateTime.now(),
          "isRead": false,
        },
        {
          "title": "Surat Masuk Diterima",
          "desc":
              "Surat masuk telah diterima Kepala Sekolah. Silakan lanjutkan proses.",
          "color": Colors.green,
          "createdAt": DateTime.now(),
          "isRead": false,
        },
        {
          "title": "Surat Keluar Ditolak",
          "desc":
              "Surat keluar ditolak Kepala Sekolah. Periksa kembali dan tindak lanjuti.",
          "color": Colors.red,
          "createdAt": DateTime.now().subtract(const Duration(days: 1)),
          "isRead": true,
        },
        {
          "title": "Surat Keluar Diterima",
          "desc":
              "Surat keluar telah diterima Kepala Sekolah. Silakan lanjutkan proses.",
          "color": Colors.green,
          "createdAt": DateTime.now().subtract(const Duration(days: 1)),
          "isRead": true,
        },
        {
          "title": "Surat Masuk Dikonfirmasi",
          "desc": "Surat masuk sudah dikonfirmasi oleh penerima.",
          "color": Colors.orange,
          "createdAt": DateTime.now().subtract(const Duration(days: 1)),
          "isRead": true,
        },
      ];
    } else if (widget.role == Role.kepsek) {
      notifications = [
        {
          "title": "Pemberitahuan Pengajuan Surat Keluar",
          "desc":
              "Terdapat pengajuan surat keluar yang memerlukan peninjauan dari Anda.",
          "color": Colors.orange,
          "createdAt": DateTime.now(),
          "isRead": false,
        },
        {
          "title": "Pemberitahuan Pengajuan Disposisi Surat Masuk",
          "desc":
              "Terdapat pengajuan disposisi surat masuk yang memerlukan persetujuan Anda.",
          "color": Colors.blue,
          "createdAt": DateTime.now(),
          "isRead": false,
        },
      ];
    } else {
      notifications = [
        {
          "title": "Pemberitahuan Surat Masuk",
          "desc":
              "Anda menerima surat masuk baru. Silakan periksa detail surat untuk informasi lebih lanjut.",
          "color": Colors.green,
          "createdAt": DateTime.now(),
          "isRead": false,
        },
      ];
    }
  }

  int get notifCount => notifications.where((n) => n['isRead'] == false).length;

  List<Map<String, dynamic>> get _allSurat => DummySurat.allSurat;

  List<Map<String, dynamic>> get _suratTerbaru =>
      DummySurat.allSurat.reversed.take(7).toList();

  int get jumlahSuratMasuk =>
      _allSurat.where((s) => s['jenisSurat'] == 'Surat Masuk').length;

  int get jumlahSuratKeluar =>
      _allSurat.where((s) => s['jenisSurat'] == 'Surat Keluar').length;

  Future<void> _openNotifikasi() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            NotificationPage(role: widget.role, notifications: notifications),
      ),
    );
    setState(() {
      for (var notif in notifications) {
        notif['isRead'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: AppColors.bg,

      // ❌ HAPUS bottomNavigationBar dari sini
      // ✅ Navbar dipindah ke Stack supaya list bisa scroll ke baliknya

      body: Stack(
        children: [
          // ── LAYER 1: KONTEN UTAMA ──────────────────────────────────────────
          SafeArea(
            // bottom: false → biarkan konten extend ke area navbar
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h * 0.03),

                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/logosmk.jpg",
                        width: w * 0.1,
                        height: w * 0.1,
                      ),

                      /// ICON NOTIF + BADGE
                      GestureDetector(
                        onTap: _openNotifikasi,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: w * 0.075,
                              color: AppColors.bluePrimary,
                            ),

                            /// BADGE
                            if (notifCount > 0)
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
                                  child: Center(
                                    child: Text(
                                      notifCount.toString(),
                                      style: const TextStyle(
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

                  /// TITLE
                  const Text(
                    "Disposisi Surat",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: h * 0.03),

                  /// STAT CARD
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (widget.role == Role.tu) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TuDashboardPage(
                                    jenisSurat: 'Surat Masuk',
                                  ),
                                ),
                              );
                            } else if (widget.role == Role.kepsek) {
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
                            jumlah: jumlahSuratMasuk.toString(),
                            label: "Masuk",
                          ),
                        ),
                      ),

                      SizedBox(width: w * 0.04),

                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (widget.role == Role.tu) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TuDashboardPage(
                                    jenisSurat: 'Surat Keluar',
                                  ),
                                ),
                              );
                            } else if (widget.role == Role.kepsek) {
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
                            jumlah: jumlahSuratKeluar.toString(),
                            label: "Keluar",
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: h * 0.04),

                  /// HEADER SURAT
                  const Text(
                    "Surat Terbaru",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: h * 0.015),

                  /// LIST SURAT
                  /// padding bottom = _kNavbarHeight + sedikit ruang extra
                  /// → card terakhir bisa di-scroll naik sampai kelihatan penuh
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: _kNavbarHeight),
                      itemCount: _suratTerbaru.length,
                      itemBuilder: (context, index) {
                        final surat = _suratTerbaru[index];
                        final isMasuk = surat['jenisSurat'] == 'Surat Masuk';

                        return SuratCard(
                          jenisSurat: surat['jenisSurat'] ?? '',
                          tanggal: surat['tanggal'] ?? '-',
                          data: Map<String, String>.from(surat['data'] ?? {}),
                          role: widget.role == Role.kepsek
                              ? CardRole.kepsek
                              : CardRole.tu,
                          type: CardType.home,

                          /// STATUS HANYA UNTUK TU
                          status: widget.role == Role.kepsek
                              ? null
                              : surat['status'],

                          onDetail: () {
                            /// KEPSEK
                            if (widget.role == Role.kepsek) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => isMasuk
                                      ? InputSuratMasuk(surat: surat)
                                      : const InputSuratKeluar(),
                                ),
                              );
                              return;
                            }

                            /// TU
                            final status =
                                surat['status']?.toString().toLowerCase();

                            if (status == 'menunggu') {
                              _showProcessDialog();
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => isMasuk
                                    ? OutputSuratmasuk(
                                        isApproved: status == 'disetujui',
                                        catatan: surat['catatan'] ?? '-',
                                        tujuan: surat['tujuan'] ?? '-',
                                        instruksi: surat['instruksi'] ?? '-',
                                        koordinasi: surat['koordinasi'] ?? '-',
                                        diteruskanKe:
                                            surat['diteruskanKe'] ?? '-',
                                      )
                                    : OutputSuratkeluar(
                                        catatan: surat['catatan'] ?? '-',
                                      ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── LAYER 2: NAVBAR MENGAMBANG DI ATAS LIST ───────────────────────
          // ColoredBox di bawah CustomNavbar menutup area padding bottom
          // (15px transparan dari CustomNavbar) supaya card tidak tembus keluar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomNavbar(
                  role: widget.role,
                  currentIndex: 0,
                  onTap: (index) {
                    handleNavbarTap(
                      context,
                      index,
                      widget.role,
                      widget.nama,
                      widget.email,
                      widget.jabatan,
                    );
                  },
                ),

                // Penutup solid di bawah navbar
                // Mencegah card tembus keluar dari sisi bawah navbar
                ColoredBox(
                  color: AppColors.bg,
                  child: SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// STAT CARD WIDGET
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
                Text(label, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProcessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        final w = MediaQuery.of(context).size.width;

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: w * 0.75,
              padding: EdgeInsets.symmetric(
                vertical: w * 0.08,
                horizontal: w * 0.06,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0F6),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(w * 0.03),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A4A4A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: w * 0.06,
                    ),
                  ),
                  SizedBox(height: w * 0.05),
                  Text(
                    "Surat Dalam Proses",
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: w * 0.025),
                  Text(
                    "Surat masih dalam\nproses pengajuan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: w * 0.032,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}