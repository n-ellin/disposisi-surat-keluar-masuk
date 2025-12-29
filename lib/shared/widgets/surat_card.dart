import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final avatarSize = w * 0.10; // responsive
    final iconSize = avatarSize * 0.6;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            if (role == CardRole.tu)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ICON
                  CircleAvatar(
                    radius: avatarSize / 2, // ukuran lingkaran
                    backgroundColor: const Color(0xFFD9D9D9),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 4,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          jenisSurat == 'Surat Masuk'
                              ? 'assets/icons/ic_inmail.svg'
                              : 'assets/icons/ic_outmail.svg',
                          width:
                              avatarSize *
                              0.6, // ubah ini untuk memperkecil ikon
                          height: avatarSize * 0.6, // ubah ini juga
                          fit: BoxFit.contain,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF438BB2),
                            BlendMode.srcIn,
                          ),
                        ),
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

            // ISI SURAT
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
                      backgroundColor: Colors.blue,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Hapus',
                      style: TextStyle(
                        color: Colors.white,
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
