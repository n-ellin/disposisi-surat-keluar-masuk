import 'package:flutter/material.dart';

class TUHomePage extends StatefulWidget {
  const TUHomePage({super.key});

  @override
  State<TUHomePage> createState() => _TUHomePageState();
}

class _TUHomePageState extends State<TUHomePage> {
  String selectedFilter = "semua";

  final List<Map<String, dynamic>> suratList = [
    {
      "tanggal": "Senin, 12 Oktober 2025",
      "jenis": "Surat Keluar",
      "status": "disetujui",
      "statusColor": Color(0xFF6CA26F),
    },
    {
      "tanggal": "Senin, 12 Oktober 2025",
      "jenis": "Surat Masuk",
      "status": "ditolak",
      "statusColor": Color(0xFFC75454),
    },
    {
      "tanggal": "Selasa, 13 Oktober 2025",
      "jenis": "Surat Masuk",
      "status": "proses",
      "statusColor": Color(0xFF4C4B4B),
    },
  ];

  @override
  Widget build(BuildContext context) {
    List filteredSurat = selectedFilter == "semua"
        ? suratList
        : suratList.where((s) => s["status"] == selectedFilter).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo + Notification
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

              // search bar
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

              // filter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  filterButton("semua", Colors.grey.shade500),
                  filterButton("disetujui", const Color(0xFF6CA26F)),
                  filterButton("proses", const Color(0xFF4C4B4B)),
                  filterButton("ditolak", const Color(0xFFC75454)),
                ],
              ),
              const SizedBox(height: 25),

              // LIST CARD
              for (var surat in filteredSurat)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: suratCard(
                    tanggal: surat["tanggal"],
                    jenis: surat["jenis"],
                    statusLabel: surat["status"],
                    statusColor: surat["statusColor"],
                  ),
                ),
            ],
          ),
        ),
      ),

      // bottom nav
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.home, size: 30, color: Color(0xFF187D94)),
              Icon(Icons.mail, size: 30, color: Color(0xFFB3B3B3)),
              SizedBox(width: 35),
              Icon(Icons.folder, size: 30, color: Color(0xFFB3B3B3)),
              Icon(Icons.person, size: 30, color: Color(0xFFB3B3B3)),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF187D94),
        shape: const CircleBorder(), // << bikin makin bulet
        onPressed: () {},
        child: const Icon(
          Icons.add,
          size: 30,
        ), // size jangan terlalu besar biar gak kepenuhan
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          color: isSelected ? color : color.withOpacity(0.20),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // CARD
  Widget suratCard({
    required String tanggal,
    required String jenis,
    required String statusLabel,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // << radius DIKURANGI
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 2),
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
          Row(
            children: [
              Text(
                jenis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // badge lebih tipis
                  color: statusColor,
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text("No Surat", style: TextStyle(color: Colors.black54)),
          const Text("Asal", style: TextStyle(color: Colors.black54)),
          const Text("Perihal", style: TextStyle(color: Colors.black54)),
          const Text("Tgl Diterima", style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1AA7D0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // tombol menyamakan radius
                  ),
                ),
                onPressed: () {},
                child: const Text("Hapus"),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // tombol arrow radius lebih kecil
                  color: const Color(0xFF1AA7D0),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
