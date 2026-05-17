import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/search_bar.dart';

import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';

import 'package:ta_mobile_disposisi_surat/features/users/pages/detail_surat_page.dart';

import 'package:ta_mobile_disposisi_surat/shared/widgets/notification_page.dart';

import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';

import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/core/helpers/navigation_helper.dart';

class MenuUser extends StatefulWidget {
  const MenuUser({super.key});

  @override
  State<MenuUser> createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  int selectedIndex = 0;

  String searchQuery = '';

  /// ================= DUMMY NOTIFICATION =================

  late List<Map<String, dynamic>> notifications;

  @override
  void initState() {
    super.initState();

    notifications = List.from(notifUser);
  }

  /// ================= UNREAD COUNT =================
  int get notifCount => notifications.where((n) => n['isRead'] == false).length;

  /// ================= SURAT MASUK =================
  List<Map<String, dynamic>> get suratMasukList => DummySurat.allSurat.where((
    surat,
  ) {
    return surat["jenisSurat"].toString().toLowerCase().trim() == "surat masuk";
  }).toList();

  /// ================= FILTER SEARCH =================
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

    return Scaffold(
      backgroundColor: AppColors.bg,

      /// ================= APPBAR =================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColors.bg,
        surfaceTintColor: Colors.transparent,

        /// LOGO
        leadingWidth: 80,

        leading: Padding(
          padding: EdgeInsets.only(left: w * 0.04),

          child: Center(
            child: SizedBox(
              width: w * 0.1,
              height: w * 0.1,

              child: ClipOval(
                child: Image.asset(
                  "assets/images/logosmk.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),

        /// NOTIFICATION
        actions: [
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationPage(
                    role: Role.users,
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
                const Padding(
                  padding: EdgeInsets.all(8.0),

                  child: Icon(
                    Icons.notifications_none,
                    size: 28,
                    color: Colors.black87,
                  ),
                ),

                /// BADGE
                if (notifCount > 0)
                  Positioned(
                    right: 2,
                    top: 2,

                    child: Container(
                      padding: const EdgeInsets.all(4),

                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),

                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),

                      child: Center(
                        child: Text(
                          notifCount.toString(),

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(width: w * 0.03),
        ],
      ),

      /// ================= BODY =================
      body: Padding(
        padding: EdgeInsets.all(w * 0.05),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// TITLE
            Text(
              "Disposisi Surat",

              style: TextStyle(
                fontSize: (w * 0.06).clamp(20.0, 26.0),
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: h * 0.02),

            /// SEARCH
            SearchBarInput(
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            SizedBox(height: h * 0.025),

            /// LIST SURAT
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: h * 0.12),

                itemCount: filteredSurat.length,

                itemBuilder: (context, index) {
                  final surat = filteredSurat[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: h * 0.015),

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
                            builder: (_) => DetailSuratUsers(surat: surat),
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

      bottomNavigationBar: Container(
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
    );
  }
}
