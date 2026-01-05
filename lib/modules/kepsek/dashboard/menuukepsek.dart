import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/widgets/custom_navbar.dart';

class KepsekDashboardPage extends StatefulWidget {
  const KepsekDashboardPage({super.key});

  @override
  State<KepsekDashboardPage> createState() => _KepsekDashboardPageState();
}

class _KepsekDashboardPageState extends State<KepsekDashboardPage> {
  int _currentIndex = 1;
  String _filter = 'semua';

  final Map<String, Color> filterColors = {
    'semua': Colors.grey,
    'menunggu': Colors.orange,
    'disetujui': Colors.green,
    'ditolak': Colors.red,
  };

  final List<Map<String, dynamic>> suratList = [
    {
      'jenis': 'Surat Keluar',
      'tanggal': 'Senin, 12 Oktober 2025',
      'status': 'menunggu',
      'perihal': 'Permohonan Izin Kegiatan',
    },
    {
      'jenis': 'Surat Masuk',
      'tanggal': 'Senin, 12 Oktober 2025',
      'status': 'menunggu',
      'perihal': 'Undangan Rapat',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,

      // ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Disposisi Surat',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications, color: Colors.black),
          ),
        ],
      ),

      // ================= BODY =================
      body: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          children: [
            // 🔍 SEARCH
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Cari surat...',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: h * 0.015),

            // 🏷 FILTER
            Wrap(
              spacing: 8,
              children: filterColors.keys.map((e) {
                final active = _filter == e;
                return ChoiceChip(
                  label: Text(e),
                  selected: active,
                  selectedColor: filterColors[e],
                  labelStyle: TextStyle(
                    color: active ? Colors.white : Colors.black,
                  ),
                  onSelected: (_) {
                    setState(() => _filter = e);
                  },
                );
              }).toList(),
            ),

            SizedBox(height: h * 0.02),

            // 📄 LIST SURAT
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: h * 0.15),
                itemCount: suratList.length,
                itemBuilder: (context, index) {
                  final surat = suratList[index];
                  return _kepsekCard(surat);
                },
              ),
            ),
          ],
        ),
      ),

      // ================= NAVBAR =================
      bottomNavigationBar: CustomNavbar(
        role: NavbarRole.kepsek,
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
        },
      ),
    );
  }

  // ================= CARD KEPSEK =================
  Widget _kepsekCard(Map<String, dynamic> surat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.mail, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surat['jenis'],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      surat['tanggal'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // PERIHAL
          Text('Perihal:', style: TextStyle(color: Colors.grey.shade600)),
          Text(
            surat['perihal'],
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 16),

          // ACTION
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.close, size: 18),
                label: const Text('Tolak'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Setujui'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
