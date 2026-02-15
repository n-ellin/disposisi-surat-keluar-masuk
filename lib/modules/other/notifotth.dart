import 'package:flutter/material.dart';

class NotifUserPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;

  const NotifUserPage({
    super.key,
    this.notifications = const [
      {
        "title": "Pemberitahuan Surat Masuk",
        "message":
            "Anda menerima surat masuk baru. Silakan periksa detail surat untuk informasi lebih lanjut.",
        "date": "23 Nov 2025",
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------------- HEADER ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, size: 26),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Notifikasi",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff7AA5DA),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 26,
                  ), // agar teks tetap benar-benar center
                ],
              ),
            ),
            const SizedBox(height: 15),

            // ---------------- LIST NOTIFIKASI ----------------
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  return _buildNotifCard(
                    title: notif["title"]!,
                    message: notif["message"]!,
                    date: notif["date"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifCard({
    required String title,
    required String message,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xff7AA5DA), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.18),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Color(0xFF000000)),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 65, 65, 65),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
