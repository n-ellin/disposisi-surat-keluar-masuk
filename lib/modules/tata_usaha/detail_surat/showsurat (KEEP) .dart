import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/full-img-viewer.dart';

class OutputSuratmasuk extends StatelessWidget {
  const OutputSuratmasuk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ================= HEADER =================
              _header(context),

              const SizedBox(height: 20),

              // ================= TITLE LAMPIRAN =================
              Text(
                "Lampiran Surat",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.bluePrimary,
                ),
              ),

              const SizedBox(height: 8),

              // ================= CARD LAMPIRAN =================
              _lampiranCard(context),

              const SizedBox(height: 12),

              // INFO KECIL
              Text(
                "Tap untuk melihat (zoom)",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 30),

              // ================= BUTTON =================
              _actionButtons(context),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(BuildContext context) {
    return Column(
      children: [
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
            Text(
              "Detail Surat",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.bluePrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.bluePrimary),
          ),
          child: Text(
            "Surat Masuk",
            style: TextStyle(
              color: AppColors.bluePrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ================= CARD LAMPIRAN =================
  Widget _lampiranCard(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
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
        child: Container(
          height: 260,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade200,
          ),
          child: Stack(
            children: [
              // ICON TENGAH
              Center(
                child: Icon(
                  Icons.zoom_in,
                  size: 50,
                  color: Colors.grey.shade600,
                ),
              ),

              // TEXT BAWAH
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Text(
                  "Tap untuk melihat",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= BUTTON =================
  Widget _actionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // LIHAT SURAT
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 44),
            side: BorderSide(color: AppColors.bluePrimary, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // bisa arahkan ke viewer juga
          },
          icon: Icon(Icons.remove_red_eye, color: AppColors.bluePrimary, size: 18),
          label: Text(
            "Lihat Surat",
            style: TextStyle(color: AppColors.bluePrimary),
          ),
        ),

        const SizedBox(width: 12),

        // TERUSKAN
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 44),
            backgroundColor: AppColors.bluePrimary,
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
    );
  }
}