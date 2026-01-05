import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/widgets/custom_navbar.dart';

class KepsekDashboardPage extends StatefulWidget {
  const KepsekDashboardPage({super.key});

  @override
  State<KepsekDashboardPage> createState() => _KepsekDashboardPageState();
}

class _KepsekDashboardPageState extends State<KepsekDashboardPage> {
  int _currentIndex = 0;
  String _filter = 'Semua';

  final List<String> filters = ['Semua', 'Surat Keluar', 'Surat Masuk'];

  final List<Map<String, dynamic>> suratList = [
    {
      'jenis': 'Surat Keluar',
      'tanggal': 'Senin, 12 Oktober 2025',
      'dari': '-',
      'kode': '-',
      'nomor': '-',
      'perihal': 'Permohonan Izin Kegiatan',
    },
    {
      'jenis': 'Surat Masuk',
      'tanggal': 'Senin, 12 Oktober 2025',
      'nomor': '-',
      'asal': '-',
      'perihal': 'Undangan Rapat',
      'tglSurat': '-',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,

      // ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset('assets/images/logo.png'),
        ),
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
            // SEARCH
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

            const SizedBox(height: 12),

            // FILTER
            Row(
              children: filters.map((e) {
                final active = _filter == e;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(e),
                    selected: active,
                    selectedColor: const Color(0xFF7C8B7A),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade400),
                    labelStyle: TextStyle(
                      color: active ? Colors.white : Colors.black,
                    ),
                    onSelected: (_) {
                      setState(() => _filter = e);
                    },
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 120),
                itemCount: suratList.length,
                itemBuilder: (context, index) {
                  final surat = suratList[index];
                  return _suratCard(surat);
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
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }

  // ================= CARD =================
  Widget _suratCard(Map<String, dynamic> surat) {
    final isKeluar = surat['jenis'] == 'Surat Keluar';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
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
                child: Icon(
                  isKeluar ? Icons.upload : Icons.download,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  surat['jenis'],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(surat['tanggal'], style: const TextStyle(fontSize: 12)),
            ],
          ),

          const SizedBox(height: 12),

          // DETAIL BOX
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: isKeluar
                  ? [
                      _row('Dari', surat['dari']),
                      _row('Kode', surat['kode']),
                      _row('Nomor Surat', surat['nomor']),
                      _row('Perihal', surat['perihal']),
                    ]
                  : [
                      _row('Nomor Surat', surat['nomor']),
                      _row('Asal', surat['asal']),
                      _row('Perihal', surat['perihal']),
                      _row('Tanggal Surat', surat['tglSurat']),
                    ],
            ),
          ),

          const SizedBox(height: 12),

          // BUTTON
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5DA9E9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {},
              child: const Text('Selengkapnya'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label)),
          const Text(':  '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
