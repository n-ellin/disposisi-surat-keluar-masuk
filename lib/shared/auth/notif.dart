import 'package:flutter/material.dart';

enum NavbarRole { tu, kepsek, other }

class NotificationPage extends StatelessWidget {
  final NavbarRole role;

  const NotificationPage({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final notifications = _getNotificationsByRole(role);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildHeader(context),
              const SizedBox(height: 20),

              const Text(
                "Hari ini",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notif = notifications[index];
                    return _NotificationCard(
                      title: notif['title'],
                      desc: notif['desc'],
                      color: notif['color'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 8),
        const Text(
          "Notifikasi",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C84B6),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getNotificationsByRole(NavbarRole role) {
    switch (role) {
      case NavbarRole.tu:
        return [
          {
            "title": "Surat Masuk Ditolak",
            "desc":
                "Surat masuk telah ditolak Kepala Sekolah. Silakan periksa kembali dan tindak lanjuti.",
            "color": Colors.red,
          },
          {
            "title": "Surat Masuk Diterima",
            "desc":
                "Surat masuk telah diterima Kepala Sekolah. Silakan lanjutkan proses.",
            "color": Colors.green,
          },
          {
            "title": "Surat Keluar Ditolak",
            "desc":
                "Surat keluar ditolak Kepala Sekolah. Periksa kembali dan tindak lanjuti.",
            "color": Colors.red,
          },
          {
            "title": "Surat Keluar Diterima",
            "desc":
                "Surat keluar telah diterima Kepala Sekolah. Silakan lanjutkan proses.",
            "color": Colors.green,
          },
          {
            "title": "Permintaan Persetujuan Akun",
            "desc":
                "Akun atas nama Budi menunggu verifikasi admin untuk akses penuh.",
            "color": Colors.blue,
          },
          {
            "title": "Surat Masuk Dikonfirmasi",
            "desc": "Surat masuk sudah dikonfirmasi oleh penerima.",
            "color": Colors.blue,
          },
        ];

      case NavbarRole.kepsek:
        return [
          {
            "title": "Pemberitahuan Pengajuan Surat Keluar",
            "desc":
                "Terdapat pengajuan surat keluar yang memerlukan peninjauan dari Anda. Mohon ditindaklanjuti sesuai kebutuhan.",
            "color": Colors.blue,
          },
          {
            "title": "Pemberitahuan Pengajuan Disposisi Surat Masuk",
            "desc": "Pemberitahuan Pengajuan Disposisi Surat Masuk",
            "color": Colors.red,
          },
        ];

      case NavbarRole.other:
        return [
          {
            "title": "Pemberitahuan Surat Masuk",
            "desc":
                "Anda menerima surat masuk baru. Silakan periksa detail surat untuk informasi lebih lanjut.",
            "color": Colors.blue,
          },
        ];
    }
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String desc;
  final Color color;

  const _NotificationCard({
    required this.title,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
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
