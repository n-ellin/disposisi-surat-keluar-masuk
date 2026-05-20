import 'package:flutter/material.dart';

import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';
import 'package:ta_mobile_disposisi_surat/core/helpers/navigation_helper.dart';

import 'package:ta_mobile_disposisi_surat/features/users/pages/detail_surat_page.dart';

import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/notification_page.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/search_bar.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';

class MenuUser extends StatefulWidget {
  const MenuUser({super.key});

  @override
  State<MenuUser> createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  String searchQuery = '';

  late List<Map<String, dynamic>> notifications;

  @override
  void initState() {
    super.initState();

    notifications = List.from(notifUser);
  }

  /// ================= NOTIFICATION =================
  int get notifCount => notifications.where((n) => n['isRead'] == false).length;

  Future<void> _openNotification() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            NotificationPage(role: Role.users, notifications: notifications),
      ),
    );

    setState(() {
      for (var notif in notifications) {
        notif['isRead'] = true;
      }
    });
  }

  /// ================= DATA SURAT =================
  List<Map<String, dynamic>> get suratMasukList {
    return DummySurat.allSurat.where((surat) {
      return surat["jenisSurat"].toString().toLowerCase().trim() ==
          "surat masuk";
    }).toList();
  }

  /// ================= SEARCH FILTER =================
  List<Map<String, dynamic>> get filteredSurat {
    if (searchQuery.isEmpty) {
      return suratMasukList;
    }

    return suratMasukList.where((surat) {
      final query = searchQuery.toLowerCase();

      final jenis = surat["jenisSurat"].toString().toLowerCase();

      final tanggal = surat["tanggal"].toString().toLowerCase();

      final status = surat["status"].toString().toLowerCase();

      final dari = surat["data"]["Dari"].toString().toLowerCase();

      final perihal = surat["data"]["Perihal"].toString().toLowerCase();

      return jenis.contains(query) ||
          tanggal.contains(query) ||
          status.contains(query) ||
          dari.contains(query) ||
          perihal.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final w = size.width;
    final h = size.height;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    double rf(double size) {
      return (w * (size / 375)).clamp(size * 0.85, size * 1.2);
    }

    return Scaffold(
      backgroundColor: AppColors.bg,

      /// ================= NAVBAR =================
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: CustomNavbar(
              role: Role.users,
              currentIndex: 0,
              onTap: (index) {
                handleNavbarTap(
                  context,
                  index,
                  Role.users,
                  "User",
                  "user@gmail.com",
                  "User",
                );
              },
            ),
          ),

          ColoredBox(
            color: AppColors.bg,
            child: SizedBox(height: bottomPadding, width: double.infinity),
          ),
        ],
      ),

      /// ================= BODY =================
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

                  /// ================= HEADER =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/logosmk.jpg",
                        width: w * 0.1,
                        height: w * 0.1,
                        fit: BoxFit.cover,
                      ),

                      GestureDetector(
                        onTap: _openNotification,
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

                  SizedBox(height: h * 0.02),

                  /// ================= TITLE =================
                  Text(
                    "Disposisi Surat",
                    style: TextStyle(
                      fontSize: rf(22),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: h * 0.025),

                  /// ================= SEARCH =================
                  SearchBarInput(
                    hintText: 'Cari surat...',
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),

                  SizedBox(height: h * 0.012),

                  /// ================= LIST =================
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: h * 0.015),
                      itemCount: filteredSurat.length,
                      itemBuilder: (context, index) {
                        final surat = filteredSurat[index];

                        return Padding(
                          padding: EdgeInsets.only(bottom: h * 0.002),
                          child: SuratCard(
                            jenisSurat: surat["jenisSurat"].toString(),

                            tanggal: surat["tanggal"].toString(),

                            status: surat["status"]?.toString(),

                            role: CardRole.Users,

                            type: CardType.menu,

                            data: Map<String, String>.from(surat["data"]),

                            diteruskanKe: surat["diteruskanKe"]?.toString(),

                            onDetail: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailSuratUsers(surat: surat),
                                ),
                              );
                            },
                          ),
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
}
