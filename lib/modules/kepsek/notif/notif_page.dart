import 'package:flutter/material.dart';

class NotifUserPage extends StatelessWidget {
  // Data simulasi (List map)
  final List<Map<String, dynamic>> notifications = [
    {
      "id": 1,
      "title": "Pemberitahuan Pengajuan Surat Keluar",
      "message":
          "Terdapat pengajuan surat keluar yang memerlukan peninjauan dari Anda. Mohon ditindaklanjuti sesuai kebutuhan.",
      "time_label": "Kemarin",
      "created_at": DateTime(2026, 1, 8), // Tanggal untuk sorting
    },
    {
      "id": 2,
      "title": "Pemberitahuan Pengajuan Disposisi Surat Masuk",
      "message": "Pemberitahuan Pengajuan Disposisi Surat Masuk",
      "time_label": "Hari ini",
      "created_at": DateTime(2026, 1, 9), // Data terbaru
    },
  ];

  NotifUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    // LOGIKA SORTING: Notifikasi baru (created_at lebih besar) berada di atas
    final sortedNotifications = List<Map<String, dynamic>>.from(notifications)
      ..sort((a, b) => b['created_at'].compareTo(a['created_at']));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xff7AA5DA),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: sortedNotifications.length,
        itemBuilder: (context, index) {
          final notif = sortedNotifications[index];
          return _buildNotifCard(
            context: context,
            title: notif["title"],
            message: notif["message"],
            timeLabel: notif["time_label"],
            onTap: () {
              // Aksi saat notifikasi dipencet
              print("Notifikasi ${notif['id']} ditekan");
            },
          );
        },
      ),
    );
  }

  Widget _buildNotifCard({
    required BuildContext context,
    required String title,
    required String message,
    required String timeLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff7AA5DA).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap, // Menjadikan card bisa dipencet
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    timeLabel,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
