import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/models/navbar_role.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';

class KepsekDashboardPage extends StatefulWidget {
  final String jenisSurat;

  const KepsekDashboardPage({super.key, required this.jenisSurat});

  @override
  State<KepsekDashboardPage> createState() => _KepsekDashboardPageState();
}

class _KepsekDashboardPageState extends State<KepsekDashboardPage> {
  int _currentIndex = 0;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _allSurat = [
    {
      'jenisSurat': 'Surat Masuk',
      'tanggal': '12 Okt 2026',
      'status': 'menunggu',
      'data': {'Dari': 'Tata Usaha', 'Perihal': 'Permohonan Rapat SIKAP'},
    },
    {
      'jenisSurat': 'Surat Keluar',
      'tanggal': '12 Okt 2026',
      'status': 'disetujui',
      'data': {'Dari': 'Tata Usaha', 'Perihal': 'Permohonan Rapat SIKAP'},
    },
  ];

  List<Map<String, dynamic>> get _filteredSurat {
    return _allSurat
        .where((s) => s['jenisSurat'] == widget.jenisSurat)
        .where((s) {
      if (_searchQuery.isEmpty) return true;

      final query = _searchQuery.toLowerCase();
      final dari = (s['data']?['Dari'] ?? '').toString().toLowerCase();
      final perihal = (s['data']?['Perihal'] ?? '').toString().toLowerCase();

      return dari.contains(query) || perihal.contains(query);
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: w * 0.04),
            child: SizedBox(
              width: w * 0.1,
              height: w * 0.1,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logosmk.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),

      /// ================= BODY =================
      body: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TITLE
            Text(
              'Disposisi Surat',
              style: TextStyle(
                fontSize: (w * 0.055).clamp(18.0, 24.0),
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: h * 0.02),

            /// SEARCH
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Cari surat...",
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    EdgeInsets.symmetric(vertical: h * 0.018),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(w * 0.06),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: h * 0.02),

            /// LIST SURAT
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: h * 0.12),
                itemCount: _filteredSurat.length,
                itemBuilder: (context, index) {
                  final surat = _filteredSurat[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: h * 0.015),
                    child: SuratCard(
                      jenisSurat: surat['jenisSurat'],
                      tanggal: surat['tanggal'],
                      status: surat['status'],
                      data: Map<String, String>.from(surat['data']),
                      role: CardRole.kepsek,
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
