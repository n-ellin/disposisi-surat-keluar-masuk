import 'package:flutter/material.dart';

class CardSurat extends StatelessWidget {
  final String title;                 // Contoh: "Surat Masuk", "Surat Keluar"
  final String? date;                 // Bisa null kalau tidak mau tampil
  final Map<String, String> fields;   // Data fleksibel
  final String? badgeStatus;          // "disetujui", "ditolak", "diproses", atau null
  final Widget? button;               // Tombol custom (Selengkapnya, Hapus, Arrow, dll.)

  const CardSurat({
    super.key,
    required this.title,
    required this.fields,
    this.date,
    this.badgeStatus,
    this.button,
  });

  // Warna badge berdasarkan status
  Color _badgeColor(String status) {
    switch (status.toLowerCase()) {
      case "disetujui":
        return Colors.green.shade300;
      case "ditolak":
        return Colors.red.shade300;
      case "diproses":
        return Colors.orange.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------ TITLE + DATE ------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              if (date != null)
                Text(
                  date!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // ------------ BADGE STATUS ------------
          if (badgeStatus != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _badgeColor(badgeStatus!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badgeStatus!,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),

          const SizedBox(height: 10),

          // ------------ DATA FIELDS ------------
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: fields.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    "${e.key}: ${e.value}",
                    style: const TextStyle(fontSize: 13),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // ------------ CUSTOM BUTTON (opsional) ------------
          if (button != null) Align(alignment: Alignment.centerRight, child: button!),
        ],
      ),
    );
  }
}
