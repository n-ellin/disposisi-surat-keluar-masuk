import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';

import 'package:ta_mobile_disposisi_surat/core/helpers/navigation_helper.dart';

import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/notification_page.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/process_dialog.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';

import 'package:ta_mobile_disposisi_surat/features/kepsek/pages/disposisi_suratmasuk.dart';
import 'package:ta_mobile_disposisi_surat/features/kepsek/pages/menu_kepsek_page.dart';
import 'package:ta_mobile_disposisi_surat/features/kepsek/pages/pengajuan_suratkeluar.dart';

import 'package:ta_mobile_disposisi_surat/features/tata_usaha/pages/hasil_disposisi_surat_masuk_page.dart';
import 'package:ta_mobile_disposisi_surat/features/tata_usaha/pages/hasil_pengajuan_surat_keluar_page.dart';
import 'package:ta_mobile_disposisi_surat/features/tata_usaha/pages/menuTU.dart';

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

  // =========================
  // NOTIFICATION
  // =========================

  void _initNotifications() {
    switch (widget.role) {
      case Role.tu:
        notifications = [
          {
            "title": "Surat Masuk Ditolak",
            "desc":
                "Surat masuk telah ditolak Kepala Sekolah. Silakan periksa kembali.",
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
        break;

      case Role.kepsek:
        notifications = [
          {
            "title": "Pengajuan Surat Keluar",
            "desc": "Terdapat pengajuan surat keluar yang perlu ditinjau.",
            "color": Colors.orange,
            "createdAt": DateTime.now(),
            "isRead": false,
          },
        ];
        break;

      default:
        notifications = [
          {
            "title": "Surat Masuk",
            "desc": "Anda menerima surat masuk baru.",
            "color": Colors.green,
            "createdAt": DateTime.now(),
            "isRead": false,
          },
        ];
    }
  }

  int get notifCount => notifications.where((e) => e['isRead'] == false).length;

  // =========================
  // DATA
  // =========================

  List<Map<String, dynamic>> get allSurat => DummySurat.allSurat;

  List<Map<String, dynamic>> get suratTerbaru =>
      allSurat.reversed.take(5).toList();

  int get jumlahSuratMasuk =>
      allSurat.where((e) => e['jenisSurat'] == 'Surat Masuk').length;

  int get jumlahSuratKeluar =>
      allSurat.where((e) => e['jenisSurat'] == 'Surat Keluar').length;

  // =========================
  // RESPONSIVE
  // =========================

  double rf(
    BuildContext context,
    double size, {
    double min = 0.85,
    double max = 1.10, // ← diturunin dari 1.20
  }) {
    final width = MediaQuery.of(context).size.width;
    final scale = (width / 375).clamp(min, max);
    return size * scale;
  }

  // =========================
  // NOTIFICATION PAGE
  // =========================

  Future<void> openNotification() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            NotificationPage(role: widget.role, notifications: notifications),
      ),
    );

    setState(() {
      for (final notif in notifications) {
        notif['isRead'] = true;
      }
    });
  }

  // =========================
  // NAVIGATION
  // =========================

  void openDashboard(String jenisSurat) {
    if (widget.role == Role.tu) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TuDashboardPage(jenisSurat: jenisSurat),
        ),
      );
    } else if (widget.role == Role.kepsek) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KepsekDashboardPage(jenisSurat: jenisSurat),
        ),
      );
    }
  }

  void openDetail(Map<String, dynamic> surat) {
    final isMasuk = surat['jenisSurat'] == 'Surat Masuk';

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

    final status = surat['status']?.toString().toLowerCase() ?? '';

    if (status == 'diproses') {
      showProcessDialog(context);
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
                diteruskanKe: surat['diteruskanKe'] ?? '-',
              )
            : OutputSuratkeluar(
                catatan: surat['catatan'] ?? '-',
                isReadOnly: false,
                lampiranUrls: List<String>.from(surat['lampiran'] ?? []),
              ),
      ),
    );
  }

  // =========================
  // UI
  // =========================

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
          SizedBox(height: bottomPadding),
        ],
      ),

      // ← Center + ConstrainedBox dihapus
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // =========================
              // HEADER
              // =========================
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: rf(context, 20)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/images/logosmk.jpg",
                          width: rf(context, 42),
                          height: rf(context, 42),
                        ),

                        GestureDetector(
                          onTap: openNotification,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: rf(context, 28),
                                color: AppColors.bluePrimary,
                              ),

                              if (notifCount > 0)
                                Positioned(
                                  right: -4,
                                  top: -4,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE53935),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        notifCount > 9
                                            ? '9+'
                                            : notifCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              9, // ← pakai const, tidak perlu scale
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

                    SizedBox(height: rf(context, 18)),

                    Text(
                      "Disposisi Surat",
                      style: TextStyle(
                        fontSize: rf(context, 22), // ← hapus * ts
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: rf(context, 22)),

                    // =========================
                    // STAT CARD
                    // =========================
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            onTap: () => openDashboard('Surat Masuk'),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6DA8B4), Color(0xFF0F6E7A)],
                            ),
                            iconPath: "assets/icons/ic_inmail.svg",
                            jumlah: jumlahSuratMasuk.toString(),
                            label: "Masuk",
                          ),
                        ),

                        SizedBox(width: rf(context, 14)),

                        Expanded(
                          child: _StatCard(
                            onTap: () => openDashboard('Surat Keluar'),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD6A66B), Color(0xFFDA7B17)],
                            ),
                            iconPath: "assets/icons/ic_outmail.svg",
                            jumlah: jumlahSuratKeluar.toString(),
                            label: "Keluar",
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: rf(context, 26)),

                    Text(
                      "Surat Terbaru",
                      style: TextStyle(
                        fontSize: rf(context, 18), // ← hapus * ts
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: rf(context, 14)),
                  ],
                ),
              ),

              // =========================
              // LIST
              // =========================
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final surat = suratTerbaru[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: rf(context, 1)),
                    child: SuratCard(
                      jenisSurat: surat['jenisSurat'] ?? '',
                      tanggal: surat['tanggal'] ?? '-',
                      data: Map<String, String>.from(surat['data'] ?? {}),
                      role: widget.role == Role.kepsek
                          ? CardRole.kepsek
                          : CardRole.tu,
                      type: CardType.home,
                      status: widget.role == Role.kepsek
                          ? null
                          : surat['status'],
                      onDetail: () => openDetail(surat),
                    ),
                  );
                }, childCount: suratTerbaru.length),
              ),

              SliverToBoxAdapter(child: SizedBox(height: rf(context, 20))),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================
