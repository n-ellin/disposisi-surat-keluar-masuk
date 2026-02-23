import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/models/navbar_role.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';

class TuDashboardPage extends StatefulWidget {
  final String jenisSurat;

  const TuDashboardPage({super.key, required this.jenisSurat});

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

  void _showDeleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final w = size.width;

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: w * 0.85,
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.06,
                vertical: w * 0.08,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0F6),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// ICON
                  Container(
                    padding: EdgeInsets.all(w * 0.04),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8D29A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFB98A00),
                      size: w * 0.09,
                    ),
                  ),

                  SizedBox(height: w * 0.06),

                  /// TITLE
                  Text(
                    "Apakah anda yakin ingin\nmenghapus surat ini?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: w * 0.042,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: w * 0.03),

                  /// SUBTITLE
                  Text(
                    "Tindakan ini bersifat permanen dan tidak bisa dibatalkan.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: w * 0.032,
                      color: Colors.grey[600],
                    ),
                  ),

                  SizedBox(height: w * 0.08),

                  /// BUTTON ROW
                  Row(
                    children: [
                      /// BATAL
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF6C63FF),
                            side: const BorderSide(color: Color(0xFF6C63FF)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: EdgeInsets.symmetric(vertical: w * 0.035),
                          ),
                          child: const Text("Batal"),
                        ),
                      ),

                      SizedBox(width: w * 0.04),

                      /// HAPUS
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text("Hapus Surat ini"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF3B30),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: EdgeInsets.symmetric(vertical: w * 0.035),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showProcessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final w = size.width;

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: w * 0.75,
              padding: EdgeInsets.symmetric(
                vertical: w * 0.08,
                horizontal: w * 0.06,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0F6),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// ICON BULAT
                  Container(
                    padding: EdgeInsets.all(w * 0.03),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A4A4A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: w * 0.06,
                    ),
                  ),

                  SizedBox(height: w * 0.05),

                  /// TITLE
                  Text(
                    "Surat Dalam Proses",
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: w * 0.025),

                  /// SUBTITLE
                  Text(
                    "Surat masih dalam\nproses pengajuan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: w * 0.032,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> get _filteredSurat {
    List<Map<String, dynamic>> result = _allSurat
        .where((s) => s['jenisSurat'] == widget.jenisSurat)
        .toList();

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
                      role: CardRole.tu,
                      data: Map<String, String>.from(surat['data']),
                      onDelete: _showDeleteDialog,
                      onDetail: _showProcessDialog,
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
