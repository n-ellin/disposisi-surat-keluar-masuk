import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/search_bar.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';
import 'package:ta_mobile_disposisi_surat/core/helpers/navigation_helper.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/filter_date.dart';
import 'package:ta_mobile_disposisi_surat/features/tata_usaha/pages/hasil_disposisi_surat_masuk_page.dart';
import 'package:ta_mobile_disposisi_surat/features/tata_usaha/pages/hasil_pengajuan_surat_keluar_page.dart';

class HistoryKepsekPage extends StatefulWidget {
  const HistoryKepsekPage({super.key});

  @override
  State<HistoryKepsekPage> createState() => _HistoryKepsekPageState();
}

class _HistoryKepsekPageState extends State<HistoryKepsekPage> {
  String _searchQuery = '';
  String _jenisFilter = 'semua';
  String _dateFilter = 'Hari ini';
  String _activeChip = 'Hari ini';

  DateTime? _startDate;
  DateTime? _endDate;

  List<Map<String, dynamic>> get _historySurat => DummySurat.allSurat;

  List<Map<String, dynamic>> get _filteredSurat {
    return _historySurat.where((s) {
      final query = _searchQuery.toLowerCase();
      final jenis = s['jenisSurat'].toString().toLowerCase();
      final dari = s['data']['Dari'].toString().toLowerCase();
      final perihal = s['data']['Perihal'].toString().toLowerCase();
      final tanggal = s['tanggal'].toString().toLowerCase();

      final matchSearch =
          _searchQuery.isEmpty ||
          jenis.contains(query) ||
          dari.contains(query) ||
          perihal.contains(query) ||
          tanggal.contains(query);

      final matchJenis =
          _jenisFilter == 'semua' ||
          (_jenisFilter == 'masuk' && jenis.contains('masuk')) ||
          (_jenisFilter == 'keluar' && jenis.contains('keluar'));

      bool matchDate = true;

      try {
        final parts = tanggal.split(' ');

        final day = int.parse(parts[0]);

        final monthMap = {
          'januari': 1,
          'februari': 2,
          'maret': 3,
          'april': 4,
          'mei': 5,
          'juni': 6,
          'juli': 7,
          'agustus': 8,
          'september': 9,
          'oktober': 10,
          'november': 11,
          'desember': 12,
        };

        final month = monthMap[parts[1].toLowerCase()] ?? 1;
        final year = int.parse(parts[2]);

        final suratDate = DateTime(year, month, day);

        if (_startDate != null && _endDate != null) {
          final start = DateTime(
            _startDate!.year,
            _startDate!.month,
            _startDate!.day,
          );

          final end = DateTime(
            _endDate!.year,
            _endDate!.month,
            _endDate!.day,
            23,
            59,
            59,
          );

          matchDate =
              suratDate.isAfter(start.subtract(const Duration(days: 1))) &&
              suratDate.isBefore(end.add(const Duration(seconds: 1)));
        }
      } catch (_) {
        matchDate = true;
      }
      return matchSearch && matchJenis && matchDate;
    }).toList();
  }

  void _showDateFilter() async {
    final result = await DateRangeFilterBottomSheet.show(
      context: context,
      initialStartDate: _startDate,
      initialEndDate: _endDate,
      initialChip: _activeChip,
    );

    if (result == null) return;

    setState(() {
      _startDate = result.startDate;
      _endDate = result.endDate;
      _activeChip = result.activeChip;
      _dateFilter = result.dateFilterLabel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: h * 0.02),

              // TITLE
              Text(
                "Riwayat",
                style: TextStyle(
                  fontSize: w * 0.07,
                  fontWeight: FontWeight.bold,
                  color: AppColors.bluePrimary,
                ),
              ),

              SizedBox(height: h * 0.02),

              // SEARCH
              SearchBarInput(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),

              SizedBox(height: h * 0.018),

              // FILTER JENIS
              Row(
                children: [
                  Expanded(child: _filterButton("Semua", "semua")),
                  const SizedBox(width: 10),
                  Expanded(child: _filterButton("Masuk", "masuk")),
                  const SizedBox(width: 10),
                  Expanded(child: _filterButton("Keluar", "keluar")),
                ],
              ),

              SizedBox(height: h * 0.014),

              // FILTER TANGGAL
              GestureDetector(
                onTap: _showDateFilter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E5EA)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 18,
                            color: AppColors.bluePrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _dateFilter,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: h * 0.016),

              // LIST
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
                        padding: const EdgeInsets.only(bottom: 12),
                        itemCount: _filteredSurat.length,
                        itemBuilder: (context, index) {
                          final surat = _filteredSurat[index];

                          return Padding(
                            padding: EdgeInsets.only(bottom: h * 0.001),
                            child: SuratCard(
                              jenisSurat: surat['jenisSurat'],
                              tanggal: surat['tanggal'],
                              status: surat['status'],
                              role: CardRole.kepsek,
                              type: CardType.history,
                              data: Map<String, String>.from(surat['data']),
                              onDetail: () {
                                final isMasuk =
                                    surat['jenisSurat'] == 'Surat Masuk';
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => isMasuk
                                        ? OutputSuratmasuk(
                                            isApproved:
                                                surat['status'] == 'disetujui',
                                            catatan: surat['catatan'] ?? '-',
                                            tujuan: surat['tujuan'] ?? '-',
                                            instruksi:
                                                surat['instruksi'] ?? '-',
                                            koordinasi:
                                                surat['koordinasi'] ?? '-',
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
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomNavbar(
            role: Role.kepsek,
            currentIndex: 1,
            onTap: (index) {
              handleNavbarTap(
                context,
                index,
                Role.kepsek,
                "Kepala Sekolah",
                "kepsek@gmail.com",
                "Kepala Sekolah",
              );
            },
          ),

          ColoredBox(
            color: AppColors.bg,
            child: SizedBox(height: bottomPadding, width: double.infinity),
          ),
        ],
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
