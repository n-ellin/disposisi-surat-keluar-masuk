import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';

import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/process_dialog.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/notification_page.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';

import 'package:ta_mobile_disposisi_surat/core/helpers/navigation_helper.dart';

import 'package:ta_mobile_disposisi_surat/features/tata_usaha/pages/menuTU.dart';
import 'package:ta_mobile_disposisi_surat/features/tata_usaha/pages/hasil_disposisi_surat_masuk_page.dart';
import 'package:ta_mobile_disposisi_surat/features/tata_usaha/pages/hasil_pengajuan_surat_keluar_page.dart';

import 'package:ta_mobile_disposisi_surat/features/kepsek/pages/disposisi_suratmasuk.dart';
import 'package:ta_mobile_disposisi_surat/features/kepsek/pages/pengajuan_suratkeluar.dart';
import 'package:ta_mobile_disposisi_surat/features/kepsek/pages/menu_kepsek_page.dart';

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
      ];
    } else {
      notifications = [
        {
          "title": "Pemberitahuan Surat Masuk",
          "desc":
              "Anda menerima surat masuk baru. Silakan periksa detail surat.",
          "color": Colors.green,
          "createdAt": DateTime.now(),
          "isRead": false,
        },
      ];
    }
  }

  int get notifCount =>
      notifications.where((n) => n['isRead'] == false).length;

  List<Map<String, dynamic>> get _allSurat => DummySurat.allSurat;
  List<Map<String, dynamic>> get _suratTerbaru =>
      DummySurat.allSurat.reversed.take(5).toList();

  int get jumlahSuratMasuk =>
      _allSurat.where((s) => s['jenisSurat'] == 'Surat Masuk').length;

  int get jumlahSuratKeluar =>
      _allSurat.where((s) => s['jenisSurat'] == 'Surat Keluar').length;

  Future<void> _openNotifikasi() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationPage(
          role: widget.role,
          notifications: notifications,
        ),
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.bg,

      bottomNavigationBar: Column(
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
          ColoredBox(
            color: AppColors.bg,
            child: SizedBox(height: bottomPadding, width: double.infinity),
          ),
        ],
      ),

      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            // LayoutBuilder di dalam ConstrainedBox:
            // w yang dipakai adalah lebar KONTEN setelah di-constrain,
            // bukan lebar layar penuh — ini yang mencegah overflow & posisi mepet kiri
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth.clamp(0.0, 430.0);
                double rf(double s) {
                  final scale = (w / 375).clamp(0.88, 1.10);
                  return s * scale;
                }

                return Padding(
                  // Fixed horizontal padding — tidak ikut scale DPI
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: rf(24)),

                      // ── HEADER ────────────────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/images/logosmk.jpg",
                            width: rf(40),
                            height: rf(40),
                          ),

                          GestureDetector(
                            onTap: _openNotifikasi,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  size: rf(28),
                                  color: AppColors.bluePrimary,
                                ),

                                if (notifCount > 0)
                                  Positioned(
                                    right: -rf(4),
                                    top: -rf(4),
                                    child: Container(
                                      padding: EdgeInsets.all(rf(3)),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE53935),
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: rf(16),
                                        minHeight: rf(16),
                                      ),
                                      child: Center(
                                        child: Text(
                                          notifCount > 9
                                              ? '9+'
                                              : notifCount.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: rf(9),
                                            fontWeight: FontWeight.bold,
                                            height: 1,
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

                      SizedBox(height: rf(18)),

                      // ── TITLE ─────────────────────────────────────────────
                      Text(
                        "Disposisi Surat",
                        style: TextStyle(
                          fontSize: rf(22),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: rf(20)),

                      // ── STAT CARDS ────────────────────────────────────────
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
                                rf: rf,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6DA8B4),
                                    Color(0xFF0F6E7A),
                                  ],
                                ),
                                iconPath: "assets/icons/ic_inmail.svg",
                                jumlah: jumlahSuratMasuk.toString(),
                                label: "Masuk",
                              ),
                            ),
                          ),

                          SizedBox(width: rf(14)),

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
                                rf: rf,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFD6A66B),
                                    Color(0xFFDA7B17),
                                  ],
                                ),
                                iconPath: "assets/icons/ic_outmail.svg",
                                jumlah: jumlahSuratKeluar.toString(),
                                label: "Keluar",
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: rf(24)),

                      // ── SURAT TERBARU ─────────────────────────────────────
                      Text(
                        "Surat Terbaru",
                        style: TextStyle(
                          fontSize: rf(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: rf(12)),

                      // ── LIST ──────────────────────────────────────────────
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: rf(16)),
                          itemCount: _suratTerbaru.length,
                          itemBuilder: (context, index) {
                            final surat = _suratTerbaru[index];
                            final isMasuk =
                                surat['jenisSurat'] == 'Surat Masuk';

                            return SuratCard(
                              jenisSurat: surat['jenisSurat'] ?? '',
                              tanggal: surat['tanggal'] ?? '-',
                              data: Map<String, String>.from(
                                surat['data'] ?? {},
                              ),
                              role: widget.role == Role.kepsek
                                  ? CardRole.kepsek
                                  : CardRole.tu,
                              type: CardType.home,
                              status: widget.role == Role.kepsek
                                  ? null
                                  : surat['status'],
                              onDetail: () {
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

                                final status = surat['status']
                                        ?.toString()
                                        .toLowerCase() ??
                                    '';

                                if (status == 'diproses') {
                                  showProcessDialog(context);
                                  return;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => isMasuk
                                        ? OutputSuratmasuk(
                                            isApproved:
                                                status == 'disetujui',
                                            catatan:
                                                surat['catatan'] ?? '-',
                                            tujuan: surat['tujuan'] ?? '-',
                                            instruksi:
                                                surat['instruksi'] ?? '-',
                                            koordinasi:
                                                surat['koordinasi'] ?? '-',
                                            diteruskanKe:
                                                surat['diteruskanKe'] ??
                                                    '-',
                                          )
                                        : OutputSuratkeluar(
                                            catatan:
                                                surat['catatan'] ?? '-',
                                            isReadOnly: false,
                                            lampiranUrls:
                                                List<String>.from(
                                              surat['lampiran'] ?? [],
                                            ),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required double Function(double) rf,
    required LinearGradient gradient,
    required String iconPath,
    required String jumlah,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.all(rf(14)),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(rf(18)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: rf(20),
            backgroundColor: Colors.white.withOpacity(0.3),
            child: SvgPicture.asset(
              iconPath,
              width: rf(22),
              height: rf(22),
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),

          SizedBox(width: rf(10)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jumlah,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: rf(20),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: rf(13),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}