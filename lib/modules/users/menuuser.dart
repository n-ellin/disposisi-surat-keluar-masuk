import 'package:flutter/material.dart';

import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';

import 'package:ta_mobile_disposisi_surat/modules/users/detailsurat.dart';

import 'package:ta_mobile_disposisi_surat/shared/widgets/notif.dart';

import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';

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

    notifications = [

      {
        "title": "Surat Masuk Baru",
        "desc": "Anda menerima surat masuk baru.",
        "color": Colors.blue,
        "createdAt": DateTime.now(),
        "isRead": false,
      },

      {
        "title": "Disposisi Diterima",
        "desc": "Disposisi surat telah diterima.",
        "color": Colors.green,
        "createdAt": DateTime.now(),
        "isRead": false,
      },

      {
        "title": "Surat Dikonfirmasi",
        "desc": "Surat telah dikonfirmasi penerima.",
        "color": Colors.orange,
        "createdAt": DateTime.now().subtract(
          const Duration(days: 1),
        ),
        "isRead": true,
      },
    ];
  }

  /// ================= UNREAD COUNT =================
  int get notifCount =>
      notifications.where((n) => n['isRead'] == false).length;

  /// ================= SURAT MASUK =================
  List<Map<String, dynamic>> get suratMasukList =>
      DummySurat.allSurat.where((surat) {

        return surat["jenisSurat"]
                .toString()
                .toLowerCase()
                .trim() ==
            "surat masuk";

      }).toList();

  /// ================= FILTER SEARCH =================
  List<Map<String, dynamic>> get filteredSurat {

    if (searchQuery.isEmpty) {
      return suratMasukList;
    }

    return suratMasukList.where((surat) {

      final query = searchQuery.toLowerCase();

      final jenis =
          surat["jenisSurat"].toString().toLowerCase();

      final tanggal =
          surat["tanggal"].toString().toLowerCase();

      final status =
          surat["status"].toString().toLowerCase();

      final dari =
          surat["data"]["Dari"]
              .toString()
              .toLowerCase();

      final perihal =
          surat["data"]["Perihal"]
              .toString()
              .toLowerCase();

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
      backgroundColor: Colors.white,

      /// ================= APPBAR =================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
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
            TextField(
              onChanged: (value) {

                setState(() {
                  searchQuery = value;
                });

              },

              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),

                hintText: "Cari surat...",

                filled: true,
                fillColor: Colors.grey.shade100,

                contentPadding: EdgeInsets.symmetric(
                  vertical: h * 0.018,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: h * 0.025),

            /// LIST SURAT
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                  bottom: h * 0.12,
                ),

                itemCount: filteredSurat.length,

                itemBuilder: (context, index) {

                  final surat = filteredSurat[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: h * 0.015,
                    ),

                    child: SuratCard(
                      jenisSurat:
                          surat["jenisSurat"].toString(),

                      tanggal:
                          surat["tanggal"].toString(),

                      status:
                          surat["status"]?.toString(),

                      role: CardRole.other,
                      type: CardType.menu,

                      data: Map<String, String>.from(
                        surat["data"],
                      ),

                      onDetail: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetailSuratUsers(
                                  surat: surat,
                                ),
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
    );
  }
}