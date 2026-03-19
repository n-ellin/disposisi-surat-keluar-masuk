import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/navbar_role.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/navigation_helper.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';

class HistoryKepsekPage extends StatefulWidget {
  const HistoryKepsekPage({super.key});

  @override
  State<HistoryKepsekPage> createState() => _HistoryKepsekPageState();
}

class _HistoryKepsekPageState extends State<HistoryKepsekPage> {
  String _searchQuery = '';
  String _jenisFilter = 'semua';

  final List<Map<String, dynamic>> _historySurat = [
    {
      'jenisSurat': 'Surat Masuk',
      'tanggal': '12 Okt 2026',
      'data': {'Dari': 'Tata Usaha', 'Perihal': 'Permohonan Rapat SIKAP'},
    },
    {
      'jenisSurat': 'Surat Keluar',
      'tanggal': '12 Okt 2026',
      'data': {'Dari': 'Tata Usaha', 'Perihal': 'Permohonan Rapat SIKAP'},
    },
  ];

  List<Map<String, dynamic>> get _filteredSurat {
    return _historySurat.where((s) {
      final query = _searchQuery.toLowerCase();
      final jenis = s['jenisSurat'].toString().toLowerCase();
      final dari = s['data']['Dari'].toString().toLowerCase();
      final perihal = s['data']['Perihal'].toString().toLowerCase();

      final matchSearch =
          _searchQuery.isEmpty ||
          jenis.contains(query) ||
          dari.contains(query) ||
          perihal.contains(query);

      final matchJenis =
          _jenisFilter == 'semua' ||
          (_jenisFilter == 'masuk' && jenis.contains('masuk')) ||
          (_jenisFilter == 'keluar' && jenis.contains('keluar'));

      return matchSearch && matchJenis;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(w * 0.04),
          child: Column(
            children: [
              SizedBox(height: h * 0.02),

              /// TITLE
              Text(
                "Riwayat",
                style: TextStyle(
                  fontSize: w * 0.07,
                  fontWeight: FontWeight.bold,
                  color: AppColors.bluePrimary,
                ),
              ),

              SizedBox(height: h * 0.02),

              /// SEARCH
              TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Cari surat...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: h * 0.015),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: h * 0.02),

              /// FILTER
              Row(
                children: [
                  Expanded(child: _filterButton("Semua", "semua")),

                  const SizedBox(width: 10),

                  Expanded(child: _filterButton("Surat Masuk", "masuk")),

                  const SizedBox(width: 10),

                  Expanded(child: _filterButton("Surat Keluar", "keluar")),
                ],
              ),

              SizedBox(height: h * 0.02),

              /// LIST
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredSurat.length,
                  itemBuilder: (context, index) {
                    final surat = _filteredSurat[index];

                    return Padding(
                      padding: EdgeInsets.only(bottom: h * 0.02),
                      child: SuratCard(
                        jenisSurat: surat['jenisSurat'],
                        tanggal: surat['tanggal'],
                        role: CardRole.kepsek,
                        data: Map<String, String>.from(surat['data']),
                        showAction: false,
                        onDetail: () {},
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomNavbar(
        role: NavbarRole.kepsek,
        currentIndex: 1,
        onTap: (index) {
          handleNavbarTap(context, index, NavbarRole.kepsek);
        },
      ),
    );
  }

  Widget _filterButton(String text, String value) {
    final isActive = _jenisFilter == value;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _jenisFilter = value;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? AppColors.bluePrimary : Colors.white,
        foregroundColor: isActive ? Colors.white : AppColors.bluePrimary,
        elevation: isActive ? 2 : 0,
        side: BorderSide(color: AppColors.bluePrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Text(text),
    );
  }
}
