import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/utils/full-imges-viewer.dart';

class DetailSuratUsers extends StatelessWidget {
  final Map<String, dynamic> surat;

  const DetailSuratUsers({super.key, required this.surat});

  Map<String, dynamic> get suratData => surat['data'] ?? {};

  List<String> get attachmentUrls => List<String>.from(surat['lampiran'] ?? []);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    double rf(double size) => size * (w / 375);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER — fixed, tidak ikut scroll
              Padding(
                padding: EdgeInsets.only(top: h * 0.025),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.bluePrimary,
                        size: rf(20),
                      ),
                    ),

                    SizedBox(width: w * 0.02),

                    Expanded(
                      child: Text(
                        "Detail Surat",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: rf(18),
                          fontWeight: FontWeight.bold,
                          color: AppColors.bluePrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.025),

              // CARD
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(rf(20)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(rf(14)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: rf(12),
                      offset: const Offset(0, 4),
                      color: Colors.black.withOpacity(0.08),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detailItem(
                      context,
                      icon: Icons.description_outlined,
                      label: "Nomor Surat",
                      value: suratData['Nomor Surat'] ?? '-',
                    ),

                    _detailItem(
                      context,
                      icon: Icons.calendar_today_outlined,
                      label: "Tanggal",
                      value: surat['tanggal'] ?? '-',
                    ),

                    _detailItem(
                      context,
                      icon: Icons.person_outline,
                      label: "Pengirim",
                      value: suratData['Dari'] ?? '-',
                    ),

                    _detailItem(
                      context,
                      icon: Icons.notes,
                      label: "Perihal",
                      value: suratData['Perihal'] ?? '-',
                    ),

                    Text(
                      "Lampiran",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: rf(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: h * 0.01),

                    if (attachmentUrls.isEmpty)
                      Text(
                        "Tidak ada lampiran",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: rf(14),
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
                          padding: EdgeInsets.symmetric(
                            horizontal: rf(14),
                            vertical: rf(12),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(rf(10)),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.attach_file_rounded,
                                color: AppColors.bluePrimary,
                                size: rf(20),
                              ),

                              SizedBox(width: w * 0.025),

                              Expanded(
                                child: Text(
                                  "${attachmentUrls.length} File Lampiran",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: rf(14),
                                  ),
                                ),
                              ),

                              Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.grey.shade500,
                                size: rf(16),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.03),

              // BUTTON
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bluePrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: rf(22),
                      vertical: rf(12),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(rf(12)),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(rf(16)),
                        ),
                        title: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: rf(24),
                            ),

                            SizedBox(width: w * 0.02),

                            Text(
                              "Berhasil",
                              style: TextStyle(fontSize: rf(18)),
                            ),
                          ],
                        ),
                        content: Text(
                          "Konfirmasi berhasil dikirim.",
                          style: TextStyle(fontSize: rf(14)),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.bluePrimary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(rf(8)),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(fontSize: rf(14)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    "Konfirmasi",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: rf(14),
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final w = MediaQuery.of(context).size.width;

    double rf(double size) => size * (w / 375);

    return Padding(
      padding: EdgeInsets.only(bottom: rf(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: rf(3)),
            child: Icon(icon, color: Colors.grey.shade500, size: rf(24)),
          ),

          SizedBox(width: w * 0.04),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: rf(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: rf(4)),

                Text(
                  value,
                  style: TextStyle(
                    fontSize: rf(16),
                    fontWeight: FontWeight.w500,
                    height: 1.3,
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
