import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/utils/full-img-viewer.dart';

class DetailSuratUsers extends StatelessWidget {
  final Map<String, dynamic> surat;

  const DetailSuratUsers({super.key, required this.surat});

  Map<String, dynamic> get suratData => surat['data'] ?? {};
  List<String> get attachmentUrls => List<String>.from(surat['lampiran'] ?? []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── HEADER ───────────────────────────────────────────────────
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.bluePrimary,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Detail Surat",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.bluePrimary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── DETAIL CARD ──────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      color: Colors.black.withOpacity(0.08),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detailItem(
                      Icons.description_outlined,
                      "Nomor Surat",
                      suratData['Nomor Surat'] ?? '-',
                    ),
                    _detailItem(
                      Icons.calendar_today_outlined,
                      "Tanggal",
                      surat['tanggal'] ?? '-',
                    ),
                    _detailItem(
                      Icons.person_outline,
                      "Pengirim",
                      suratData['Dari'] ?? '-',
                    ),
                    _detailItem(
                      Icons.notes,
                      "Perihal",
                      suratData['Perihal'] ?? '-',
                    ),

                    // ── LAMPIRAN ─────────────────────────────────────────
                    Text(
                      "Lampiran",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (attachmentUrls.isEmpty)
                      Text(
                        "Tidak ada lampiran",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullScreenImageViewer(
                                imageUrls: attachmentUrls,
                                initialIndex: 0,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.attach_file_rounded,
                                color: AppColors.bluePrimary,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${attachmentUrls.length} File Lampiran",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.grey.shade500,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── TOMBOL KONFIRMASI ────────────────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bluePrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text("Berhasil"),
                          ],
                        ),
                        content: const Text("Konfirmasi berhasil dikirim."),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.bluePrimary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    "Konfirmasi",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(icon, color: Colors.grey.shade500, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
