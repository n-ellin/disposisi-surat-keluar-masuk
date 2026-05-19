import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/search_bar.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';
import 'package:ta_mobile_disposisi_surat/core/helpers/navigation_helper.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/filter_date.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import 'package:ta_mobile_disposisi_surat/core/utils/full-imges-viewer.dart';

class HistoryUsersPage extends StatefulWidget {
  const HistoryUsersPage({super.key});

  @override
  State<HistoryUsersPage> createState() => _HistoryUsersPageState();
}

class _HistoryUsersPageState extends State<HistoryUsersPage> {
  String _searchQuery = '';

  String _dateFilter = 'Hari ini';
  String _activeChip = 'Hari ini';

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _startDate = DateTime(now.year, now.month, now.day);

    _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

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

      return matchSearch && matchDate;
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
        builder: (_) =>
            FullScreenImageViewer(imageUrls: lampiran, initialIndex: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final w = size.width;
    final h = size.height;

    double rf(double size) {
      return (w * (size / 375)).clamp(size * 0.9, size * 1.15);
    }

    return Scaffold(
      backgroundColor: AppColors.bg,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),

          child: Column(
            children: [
              SizedBox(height: h * 0.025),

              // TITLE
              Text(
                "Riwayat",
                style: TextStyle(
                  fontSize: rf(22),
                  fontWeight: FontWeight.bold,
                  color: AppColors.bluePrimary,
                ),
              ),

              SizedBox(height: h * 0.025),

              // SEARCH
              SearchBarInput(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),

              SizedBox(height: h * 0.016),

              // FILTER DATE
              GestureDetector(
                onTap: _showDateFilter,

                child: Container(
                  width: double.infinity,

                  padding: EdgeInsets.symmetric(
                    horizontal: rf(14),
                    vertical: rf(10),
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(rf(12)),

                    border: Border.all(color: const Color(0xFFE2E5EA)),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: rf(18),
                            color: AppColors.bluePrimary,
                          ),

                          SizedBox(width: w * 0.02),

                          Text(
                            _dateFilter,
                            style: TextStyle(
                              fontSize: rf(13),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: rf(18),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: h * 0.022),

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
                                size: rf(40),
                                color: Colors.grey.shade300,
                              ),
                            ),

                            SizedBox(height: h * 0.016),

                            Text(
                              "Belum ada riwayat surat",
                              style: TextStyle(
                                fontSize: rf(14),
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
                            padding: EdgeInsets.only(bottom: rf(8)),

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

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          CustomNavbar(
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

          ColoredBox(
            color: AppColors.bg,

            child: SizedBox(
              height: MediaQuery.of(context).padding.bottom,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
