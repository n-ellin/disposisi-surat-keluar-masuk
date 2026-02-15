import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/surat_card.dart';
import 'package:ta_mobile_disposisi_surat/shared/widgets/custom_navbar.dart';

class KepsekDashboardPage extends StatefulWidget {
  const KepsekDashboardPage({super.key});

  @override
  State<KepsekDashboardPage> createState() => _KepsekDashboardPageState();
}

class _KepsekDashboardPageState extends State<KepsekDashboardPage> {
  int _currentIndex = 0;
  String _selectedFilter = "Semua";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: w * 0.04),

              /// ================= TITLE =================
              Text(
                "Disposisi Surat",
                style: TextStyle(
                  fontSize: w * 0.055,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: w * 0.05),

              /// ================= SEARCH =================
              Container(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(w * 0.06),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: w * 0.05,
                      offset: Offset(0, w * 0.02),
                    )
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.search, color: Colors.grey),
                    hintText: "Cari surat...",
                    border: InputBorder.none,
                  ),
                ),
              ),

              SizedBox(height: w * 0.05),

              /// ================= FILTER BUTTON =================
              Row(
                children: [
                  _filterButton("Semua"),
                  SizedBox(width: w * 0.03),
                  _filterButton("Surat Masuk"),
                  SizedBox(width: w * 0.03),
                  _filterButton("Surat Keluar"),
                ],
              ),

              SizedBox(height: w * 0.05),

              /// ================= LIST CARD =================
              Expanded(
                child: ListView(
                  children: [
                    SuratCard(
                      jenisSurat: "Surat Masuk",
                      tanggal: "12 Okt 2026",
                      data: {
                        "Dari": "Tata Usaha",
                        "Perihal": "Permohonan Rapat SIKAP",
                      },
                      role: CardRole.other,
                      status: "menunggu",
                      onDetail: () {},
                    ),

                    SuratCard(
                      jenisSurat: "Surat Keluar",
                      tanggal: "12 Okt 2026",
                      data: {
                        "Dari": "Tata Usaha",
                        "Perihal": "Permohonan Rapat SIKAP",
                      },
                      role: CardRole.other,
                      status: "disetujui",
                      onDetail: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// ================= NAVBAR =================
      bottomNavigationBar: CustomNavbar(
        role: NavbarRole.other,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  /// ================= FILTER BUTTON WIDGET =================
  Widget _filterButton(String text) {
    final bool isActive = _selectedFilter == text;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = text;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2E8BC0) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF2E8BC0),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF2E8BC0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
