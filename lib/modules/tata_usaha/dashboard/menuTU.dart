import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';

class TuDashboardPage extends StatefulWidget {
  const TuDashboardPage({super.key});

  @override
  State<TuDashboardPage> createState() => _TuDashboardPageState();
}

class _TuDashboardPageState extends State<TuDashboardPage> {
  int _currentIndex = 0;
  String _selectedFilter = 'semua';
  String _searchQuery = '';


  final List<Map<String, dynamic>> _allSurat = [
    {
      'jenisSurat': 'Surat Keluar',
      'tanggal': 'Senin, 12 Oktober 2025',
      'status': 'disetujui',
      'data': {'Dari': 'Tata Usaha', 'Perihal': 'Permohonan Izin Kegiatan'},
    },
    {
      'jenisSurat': 'Surat Masuk',
      'tanggal': 'Senin, 12 Oktober 2025',
      'status': 'ditolak',
      'data': {
        'Dari': 'Dinas Pendidikan',
        'Perihal': 'Undangan Rapat Koordinasi',
      },
    },
    {
      'jenisSurat': 'Surat Masuk',
      'tanggal': 'Senin, 12 Oktober 2025',
      'status': 'menunggu',
      'data': {
        'Dari': 'Dinas Pendidikan',
        'Perihal': 'Undangan Rapat Koordinasi',
      },
    },
  ];

  List<Map<String, dynamic>> get _filteredSurat {
    List<Map<String, dynamic>> result = _allSurat;

    if (_selectedFilter != 'semua') {
      result = result
          .where(
            (s) =>
                (s['status'] ?? '').toString().toLowerCase() ==
                _selectedFilter.toLowerCase(),
          )
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result.where((s) {
        final query = _searchQuery.toLowerCase();

        final jenisSurat = (s['jenisSurat'] ?? '').toString().toLowerCase();
        final tanggal = (s['tanggal'] ?? '').toString().toLowerCase();
        final status = (s['status'] ?? '').toString().toLowerCase();
        final dari = (s['data']?['Dari'] ?? '').toString().toLowerCase();
        final perihal = (s['data']?['Perihal'] ?? '').toString().toLowerCase();

        return jenisSurat.contains(query) ||
            tanggal.contains(query) ||
            status.contains(query) ||
            dari.contains(query) ||
            perihal.contains(query);
      }).toList();
    }

    return result;
  }

  final Map<String, Color> filterColors = {
    'semua': const Color(0xFF6F7A83),
    'menunggu': const Color(0xFFC59B36),
    'disetujui': const Color(0xFF3F9142),
    'ditolak': const Color(0xFFB63A3A),
  };

  String _label(String key) {
    switch (key) {
      case 'semua':
        return 'Semua';
      case 'menunggu':
        return 'Menunggu';
      case 'disetujui':
        return 'Disetujui';
      case 'ditolak':
        return 'Ditolak';
      default:
        return key;
    }
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
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,

        leadingWidth: w * 0.16, // ⬅️ kasih ruang lebih biar ga gepeng

        leading: Padding(
          padding: EdgeInsets.only(left: w * 0.04),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AspectRatio(
              aspectRatio: 1, // ⬅️ JAGA RASIO BULAT
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logosmk.jpg',
                  fit: BoxFit.cover, // isi lingkaran tanpa gepeng
                ),
              ),
            ),
          ),
        ),

        actions: [
          Padding(
            padding: EdgeInsets.only(right: w * 0.06),
            child: Icon(
              Icons.notifications,
              color: Colors.black,
              size: (w * 0.08).clamp(22.0, 28.0),
            ),
          ),
        ],
      ),

      /// ================= BODY =================
      body: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          children: [
            /// 🏷 TITLE
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Disposisi Surat',
                style: TextStyle(
                  fontSize: (w * 0.055).clamp(18.0, 24.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: h * 0.015),

            /// 🔍 SEARCH PERIHAL
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: TextStyle(fontSize: w * 0.04),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, size: w * 0.055),
                hintText: 'Cari Surat...',
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.symmetric(vertical: h * 0.018),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(w * 0.06),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: h * 0.015),

            /// 🏷 FILTER BUTTON (SHADOW HALUS SAAT AKTIF)
            Row(
              children: filterColors.keys.map((key) {
                final isSelected = _selectedFilter == key;
                final color = filterColors[key]!;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.01),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.18),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: ChoiceChip(
                        label: Center(
                          child: Text(
                            _label(key),
                            style: TextStyle(
                              color: isSelected ? Colors.white : color,
                              fontWeight: FontWeight.w600,
                              fontSize: w * 0.028,
                            ),
                          ),
                        ),
                        selected: isSelected,
                        showCheckmark: false,
                        selectedColor: color, // warna solid saat aktif
                        backgroundColor: Colors.white, // putih saat nonaktif
                        side: BorderSide(color: color, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onSelected: (_) =>
                            setState(() => _selectedFilter = key),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: h * 0.02),

            /// 📄 LIST SURAT
            Expanded(
              child: ListView.builder(
                itemCount: _filteredSurat.length,
                itemBuilder: (context, index) {
                  final surat = _filteredSurat[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: h * 0.015),
                    child: SuratCard(
                      jenisSurat: surat['jenisSurat'],
                      tanggal: surat['tanggal'],
                      status: surat['status'],
                      role: CardRole.tu,
                      data: Map<String, String>.from(surat['data']),
                      onDelete: () {},
                      onDetail: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// ================= NAVBAR =================
      bottomNavigationBar: CustomNavbar(
        role: NavbarRole.tu,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
