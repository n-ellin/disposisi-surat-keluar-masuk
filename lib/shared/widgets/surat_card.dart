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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(_iconSurat(), color: Colors.blue),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    jenisSurat,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(tanggal, style: const TextStyle(fontSize: 12)),
              ],
            ),

            if (status != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Chip(
                  label: Text(
                    status!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _statusColor(),
                ),
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
                      backgroundColor: Colors.blue,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Hapus'),
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
