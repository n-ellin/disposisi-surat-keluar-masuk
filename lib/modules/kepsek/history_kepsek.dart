import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';

class HistoryKepsek extends StatefulWidget {
  const HistoryKepsek({super.key});

  @override
  State<HistoryKepsek> createState() => _HistoryKepsekState();
}

class _HistoryKepsekState extends State<HistoryKepsek> {
  String _searchQuery = '';
  String _selectedFilter = 'semua'; // semua | Surat Masuk | Surat Keluar

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
    var result = _allSurat.where((s) {
      if (_selectedFilter == 'semua') return true;
      return (s['jenisSurat'] ?? '') == _selectedFilter;
    }).toList();

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((s) {
        final dari = (s['data']?['Dari'] ?? '').toString().toLowerCase();
        final perihal = (s['data']?['Perihal'] ?? '').toString().toLowerCase();
        return dari.contains(query) || perihal.contains(query);
      }).toList();
    }

    return result;
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
        title: const Text(
          'Riwayat',
          style: TextStyle(
            color: AppColors.bluePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      /// ================= BODY =================
      body: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SEARCH
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Cari surat...",
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.symmetric(vertical: h * 0.018),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(w * 0.06),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: h * 0.02),

            /// FILTER: Semua | Surat Masuk | Surat Keluar (blue primary bg, white text)
            Row(
              children: [
                _filterChip('Semua', 'semua', w, h),
                SizedBox(width: w * 0.02),
                _filterChip('Surat Masuk', 'Surat Masuk', w, h),
                SizedBox(width: w * 0.02),
                _filterChip('Surat Keluar', 'Surat Keluar', w, h),
              ],
            ),

            SizedBox(height: h * 0.02),

            /// UNIFIED LIST SURAT
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

  Widget _filterChip(String label, String value, double w, double h) {
    final isSelected = _selectedFilter == value;
    return Material(
      color: isSelected ? AppColors.bluePrimary : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => setState(() => _selectedFilter = value),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.012),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.w600,
              fontSize: w * 0.032,
            ),
          ),
        ),
      ),
    );
  }
}
