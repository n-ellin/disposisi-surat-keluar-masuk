import 'package:flutter/material.dart';

enum CardRole { tu, kepsek, other }

class SuratCard extends StatelessWidget {
  final String jenisSurat;
  final String tanggal;
  final Map<String, String> data;
  final CardRole role;
  final String? status;
  final VoidCallback? onDelete;
  final VoidCallback onDetail;

  const SuratCard({
    super.key,
    required this.jenisSurat,
    required this.tanggal,
    required this.data,
    required this.role,
    this.status,
    this.onDelete,
    required this.onDetail,
  });

  Color _statusColor() {
    switch (status) {
      case 'disetujui':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      case 'menunggu':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _iconSurat() {
    return jenisSurat == 'Surat Masuk' ? Icons.inbox : Icons.outbox;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final avatarSize = w * 0.10;
    final iconSize = avatarSize * 0.65;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            // HEADER (KHUSUS TU)
            if (role == CardRole.tu)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ICON
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 6,
                    ), // atur turun naik di sini
                    child: CircleAvatar(
                      radius: avatarSize / 2,
                      backgroundColor: const Color(0xFFD9D9D9),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final iconSize = constraints.maxWidth * 0.6;

                          return ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF438BB2),
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              jenisSurat == 'Surat Masuk'
                                  ? 'assets/icons/ic_inmail.png'
                                  : 'assets/icons/ic_outmail.png',
                              width: iconSize,
                              height: iconSize,
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // JENIS SURAT + STATUS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jenisSurat,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (status != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor().withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _statusColor(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // TANGGAL
                  Text(
                    tanggal,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),

            const SizedBox(height: 10),

            // ISI
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: data.entries
                    .map(
                      (e) => Row(
                        children: [
                          Expanded(child: Text(e.key)),
                          const Text(': '),
                          Expanded(child: Text(e.value)),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 12),

            // FOOTER
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (role == CardRole.tu)
                  ElevatedButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // warna tombol
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Hapus',
                      style: TextStyle(
                        color: Colors.white, // 🎨 WARNA TEKS
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: onDetail,
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
