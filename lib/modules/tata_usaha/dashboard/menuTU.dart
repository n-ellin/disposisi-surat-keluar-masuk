import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/widgets/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';

class TuDashboardPage extends StatefulWidget {
  const TuDashboardPage({super.key});

  @override
  State<TuDashboardPage> createState() => _TuDashboardPageState();
}

class _TuDashboardPageState extends State<TuDashboardPage> {
  int _currentIndex = 1;
  bool _isFabOpen = false;
  String _selectedFilter = 'semua';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      // ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Disposisi Surat',
          style: TextStyle(
            color: Colors.black,
            fontSize: w * 0.045,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.all(w * 0.02),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Image.asset(
              "assets/images/logosmk.jpg",
              width: w * 0.06,
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: w * 0.04),
            child: Icon(
              Icons.notifications,
              color: Colors.black,
              size: w * 0.06,
            ),
          ),
        ],
      ),

      // ================= BODY =================
      body: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          children: [
            // 🔍 SEARCH BAR
            TextField(
              style: TextStyle(fontSize: w * 0.04),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, size: w * 0.055),
                hintText: 'Cari surat...',
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.symmetric(
                  vertical: h * 0.018,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(w * 0.06),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: h * 0.015),

            // 🏷 FILTER CHIP (ANTI OVERFLOW)
            Wrap(
              spacing: w * 0.02,
              runSpacing: h * 0.01,
              children: ['semua', 'disetujui', 'menunggu', 'ditolak']
                  .map(
                    (e) => ChoiceChip(
                      label: Text(
                        e,
                        style: TextStyle(fontSize: w * 0.035),
                      ),
                      selected: _selectedFilter == e,
                      onSelected: (_) {
                        setState(() => _selectedFilter = e);
                      },
                    ),
                  )
                  .toList(),
            ),

            SizedBox(height: h * 0.02),

            // 📄 LIST SURAT
            Expanded(
              child: ListView(
                children: [
                  SuratCard(
                    jenisSurat: 'Surat Keluar',
                    tanggal: 'Senin, 12 Oktober 2025',
                    status: 'disetujui',
                    role: CardRole.tu,
                    data: const {
                      'Dari': '',
                      'Kode': '',
                      'Nomor Surat': '',
                      'Perihal': '',
                    },
                    onDelete: () {},
                    onDetail: () {},
                  ),
                  SizedBox(height: h * 0.015),
                  SuratCard(
                    jenisSurat: 'Surat Masuk',
                    tanggal: 'Senin, 12 Oktober 2025',
                    status: 'ditolak',
                    role: CardRole.tu,
                    data: const {
                      'Nomor Surat': '',
                      'Asal': '',
                      'Perihal': '',
                      'Tanggal Surat': '',
                    },
                    onDelete: () {},
                    onDetail: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ================= FAB =================
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add, size: w * 0.07),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ================= NAVBAR =================
      bottomNavigationBar: CustomNavbar(
        role: NavbarRole.tu,
        currentIndex: _currentIndex,
        isFabOpen: _isFabOpen,
        onTap: (i) {
          setState(() => _currentIndex = i);
        },
      ),
    );
  }
}
