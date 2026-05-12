import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';
import 'package:ta_mobile_disposisi_surat/shared/auth/sharepage/notif.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import '../../shared/widgets/surat_card.dart';

class MenuOther extends StatefulWidget {
  const MenuOther({super.key});

  @override
  State<MenuOther> createState() => _MenuOtherState();
}

class _MenuOtherState extends State<MenuOther> {
  int selectedIndex = 0;
  String searchQuery = '';

  /// ambil semua data dari dummy pusat
  List<Map<String, dynamic>> get suratMasukList => DummySurat.allSurat;

  /// filter search
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
      backgroundColor: Colors.white,

      /// ================= APPBAR =================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,

        /// LOGO KIRI
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

        /// NOTIF KANAN
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 26),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const NotificationPage(role: Role.other),
                ),
              );
            },
          ),

          SizedBox(width: w * 0.02),
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

            /// SEARCH BAR
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
                contentPadding: EdgeInsets.symmetric(vertical: h * 0.018),
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
                padding: EdgeInsets.only(bottom: h * 0.12),
                itemCount: filteredSurat.length,
                itemBuilder: (context, index) {
                  final surat = filteredSurat[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: h * 0.015),
                    child: SuratCard(
                      jenisSurat: surat["jenisSurat"],
                      tanggal: surat["tanggal"],
                      status: surat["status"],
                      role: CardRole.other,
                      data: Map<String, String>.from(surat["data"]),
                      onDetail: () {},
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
