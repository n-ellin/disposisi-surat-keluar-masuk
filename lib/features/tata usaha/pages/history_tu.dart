import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';
import 'package:ta_mobile_disposisi_surat/core/helpers/navigation_helper.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/features/tata%20usaha/pages/hasil_disposisi_surat_masuk_page.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import 'package:ta_mobile_disposisi_surat/features/tata%20usaha/pages/hasil_pengajuan_surat_keluar_page.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/filter_date.dart';

class HistoryTUPage extends StatefulWidget {
  const HistoryTUPage({super.key});

  @override
  State<HistoryTUPage> createState() => _HistoryTUPageState();
}

class _HistoryTUPageState extends State<HistoryTUPage> {
  String _searchQuery = FilterState.tuSearchQuery;
  String _statusFilter = FilterState.tuStatusFilter;
  String _dateFilter = FilterState.tuDateFilter;
  DateTime? _selectedDate = FilterState.tuSelectedDate;

  List<Map<String, dynamic>> get _historySurat => DummySurat.allSurat;

  List<Map<String, dynamic>> get _filteredSurat {
    return _historySurat.where((s) {
      final status = s['status'].toString().toLowerCase();

      if (status != 'disetujui' && status != 'ditolak') {
        return false;
      }

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
        final now = DateTime.now();

        if (_dateFilter == 'Hari ini') {
          matchDate =
              suratDate.day == now.day &&
              suratDate.month == now.month &&
              suratDate.year == now.year;
        } else if (_dateFilter == 'Bulan ini') {
          matchDate =
              suratDate.month == now.month && suratDate.year == now.year;
        } else if (_selectedDate != null) {
          matchDate =
              suratDate.day == _selectedDate!.day &&
              suratDate.month == _selectedDate!.month &&
              suratDate.year == _selectedDate!.year;
        }
      } catch (_) {
        matchDate = true;
      }

      return matchSearch && matchStatus && matchDate;
    }).toList();
  }

  void _showDateFilter() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Filter Tanggal',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dateTile('Hari ini'),
              _dateTile('Bulan ini'),
              _dateTile('Pilih tanggal'),
            ],
          ),
        );
      },
    );

    if (result == null) return;

    if (result == 'Pilih tanggal') {
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.bluePrimary,
                onPrimary: Colors.white,
                onSurface: Colors.black87,
              ),
              datePickerTheme: DatePickerThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        setState(() {
          _selectedDate = picked;
          _dateFilter = '${picked.day}/${picked.month}/${picked.year}';
          FilterState.tuSelectedDate = picked;
          FilterState.tuDateFilter = _dateFilter;
        });
      }
    } else {
      setState(() {
        _selectedDate = null;
        _dateFilter = result;
        FilterState.tuSelectedDate = null;
        FilterState.tuDateFilter = result;
      });
    }
  }

  Widget _dateTile(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        Navigator.pop(context, title);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.bg,

      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.018, w * 0.04, 0),
              child: Column(
                children: [
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

                  // SEARCH BAR
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E5EA)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                          FilterState.tuSearchQuery = value;
                        });
                      },
                      style: TextStyle(fontSize: w * 0.036),
                      decoration: InputDecoration(
                        hintText: "Cari surat...",
                        hintStyle: TextStyle(
                          color: AppColors.hintsearch,
                          fontSize: w * 0.036,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.grey.shade400,
                          size: w * 0.052,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: h * 0.014,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.014),

                  // FILTER STATUS
                  Row(
                    children: [
                      Expanded(child: _filterChip("semua")),
                      SizedBox(width: w * 0.02),
                      Expanded(child: _filterChip("disetujui")),
                      SizedBox(width: w * 0.02),
                      Expanded(child: _filterChip("ditolak")),
                    ],
                  ),

                  SizedBox(height: h * 0.012),

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
                ],
              ),
            ),

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
      onTap: () {
        setState(() {
          _statusFilter = label;
          FilterState.tuStatusFilter = label;
        });
      },
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