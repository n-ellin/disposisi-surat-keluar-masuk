import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';

import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';

import 'package:ta_mobile_disposisi_surat/shared/widgets/notif.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/navigation_helper.dart';

import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/menuTU.dart';
import 'package:ta_mobile_disposisi_surat/modules/kepsek/menuukepsek.dart';

import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/detail_surat/output_suratmasuk.dart';
import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/detail_surat/output_suratkeluar.dart';

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

  /// DUMMY NOTIFICATION
  late List<Map<String, dynamic>> notifications;

  @override
  void initState() {
    super.initState();

    notifications = [
      {
        "title": "Surat Masuk Diterima",
        "desc": "Surat masuk diterima kepala sekolah.",
        "color": Colors.green,
        "createdAt": DateTime.now(),
        "isRead": false,
      },
      {
        "title": "Surat Keluar Ditolak",
        "desc": "Silakan revisi surat keluar.",
        "color": Colors.red,
        "createdAt": DateTime.now(),
        "isRead": false,
      },
      {
        "title": "Permintaan Persetujuan Akun",
        "desc": "Akun Budi menunggu verifikasi.",
        "color": Colors.blue,
        "createdAt": DateTime.now().subtract(
          const Duration(days: 1),
        ),
        "isRead": true,
      },
      {
        "title": "Surat Masuk Dikonfirmasi",
        "desc": "Penerima sudah mengonfirmasi surat.",
        "color": Colors.orange,
        "createdAt": DateTime.now().subtract(
          const Duration(days: 2),
        ),
        "isRead": true,
      },
    ];
  }

  /// UNREAD COUNT
  int get notifCount =>
      notifications.where((n) => n['isRead'] == false).length;

  List<Map<String, dynamic>> get _allSurat => DummySurat.allSurat;

  List<Map<String, dynamic>> get _suratTerbaru =>
      DummySurat.allSurat.reversed.take(5).toList();

  int get jumlahSuratMasuk =>
      _allSurat.where((s) => s['jenisSurat'] == 'Surat Masuk').length;

  int get jumlahSuratKeluar =>
      _allSurat.where((s) => s['jenisSurat'] == 'Surat Keluar').length;

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
                      onTap: () async {

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NotificationPage(
                              role: widget.role,
                              notifications: notifications,
                            ),
                          ),
                        );

                        /// SET ALL READ
                        setState(() {
                          for (var notif in notifications) {
                            notif['isRead'] = true;
                          }
                        });
                      },

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

                SizedBox(height: h * 0.04),

                /// HEADER SURAT TERBARU
                const Text(
                  "Surat Terbaru",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: h * 0.015),

                /// LIST SURAT
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                      role: CardRole.tu,
                      type: CardType.home,
                      status: widget.role == Role.kepsek
                          ? null
                          : surat['status'],

                      onDetail: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => isMasuk
                                ? OutputSuratmasuk(
                                    isApproved:
                                        surat['status'] == 'disetujui',
                                    catatan:
                                        surat['catatan'] ?? '-',
                                    tujuan:
                                        surat['tujuan'] ?? '-',
                                    instruksi:
                                        surat['instruksi'] ?? '-',
                                    koordinasi:
                                        surat['koordinasi'] ?? '-',
                                    diteruskanKe:
                                        surat['diteruskanKe'] ?? '-',
                                    isReadOnly: true,
                                  )
                                : OutputSuratkeluar(
                                    catatan:
                                        surat['catatan'] ?? '-',
                                  ),
                          ),
                        );
                      },
                    );
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
    );
  }

  /// STAT CARD
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

                Text(
                  label,
                  style: const TextStyle(
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