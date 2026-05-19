import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';

import 'package:ta_mobile_disposisi_surat/shared/widgets/search_bar.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/process_dialog.dart';

import 'package:ta_mobile_disposisi_surat/features/tata_usaha/pages/hasil_disposisi_surat_masuk_page.dart';
import 'package:ta_mobile_disposisi_surat/features/tata_usaha/pages/hasil_pengajuan_surat_keluar_page.dart';

class TuDashboardPage extends StatefulWidget {
  final String jenisSurat;

  const TuDashboardPage({super.key, required this.jenisSurat});

  @override
  State<TuDashboardPage> createState() => _TuDashboardPageState();
}

class _TuDashboardPageState extends State<TuDashboardPage> {
  String _selectedFilter = 'semua';
  String _searchQuery = '';

  /// ================= DATA SURAT =================
  List<Map<String, dynamic>> get _allSurat => DummySurat.allSurat;

  /// ================= FILTER SURAT =================
  List<Map<String, dynamic>> get _filteredSurat {
    List<Map<String, dynamic>> result = _allSurat
        .where((s) => s['jenisSurat'] == widget.jenisSurat)
        .toList();

    /// FILTER STATUS
    if (_selectedFilter != 'semua') {
      result = result.where((s) {
        return (s['status'] ?? '').toString().toLowerCase() ==
            _selectedFilter.toLowerCase();
      }).toList();
    }

    /// SEARCH
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

  /// ================= FILTER COLORS =================
  final Map<String, Color> filterColors = {
    'semua': const Color(0xFF6F7A83),
    'diproses': const Color(0xFFC59B36),
    'disetujui': const Color(0xFF3F9142),
    'ditolak': const Color(0xFFB63A3A),
  };

  /// ================= FILTER LABEL =================
  String _label(String key) {
    switch (key) {
      case 'semua':
        return 'Semua';

      case 'diproses':
        return 'Diproses';

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
      backgroundColor: AppColors.bg,

      /// ================= APPBAR =================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColors.bg,
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
            /// TITLE
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

            /// SEARCH
            SearchBarInput(
              onChanged: (value) => setState(() => _searchQuery = value),
            ),

            SizedBox(height: h * 0.015),

            /// ================= FILTER HORIZONTAL 1 BARIS =================
            /// NOTE:
            /// - Tetap 1 baris horizontal
            /// - Tidak turun jadi 2 baris
            /// - Menggunakan Expanded agar semua tombol rata
            Row(
              children: filterColors.keys.map((key) {
                final isSelected = _selectedFilter == key;

                final color = filterColors[key]!;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = key;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),

                        /// NOTE:
                        /// tinggi tombol dibuat fix
                        height: 38,

                        decoration: BoxDecoration(
                          color: isSelected ? color : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: color,
                            width: 1.3,
                          ),
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

                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,

                            /// NOTE:
                            /// padding kecil supaya text tidak overflow
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                _label(key),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : color,

                                  /// NOTE:
                                  /// ukuran font diperkecil agar muat 4 tombol
                                  fontSize: w * 0.026,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: h * 0.02),

            /// ================= LIST SURAT =================
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: h * 0.12),

                itemCount: _filteredSurat.length,

                itemBuilder: (context, index) {
                  final surat = _filteredSurat[index];

                  return SuratCard(
                    jenisSurat: surat['jenisSurat'].toString(),
                    tanggal: surat['tanggal'].toString(),
                    status: surat['status']?.toString(),

                    role: CardRole.tu,
                    type: CardType.menu,

                    data: Map<String, String>.from(surat['data']),

                    onDetail: () {
                      final status =
                          surat['status']?.toString().toLowerCase();

                      final isMasuk =
                          surat['jenisSurat'] == 'Surat Masuk';

                      if (status == 'diproses') {
                        showProcessDialog(context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => isMasuk
                                ? OutputSuratmasuk(
                                    isApproved:
                                        status == 'disetujui',
                                    catatan:
                                        surat['catatan'] ?? '-',
                                    tujuan:
                                        surat['tujuan'] ?? '-',
                                    instruksi:
                                        surat['instruksi'] ?? '-',
                                    koordinasi:
                                        surat['koordinasi'] ?? '-',
                                    diteruskanKe:
                                        surat['diteruskanKe'] ?? '-',
                                    isReadOnly: false,
                                  )
                                : OutputSuratkeluar(
                                    catatan:
                                        surat['catatan'] ?? '-',
                                    isReadOnly: false,
                                    lampiranUrls:
                                        List<String>.from(
                                      surat['lampiran'] ?? [],
                                    ),
                                  ),
                          ),
                        );
                      }
                    },
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