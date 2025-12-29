import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/widgets/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TuDashboardPage extends StatefulWidget {
  const TuDashboardPage({super.key});

  @override
  State<TuDashboardPage> createState() => _TuDashboardPageState();
}

class _TuDashboardPageState extends State<TuDashboardPage> {
  int _currentIndex = 1;
  bool _isFabOpen = false;
  String _selectedFilter = 'semua';
  double _fabScale = 1.0;

  // ===== MINI FAB BUILDER =====
  Widget _buildMiniFab({
    required bool show,
    required double bottom,
    required Widget child,
  }) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      bottom: show ? bottom : 0,
      child: AnimatedScale(
        scale: show ? 1 : 0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        child: Material(
          elevation: 6,
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          child: child,
        ),
      ),
    );
  }

  // ===== DATA SURAT =====
  final List<Map<String, dynamic>> _allSurat = [
    {
      'jenisSurat': 'Surat Keluar',
      'tanggal': 'Senin, 12 Oktober 2025',
      'status': 'disetujui',
      'data': {'Dari': '', 'Kode': '', 'Nomor Surat': '', 'Perihal': ''},
    },
    {
      'jenisSurat': 'Surat Masuk',
      'tanggal': 'Senin, 12 Oktober 2025',
      'status': 'ditolak',
      'data': {
        'Nomor Surat': '',
        'Asal': '',
        'Perihal': '',
        'Tanggal Surat': '',
      },
    },
  ];

  List<Map<String, dynamic>> get _filteredSurat {
    if (_selectedFilter == 'semua') {
      return _allSurat;
    } else {
      return _allSurat.where((s) => s['status'] == _selectedFilter).toList();
    }
  }

  final Map<String, Color> filterColors = {
    'semua': const Color(0xFF777C6D),
    'disetujui': const Color(0xFF80A46F),
    'diproses': const Color(0xFFDED967),
    'ditolak': const Color(0xFFFF5555),
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final double fabSize = w * 0.16;
    final double fabIconSize = fabSize * 0.5;
    final double fabDownOffset = h * 0.015;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,

      // ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'Disposisi Surat',
          style: TextStyle(
            color: Colors.black,
            fontSize: w * 0.045,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: SizedBox(
          width: w * 0.16,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: w * 0.06),
              child: ClipOval(
                child: Image.asset(
                  "assets/images/logosmk.jpg",
                  width: w * 0.10,
                  height: w * 0.10,
                  fit: BoxFit.cover,
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
              size: w * 0.08,
            ),
          ),
        ],
      ),

      // ================= BODY =================
      body: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          children: [
            // 🔍 SEARCH BAR
            TextField(
              style: TextStyle(fontSize: w * 0.04),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, size: w * 0.055),
                hintText: 'Cari surat...',
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

            // 🏷 FILTER CHIP
            Wrap(
              spacing: w * 0.02,
              runSpacing: h * 0.01,
              children: filterColors.keys.map((e) {
                final isSelected = _selectedFilter == e;
                final color = filterColors[e]!;

                return SizedBox(
                  width: w * 0.21,
                  child: ChoiceChip(
                    label: Center(
                      child: Text(
                        e,
                        style: TextStyle(
                          fontSize: w * 0.035,
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: color,
                    backgroundColor: Colors.white,
                    elevation: isSelected ? 4 : 0,
                    shadowColor: color.withOpacity(0.4),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                    onSelected: (_) {
                      setState(() => _selectedFilter = e);
                    },
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: h * 0.02),

            // 📄 LIST SURAT
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: h * 0.14),
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

      // ================= FAB =================
      floatingActionButton: Transform.translate(
        offset: Offset(0, fabDownOffset),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Mini FAB Surat Masuk
            _buildMiniFab(
              show: _isFabOpen,
              bottom: fabSize * 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/icons/ic_inmail.svg', width: 20),
                      const SizedBox(width: 10),
                      const Text(
                        'Surat Masuk',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Mini FAB Surat Keluar
            _buildMiniFab(
              show: _isFabOpen,
              bottom: fabSize * 1.1,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_outmail.svg',
                        width: 20,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Surat Keluar',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // FAB UTAMA (+)
            AnimatedScale(
              scale: _fabScale,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              child: SizedBox(
                width: fabSize,
                height: fabSize,
                child: Material(
                  color: const Color(0xFF2E8BC0),
                  shape: const CircleBorder(),
                  elevation: 6,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    customBorder: const CircleBorder(),
                    onTapDown: (_) => setState(() => _fabScale = 0.9),
                    onTapUp: (_) => setState(() => _fabScale = 1.0),
                    onTapCancel: () => setState(() => _fabScale = 1.0),
                    onTap: () => setState(() => _isFabOpen = !_isFabOpen),
                    child: Center(
                      child: AnimatedRotation(
                        turns: _isFabOpen ? 0.125 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: fabIconSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ================= NAVBAR =================
      bottomNavigationBar: CustomNavbar(
        role: NavbarRole.tu,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
