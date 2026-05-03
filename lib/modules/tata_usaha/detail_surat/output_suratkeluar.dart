import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/full-img-viewer.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';

class OutputSuratkeluar extends StatelessWidget {
  final String catatan;
  const OutputSuratkeluar({super.key, required this.catatan});

  @override
Widget build(BuildContext context) {
  const orange = Color(0xFFE08B2E);

  return Scaffold(
    backgroundColor: const Color(0xFFF4F6F8),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // HEADER
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Text(
                  "Detail Surat",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // CHIP
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: orange),
                ),
                child: const Text(
                  "Surat Keluar",
                  style: TextStyle(
                    color: orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CARD CATATAN
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Catatan",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 120),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        catatan.isEmpty ? "-" : catatan,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // BUTTONS (SEJAJAR)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // LIHAT SURAT
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    side: BorderSide(color: orange, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageViewer(
                          imageAssetPath: 'assets/images/undangan.png',
                          imageUrls: const [
                            'assets/images/undangan.png',
                            'assets/images/logo.png',
                          ],
                          initialIndex: 0,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.remove_red_eye, size: 18, color: Colors.grey),
                  label: const Text("Lihat Surat"),
                ),

                const SizedBox(width: 12),

                // TERUSKAN
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.send, size: 18),
                  label: const Text("Teruskan"),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    ),
  );
}
}
