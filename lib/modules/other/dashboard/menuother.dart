import 'package:flutter/material.dart';
import '../notifotth.dart';
import '../../../shared/widgets/surat_card.dart';
import '../../../shared/auth/profile.dart';

class MenuOther extends StatefulWidget {
  const MenuOther({super.key});

  @override
  State<MenuOther> createState() => _MenuOtherState();
}

class _MenuOtherState extends State<MenuOther> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> suratMasukList = [

  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.015,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER LOGO + NOTIF
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/images/logosmk.jpg",
                    width: size.width * 0.12,
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotifUserPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Disposisi Surat",
                  style: TextStyle(
                    fontSize: size.width * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// SEARCH BAR
              Container(
                height: size.height * 0.055,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Cari surat...",
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// LIST SURAT MASUK
              Expanded(
                child: ListView.builder(
                  itemCount: suratMasukList.length,
                  itemBuilder: (context, index) {
                    final surat = suratMasukList[index];
                    return suratCard(
                      tanggal: surat["tanggal"],
                      no: surat["no"],
                      asal: surat["asal"],
                      perihal: surat["perihal"],
                      tanggalDiterima: surat["tanggalDiterima"],
                      diteruskan: surat["diteruskan"],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: bottomNavBar(),
    );
  }

  //  NAVBAR

  Widget bottomNavBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 25,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navIcon("assets/icons/ic_home.png", 0),
          navIcon("assets/icons/ic_history.png", 1),
          navIcon("assets/icons/ic_profile.png", 2),
        ],
      ),
    );
  }

  Widget navIcon(String iconPath, int index) {
    bool active = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedIndex = index);

        // pindah halaman
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        }
      },

      child: AnimatedScale(
        scale: active ? 1.25 : 1.0,
        duration: const Duration(milliseconds: 220),
        child: Image.asset(
          iconPath,
          width: 28,
          color: active
              ? const Color(0xFF0A6F82)
              : Colors.grey.withOpacity(0.45),
        ),
      ),
    );
  }

  // ========================= SURAT CARD =========================

  Widget suratCard({
    required String tanggal,
    required String no,
    required String asal,
    required String perihal,
    required String tanggalDiterima,
    required String diteruskan,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFC1E5F2),
                    child: Image.asset("assets/icons/ic_inmail.png", width: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Surat Masuk",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(tanggal, style: const TextStyle(fontSize: 12)),
            ],
          ),

          const SizedBox(height: 15),

          /// DETAIL
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                detailText("No Surat: $no"),
                detailText("Asal: $asal"),
                detailText("Perihal: $perihal"),
                detailText("Tanggal Diterima: $tanggalDiterima"),
                detailText("Diteruskan ke: $diteruskan"), // ⬅ field baru
              ],
            ),
          ),

          const SizedBox(height: 15),

          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 115,
              height: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1AA7D0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Selengkapnya",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }
}
