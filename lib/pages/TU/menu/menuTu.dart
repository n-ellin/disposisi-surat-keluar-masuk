import 'package:flutter/material.dart';

class MenuTuPage extends StatefulWidget {
  const MenuTuPage({super.key});

  @override
  State<MenuTuPage> createState() => _MenuTuPage();
}

class _MenuTuPage extends State<MenuTuPage> {
  // Dummy list surat
  List<Map<String, dynamic>> suratList = [
    {
      "judul": "Undangan Rapat Koordinasi",
      "tanggal": "12 Nov 2025",
      "kategori": "Surat Masuk",
      "status": "Masuk",
    },
    {
      "judul": "Permohonan Data Semester",
      "tanggal": "10 Nov 2025",
      "kategori": "Surat Keluar",
      "status": "Keluar",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Menu Sidebar", style: TextStyle(color: Colors.white)),
            ),
            ListTile(title: Text("Dashboard")),
            ListTile(title: Text("Surat Masuk")),
            ListTile(title: Text("Surat Keluar")),
          ],
        ),
      ),

      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("assets/image/logo.png", height: 32),  // ganti sesuai asetmu
            const SizedBox(width: 10),
            const Text("Aplikasi Surat Sekolah"),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: suratList.length,
          itemBuilder: (context, index) {
            final surat = suratList[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(
                  surat["judul"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tanggal: ${surat["tanggal"]}"),
                    Text("Kategori: ${surat["kategori"]}"),
                    Text("Status: ${surat["status"]}"),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Nanti diarahkan ke halaman detail
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Placeholder()),
                    );
                  },
                  child: const Text("Detail"),
                ),
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showMenu(
            context: context,
            position: const RelativeRect.fromLTRB(1000, 600, 16, 0),
            items: [
              PopupMenuItem(
                child: const Text("Surat Masuk"),
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FormSuratMasukPage()),
                    );
                  });
                },
              ),
              PopupMenuItem(
                child: const Text("Surat Keluar"),
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FormSuratKeluarPage()),
                    );
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

// Halaman form dummy
class FormSuratMasukPage extends StatelessWidget {
  const FormSuratMasukPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Surat Masuk")),
      body: const Center(child: Text("Form Surat Masuk — belum dibuat")),
    );
  }
}

class FormSuratKeluarPage extends StatelessWidget {
  const FormSuratKeluarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Surat Keluar")),
      body: const Center(child: Text("Form Surat Keluar — belum dibuat")),
    );
  }
}