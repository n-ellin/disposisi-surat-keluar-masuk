import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';

class FilterState {
  static const String defaultDateFilter = 'Hari Ini';

  // ===== TU =====
  static String tuDateFilter = defaultDateFilter;
  static DateTime? tuSelectedDate;
  static String tuStatusFilter = 'semua';
  static String tuSearchQuery = '';

  // ===== KEPSEK =====
  static String kepsekDateFilter = defaultDateFilter;
  static DateTime? kepsekSelectedDate;
  static String kepsekJenisFilter = 'semua';
  static String kepsekSearchQuery = '';

  // ===== GURU / USERS =====
  static String guruDateFilter = defaultDateFilter;
  static DateTime? guruSelectedDate;
  static String guruJenisFilter = 'semua';
  static String guruSearchQuery = '';
}

// Shared pill-style date filter dialog — dipakai oleh TU, Kepsek, dan Users
class DateFilterDialog extends StatelessWidget {
  final String currentFilter;

  const DateFilterDialog({super.key, required this.currentFilter});

  @override
  Widget build(BuildContext context) {
    final options = [
      {'label': 'Hari ini', 'icon': Icons.today_rounded},
      {'label': 'Bulan ini', 'icon': Icons.calendar_month_rounded},
      {'label': 'Pilih tanggal', 'icon': Icons.calendar_today_rounded},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 20,
                color: AppColors.bluePrimary,
              ),
              const SizedBox(width: 8),
              const Text(
                'Filter tanggal',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Pill options
          ...options.map((opt) {
            final label = opt['label'] as String;
            final icon = opt['icon'] as IconData;

            // "Pilih tanggal" dianggap aktif jika filter saat ini adalah
            // tanggal custom (bukan salah satu opsi preset)
            final isCustomDate =
                label == 'Pilih tanggal' &&
                currentFilter != 'Hari ini' &&
                currentFilter != 'Bulan ini';

            final isActive = currentFilter == label || isCustomDate;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context, label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.bluePrimary
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: isActive
                          ? AppColors.bluePrimary
                          : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        size: 18,
                        color: isActive ? Colors.white : Colors.grey.shade500,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isActive ? Colors.white : Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      if (isActive)
                        const Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: Colors.white,
                        )
                      else if (label == 'Pilih tanggal')
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}