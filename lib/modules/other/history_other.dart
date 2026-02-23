import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/shared/auth/pages/notif.dart';
import 'package:ta_mobile_disposisi_surat/shared/models/navbar_role.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';

class HistoryOther extends StatefulWidget {
  const HistoryOther({super.key});

  @override
  State<HistoryOther> createState() => _HistoryOtherState();
}

class _HistoryOtherState extends State<HistoryOther> {
  final List<Map<String, dynamic>> suratMasukList = [
    {
      "jenisSurat": "Surat Masuk",
      "tanggal": "12 Okt 2026",
      "status": "menunggu",
      "data": {"Dari": "Tata Usaha", "Perihal": "Undangan Rapat"},
    },
    {
      "jenisSurat": "Surat Keluar",
      "tanggal": "13 Okt 2026",
      "status": "disetujui",
      "data": {"Dari": "Kepala Sekolah", "Perihal": "Surat Tugas"},
    },
  ];

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
        title: const Text(
          'Riwayat',
          style: TextStyle(
            color: AppColors.bluePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 26),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const NotificationPage(role: NavbarRole.other),
                ),
              );
            },
          ),
        ],
      ),

      /// ================= BODY =================
      body: Padding(
        padding: EdgeInsets.all(w * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SEARCH BAR
            TextField(
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

            /// LIST SURAT (no Detail button)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: h * 0.12),
                itemCount: suratMasukList.length,
                itemBuilder: (context, index) {
                  final surat = suratMasukList[index];
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
