import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/navigation_helper.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/detail_surat/output_suratmasuk.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/detail_surat/output_suratkeluar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryTUPage extends StatefulWidget {
  const HistoryTUPage({super.key});

  @override
  State<HistoryTUPage> createState() => _HistoryTUPageState();
}

class _HistoryTUPageState extends State<HistoryTUPage> {
  String _searchQuery = '';
  String _statusFilter = 'semua';

  List<Map<String, dynamic>> get _historySurat => DummySurat.allSurat;

  List<Map<String, dynamic>> get _filteredSurat {
    return _historySurat.where((s) {
      final status = s['status'].toString().toLowerCase();

      if (status != 'disetujui' && status != 'ditolak') return false;

      final query = _searchQuery.toLowerCase();
      final jenis = s['jenisSurat'].toString().toLowerCase();
      final tanggal = s['tanggal'].toString().toLowerCase();
      final dari = s['data']['Dari'].toString().toLowerCase();
      final perihal = s['data']['Perihal'].toString().toLowerCase();

      final matchSearch =
          _searchQuery.isEmpty ||
          jenis.contains(query) ||
          tanggal.contains(query) ||
          dari.contains(query) ||
          perihal.contains(query);

      final matchStatus = _statusFilter == 'semua' || status == _statusFilter;

      return matchSearch && matchStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      // [8] Background: subtle off-white biar ga terlalu flat
      backgroundColor: const Color(0xFFF2F2F2),

      body: SafeArea(
        child: Column(
          children: [
            // ─── HEADER ───────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.018, w * 0.04, 0),
              child: Column(
                children: [
                  // [1] Title center, spacing seimbang
                  Text(
                    "Riwayat",
                    style: TextStyle(
                      fontSize: w * 0.062,
                      fontWeight: FontWeight.w800,
                      color: AppColors.bluePrimary,
                      letterSpacing: -0.5,
                    ),
                  ),

                  SizedBox(height: h * 0.016),

                  // [2] Search Bar: shadow tipis, lebih kontras
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFE2E5EA),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                      style: TextStyle(fontSize: w * 0.036),
                      decoration: InputDecoration(
                        hintText: "Cari surat...",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: w * 0.036,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.grey.shade400,
                          size: w * 0.052,
                        ),
                        // [2] Sedikit kurangi height dengan contentPadding
                        contentPadding: EdgeInsets.symmetric(
                          vertical: h * 0.014,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.014),

                  // [3] Filter Chips
                  // [3] Filter Chips — full width
                  Row(
                    children: [
                      Expanded(child: _filterChip("semua")),
                      SizedBox(width: w * 0.02),
                      Expanded(child: _filterChip("disetujui")),
                      SizedBox(width: w * 0.02),
                      Expanded(child: _filterChip("ditolak")),
                    ],
                  ),

                  SizedBox(height: h * 0.014),
                ],
              ),
            ),

            // ─── LIST ──────────────────────────────────────────────────
            Expanded(
              child: _filteredSurat.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: w * 0.2,
                            height: w * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.inbox_outlined,
                              size: w * 0.1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          SizedBox(height: h * 0.016),
                          Text(
                            "Belum ada riwayat surat",
                            style: TextStyle(
                              fontSize: w * 0.038,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        w * 0.04,
                        0,
                        w * 0.04,
                        h * 0.01,
                      ),
                      itemCount: _filteredSurat.length,
                      itemBuilder: (context, index) {
                        final surat = _filteredSurat[index];
                        final isMasuk = surat['jenisSurat'] == 'Surat Masuk';
                        return SuratCard(
                          jenisSurat: surat['jenisSurat'] ?? '',
                          tanggal: surat['tanggal'] ?? '-',
                          data: Map<String, String>.from(surat['data'] ?? {}),
                          role: CardRole.tu,
                          type: CardType.history,
                          status: surat['status'],
                          onDetail: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => isMasuk
                                    ? OutputSuratmasuk(
                                        isApproved:
                                            surat['status'] == 'disetujui',
                                        catatan: surat['catatan'] ?? '-',
                                        tujuan: surat['tujuan'] ?? '-',
                                        instruksi: surat['instruksi'] ?? '-',
                                        koordinasi: surat['koordinasi'] ?? '-',
                                        diteruskanKe:
                                            surat['diteruskanKe'] ?? '-',
                                        isReadOnly: true,
                                      )
                                    : OutputSuratkeluar(
                                        catatan: surat['catatan'] ?? '-',
                                        isReadOnly: true,
                                      ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // [7] Bottom Nav: shadow tipis di atas
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: CustomNavbar(
          role: Role.tu,
          currentIndex: 1,
          onTap: (index) {
            handleNavbarTap(
              context,
              index,
              Role.tu,
              "Tata Usaha",
              "tu@gmail.com",
              "Tata Usaha",
            );
          },
        ),
      ),
    );
  }

  // [3] Filter Chip — compact, border tipis untuk nonaktif
  Widget _filterChip(String label) {
    final isActive = _statusFilter == label;

    Color activeColor;
    switch (label) {
      case 'disetujui':
        activeColor = const Color(0xFF3F9142);
        break;
      case 'ditolak':
        activeColor = const Color(0xFFB63A3A);
        break;
      default:
        activeColor = AppColors.bluePrimary;
    }

    final displayLabel = label[0].toUpperCase() + label.substring(1);

    return GestureDetector(
      onTap: () => setState(() => _statusFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? activeColor : const Color(0xFFD1D5DB),
            width: 1.2,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          displayLabel,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}
