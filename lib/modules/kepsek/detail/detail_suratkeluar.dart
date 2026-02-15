import 'package:flutter/material.dart';

class DetailSSuratPage extends StatelessWidget {
  const DetailSSuratPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Surat',
          style: TextStyle(color: Colors.orange),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orange),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Button Surat Keluar
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.orange),
                  foregroundColor: Colors.orange,
                ),
                onPressed: () {},
                child: const Text('Surat Keluar'),
              ),
            ),

            const SizedBox(height: 16),

            /// Box Konten Surat
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('Isi Surat', style: TextStyle(color: Colors.grey)),
              ),
            ),

            const SizedBox(height: 16),

            /// Catatan
            const Text(
              'Catatan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Masukkan Catatan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const Spacer(),

            /// Button Terima & Tolak
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {},
                    child: const Text('Terima'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {},
                    child: const Text('Tolak'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
