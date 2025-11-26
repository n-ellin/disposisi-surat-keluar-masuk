import 'package:flutter/material.dart';

class KepsekMenu extends StatefulWidget {
  const KepsekMenu({super.key});

  @override
  State<KepsekMenu> createState() => _KepsekMenuState();
}

class _KepsekMenuState extends State<KepsekMenu> {
  String selectedFilter = "semua";
  int selectedIndex = 0; // untuk navbar

  final List<Map<String, dynamic>> suratList = [
    {"tanggal": "Senin, 12 Oktober 2025", "jenis": "Surat Keluar"},
    {"tanggal": "Senin, 12 Oktober 2025", "jenis": "Surat Masuk"},
    {"tanggal": "Selasa, 13 Oktober 2025", "jenis": "Surat Masuk"},
  ];

  @override
  Widget build(BuildContext context) {
    List filteredSurat = selectedFilter == "semua"
        ? suratList
        : suratList.where((s) => s["jenis"] == selectedFilter).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/images/logosmk.jpg", width: 45),
                  const Icon(Icons.notifications_none, size: 32),
                ],
              ),

              const SizedBox(height: 8),
              const Text(
                "Disposisi Surat Masuk\nSurat Keluar",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // SEARCH BAR
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Cari surat...",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // FILTER BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  filterButton("semua", Colors.grey.shade600),
                  filterButton("Surat Masuk", const Color(0xFF1A88D0)),
                  filterButton("Surat Keluar", const Color(0xFF4C4B4B)),
                ],
              ),
              const SizedBox(height: 25),

              // LIST OF CARDS
              for (var surat in filteredSurat)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: suratCard(
                    tanggal: surat["tanggal"],
                    jenis: surat["jenis"],
                  ),
                ),
            ],
          ),
        ),
      ),

      // BOTTOM NAVBAR (3 menu)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        selectedItemColor: const Color(0xFF187D94),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 28),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 28),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // BUTTON FILTER
  Widget filterButton(String title, Color color) {
    bool isSelected = selectedFilter == title;

    return GestureDetector(
      onTap: () => setState(() => selectedFilter = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.17),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // CARD SURAT
  Widget suratCard({required String tanggal, required String jenis}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              tanggal,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            jenis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // 👇 Kondisi isi berdasarkan jenis surat
          if (jenis == "Surat Keluar") ...[
            const Text("Kode", style: TextStyle(color: Colors.black54)),
            const Text("No Surat", style: TextStyle(color: Colors.black54)),
            const Text("Asal", style: TextStyle(color: Colors.black54)),
          ] else ...[
            const Text("No Surat", style: TextStyle(color: Colors.black54)),
            const Text("Asal", style: TextStyle(color: Colors.black54)),
            const Text("Perihal", style: TextStyle(color: Colors.black54)),
            const Text("Tgl Diterima", style: TextStyle(color: Colors.black54)),
          ],

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1AA7D0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: const Text("Selengkapnya"),
            ),
          ),
        ],
      ),
    );
  }
}