// STAT CARD
// ======================================

class _StatCard extends StatelessWidget {
  final VoidCallback onTap;
  final LinearGradient gradient;
  final String iconPath;
  final String jumlah;
  final String label;

  const _StatCard({
    required this.onTap,
    required this.gradient,
    required this.iconPath,
    required this.jumlah,
    required this.label,
  });

  double rf(
    BuildContext context,
    double size, {
    double min = 0.85,
    double max = 1.10,
  }) {
    final width = MediaQuery.of(context).size.width;
    final scale = (width / 375).clamp(min, max);
    return size * scale;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: rf(context, 72)),

        padding: EdgeInsets.symmetric(
          horizontal: rf(context, 12),
          vertical: rf(context, 10),
        ),

        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(rf(context, 16)),
        ),

        child: Row(
          children: [
            CircleAvatar(
              radius: rf(context, 17),
              backgroundColor: Colors.white.withOpacity(0.25),

              child: SvgPicture.asset(
                iconPath,
                width: rf(context, 18),
                height: rf(context, 18),

                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),

            SizedBox(width: rf(context, 9)),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,

                    child: Text(
                      jumlah,
                      style: TextStyle(
                        fontSize: rf(context, 17),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                  ),

                  SizedBox(height: rf(context, 2)),

                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,

                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: rf(context, 12),
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
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
