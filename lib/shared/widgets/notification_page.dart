import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';

// ── MAIN PAGE ─────────────────────────────────────────────────────────────────

class NotificationPage extends StatelessWidget {
  final Role role;
  final List<Map<String, dynamic>> notifications;

  const NotificationPage({
    super.key,
    required this.role,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = _groupNotifications();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildHeader(context),
              const SizedBox(height: 24),
              Expanded(
                child: notifications.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada notifikasi',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      )
                    : ListView(
                        children: grouped.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 14),
                              ...entry.value.map(
                                (notif) => _NotificationCard(
                                  title:  notif['title'],
                                  desc:   notif['desc'],
                                  color:  notif['color'],
                                  isRead: notif['isRead'],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── HELPERS ──────────────────────────────────────────────────────────────────

  Map<String, List<Map<String, dynamic>>> _groupNotifications() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final notif in notifications) {
      final group = _timeGroup(notif['createdAt'] as DateTime);
      grouped.putIfAbsent(group, () => []).add(notif);
    }
    return grouped;
  }

  String _timeGroup(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return 'Hari ini';
    if (diff == 1) return 'Kemarin';
    return '$diff hari yang lalu';
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.bluePrimary,
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'Notifikasi',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.bluePrimary,
          ),
        ),
      ],
    );
  }
}

// ── NOTIFICATION CARD ─────────────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final String title;
  final String desc;
  final Color color;
  final bool isRead;

  const _NotificationCard({
    required this.title,
    required this.desc,
    required this.color,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isRead ? Colors.transparent : color.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Unread indicator dot
          if (!isRead)
            Positioned(
              right: 0,
              top: 2,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),

          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: isRead ? Colors.black54 : Colors.black87,
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

// ── DUMMY DATA ────────────────────────────────────────────────────────────────

final List<Map<String, dynamic>> notifTU = [
  {
    'title':     'Surat Masuk Ditolak',
    'desc':      'Surat masuk telah ditolak Kepala Sekolah. Silakan periksa kembali dan tindak lanjuti.',
    'color':     Colors.red,
    'isRead':    false,
    'createdAt': DateTime.now(),
  },
  {
    'title':     'Surat Masuk Diterima',
    'desc':      'Surat masuk telah diterima Kepala Sekolah. Silakan lanjutkan proses.',
    'color':     Colors.green,
    'isRead':    false,
    'createdAt': DateTime.now(),
  },
  {
    'title':     'Surat Keluar Ditolak',
    'desc':      'Surat keluar ditolak Kepala Sekolah. Periksa kembali dan tindak lanjuti.',
    'color':     Colors.red,
    'isRead':    true,
    'createdAt': DateTime.now().subtract(const Duration(days: 1)),
  },
  {
    'title':     'Surat Keluar Diterima',
    'desc':      'Surat keluar telah diterima Kepala Sekolah. Silakan lanjutkan proses.',
    'color':     Colors.green,
    'isRead':    true,
    'createdAt': DateTime.now().subtract(const Duration(days: 1)),
  },
  {
    'title':     'Surat Masuk Dikonfirmasi',
    'desc':      'Surat masuk sudah dikonfirmasi oleh penerima.',
    'color':     Colors.blue,
    'isRead':    true,
    'createdAt': DateTime.now().subtract(const Duration(days: 1)),
  },
];

final List<Map<String, dynamic>> notifKepsek = [
  {
    'title':     'Pemberitahuan Pengajuan Surat Keluar',
    'desc':      'Terdapat pengajuan surat keluar yang memerlukan peninjauan dari Anda.',
    'color':     Colors.orange,
    'isRead':    false,
    'createdAt': DateTime.now(),
  },
  {
    'title':     'Pemberitahuan Pengajuan Disposisi Surat Masuk',
    'desc':      'Terdapat pengajuan disposisi surat masuk yang memerlukan persetujuan Anda.',
    'color':     Colors.blue,
    'isRead':    false,
    'createdAt': DateTime.now(),
  },
];

final List<Map<String, dynamic>> notifUser = [
  {
    'title':     'Pemberitahuan Surat Masuk',
    'desc':      'Anda menerima surat masuk baru. Silakan periksa detail surat untuk informasi lebih lanjut.',
    'color':     Colors.blue,
    'isRead':    false,
    'createdAt': DateTime.now(),
  },
];