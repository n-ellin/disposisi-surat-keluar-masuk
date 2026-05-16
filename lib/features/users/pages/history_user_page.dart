import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';
import 'package:ta_mobile_disposisi_surat/core/helpers/navigation_helper.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/filter_date.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import 'package:ta_mobile_disposisi_surat/core/utils/full-img-viewer.dart';

class HistoryUsersPage extends StatefulWidget {
  const HistoryUsersPage({super.key});

  @override
  State<HistoryUsersPage> createState() => _HistoryUsersPageState();
}

class _HistoryUsersPageState extends State<HistoryUsersPage> {
  String _searchQuery = FilterState.guruSearchQuery;
  String _dateFilter = FilterState.guruDateFilter;
  DateTime? _selectedDate = FilterState.guruSelectedDate;

  List<Map<String, dynamic>> get _historySurat => DummySurat.allSurat
      .where((s) => s['jenisSurat'].toString().toLowerCase() == 'surat masuk')
      .toList();

  List<Map<String, dynamic>> get _filteredSurat {
    return _historySurat.where((s) {
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
        } else if (_dateFilter == 'Tahun ini') {
          matchDate = suratDate.year == now.year;
        } else if (_selectedDate != null) {
          matchDate =
              suratDate.day == _selectedDate!.day &&
              suratDate.month == _selectedDate!.month &&
              suratDate.year == _selectedDate!.year;
        }
      } catch (_) {
        matchDate = true;
      }

      return matchSearch && matchDate;
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
              _dateTile('Tahun ini'),
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
                onSurface: Colors.black,
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
          FilterState.guruSelectedDate = picked;
          FilterState.guruDateFilter = _dateFilter;
        });
      }
    } else {
      setState(() {
        _selectedDate = null;
        _dateFilter = result;
        FilterState.guruSelectedDate = null;
        FilterState.guruDateFilter = result;
      });
    }
  }

  void _openLampiran(BuildContext context, Map<String, dynamic> surat) {
    final List<String> lampiran = List<String>.from(surat['lampiran'] ?? []);

    if (lampiran.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Tidak ada lampiran"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImageViewer(
          imageUrls: lampiran,
          initialIndex: 0,
        ),
      ),
    );
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
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(w * 0.04),
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
                      FilterState.guruSearchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Cari surat...",
                    hintStyle: TextStyle(color: AppColors.hintsearch),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.grey.shade400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: h * 0.015),
                  ),
                ),
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

              SizedBox(height: h * 0.02),

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
                        itemCount: _filteredSurat.length,
                        itemBuilder: (context, index) {
                          final surat = _filteredSurat[index];

                          return Padding(
                            padding: EdgeInsets.only(bottom: h * 0.02),
                            child: SuratCard(
                              jenisSurat: surat['jenisSurat'].toString(),
                              tanggal: surat['tanggal'].toString(),
                              role: CardRole.Users,
                              type: CardType.history,
                              data: Map<String, String>.from(surat['data']),
                              diteruskanKe: surat['diteruskanKe']?.toString(),
                              onDetail: () => _openLampiran(context, surat),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      // NAVBAR
      bottomNavigationBar: CustomNavbar(
        role: Role.users,
        currentIndex: 1,
        onTap: (index) {
          handleNavbarTap(
            context,
            index,
            Role.users,
            "User",
            "user@gmail.com",
            "User",
          );
        },
      ),
    );
  }
}