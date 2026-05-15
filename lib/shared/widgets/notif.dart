import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';

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
    /// GROUPING
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var notif in notifications) {
      final group = getTimeGroup(notif['createdAt']);

      if (!grouped.containsKey(group)) {
        grouped[group] = [];
      }

      grouped[group]!.add(notif);
    }

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

              const SizedBox(height: 24),

              Expanded(
                child: ListView(
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

                        ...entry.value.map((notif) {
                          return _NotificationCard(
                            title: notif['title'],
                            desc: notif['desc'],
                            color: notif['color'],
                            isRead: notif['isRead'],
                          );
                        }).toList(),

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

  /// GROUP TITLE
  String getTimeGroup(DateTime date) {
    final now = DateTime.now();

    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return "Hari ini";
    } else if (difference == 1) {
      return "Kemarin";
    } else {
      return "$difference hari yang lalu";
    }
  }
}

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
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Stack(
        children: [

          /// SMALL INDICATOR
          if (!isRead)
            Positioned(
              right: 0,
              top: 2,

              child: Container(
                width: 8,
                height: 8,

                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.only(right: 16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: TextStyle(
                    fontSize: 14,

                    fontWeight: isRead
                        ? FontWeight.w600
                        : FontWeight.bold,

                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  desc,

                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,

                    color: isRead
                        ? Colors.black54
                        : Colors.black87,
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