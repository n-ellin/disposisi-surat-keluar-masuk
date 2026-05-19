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
    final size = MediaQuery.of(context).size;

    final w = size.width;
    final h = size.height;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    double responsiveText(double size) {
      return (w * (size / 375)).clamp(size * 0.85, size * 1.25);
    }

    return Scaffold(
      backgroundColor: AppColors.bg,

      /// NAVBAR
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
            child: SizedBox(
              height: bottomPadding,
              width: double.infinity,
            ),
          ),
        ],
      ),

      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
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

                            if (notifCount > 0)
                              Positioned(
                                right: -(w * 0.008),
                                top: -(w * 0.008),
                                child: Container(
                                  padding: EdgeInsets.all(w * 0.008),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE53935),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: w * 0.045,
                                    minHeight: w * 0.045,
                                  ),
                                  child: Center(
                                    child: Text(
                                      notifCount > 9
                                          ? '9+'
                                          : notifCount.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: responsiveText(9),
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

                  SizedBox(height: h * 0.02),

                  /// TITLE
                  Text(
                    "Disposisi Surat",
                    style: TextStyle(
                      fontSize: responsiveText(22),
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
                            w: w,
                            responsiveText: responsiveText,
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
                            w: w,
                            responsiveText: responsiveText,
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

                  SizedBox(height: h * 0.03),

                  /// HEADER LIST
                  Text(
                    "Surat Terbaru",
                    style: TextStyle(
                      fontSize: responsiveText(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: h * 0.015),

                  /// LIST
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: h * 0.02),
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

                            final status =
                                surat['status']
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
                                        tujuan:
                                            surat['tujuan'] ?? '-',
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required double w,
    required double Function(double) responsiveText,
    required LinearGradient gradient,
    required String iconPath,
    required String jumlah,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(w * 0.05),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: w * 0.055,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: SvgPicture.asset(
              iconPath,
              width: w * 0.06,
              height: w * 0.06,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),

          SizedBox(width: w * 0.03),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jumlah,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: responsiveText(20),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: responsiveText(14),
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

  void _showProcessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFFF3F0F6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 80),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4A4A4A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Surat Dalam Proses",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Surat masih dalam proses pengajuan.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
