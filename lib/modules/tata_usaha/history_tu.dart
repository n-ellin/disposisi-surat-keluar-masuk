import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/custom_navbar.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';
import 'package:ta_mobile_disposisi_surat/shared/navbar/navigation_helper.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/detail_surat/output_suratmasuk.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/dummy.dart';
import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/detail_surat/output_suratkeluar.dart';

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

      // ✅ Hanya tampilkan surat yang sudah dikonfirmasi kepsek (disetujui / ditolak)
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
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(w * 0.04),
          child: Column(
            children: [
              SizedBox(height: h * 0.02),

              /// TITLE
              Center(
                child: Text(
                  "Riwayat",
                  style: TextStyle(
                    fontSize: w * 0.065,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bluePrimary,
                  ),
                ),
              ),

              SizedBox(height: h * 0.02),

              /// SEARCH
              TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Cari Surat...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: h * 0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _filterButton("semua"),
                  _filterButton("disetujui"),
                  _filterButton("ditolak"),
                ],
              ),

              SizedBox(height: h * 0.02),

              /// LIST HISTORY
              Expanded(
                child: _filteredSurat.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: w * 0.15,
                              color: Colors.grey.shade300,
                            ),
                            SizedBox(height: h * 0.02),
                            Text(
                              "Belum ada riwayat surat",
                              style: TextStyle(
                                fontSize: w * 0.04,
                                color: Colors.grey.shade400,
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
                            padding: EdgeInsets.only(bottom: h * 0.015),
                            child: SuratCard(
                              jenisSurat: surat['jenisSurat'].toString(),
                              tanggal: surat['tanggal'].toString(),
                              status: surat['status']?.toString(),

                              role: CardRole.tu,
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

      bottomNavigationBar: CustomNavbar(
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
    );
  }

  Widget _filterButton(String label) {
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

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _statusFilter = label;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? activeColor : Colors.grey.shade200,
        foregroundColor: isActive ? Colors.white : Colors.black87,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label[0].toUpperCase() + label.substring(1)),
    );
  }
}