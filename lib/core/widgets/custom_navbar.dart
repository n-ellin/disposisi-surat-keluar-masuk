import 'package:flutter/material.dart';

enum NavbarRole { tu, kepsek, other }

class CustomNavbar extends StatelessWidget {
  final NavbarRole role;
  final int currentIndex;
  final Function(int) onTap;
  final bool isFabOpen;

  const CustomNavbar({
    super.key,
    required this.role,
    required this.currentIndex,
    required this.onTap,
    required this.isFabOpen,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      child: BottomAppBar(
        elevation: 8,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildItemsWithFabSpace(),
          ),
        ),
      ),
    );
  }

  // 🔹 ICON CUSTOM
  Widget _navIcon(String asset, int index) {
    final isActive = currentIndex == index;

    return IconButton(
      onPressed: () => onTap(index),
      icon: ColorFiltered(
        colorFilter: ColorFilter.mode(
          isActive ? const Color(0xFF2E8BC0) : Colors.grey,
          BlendMode.srcIn,
        ),
        child: Image.asset(
          asset,
          width: 24,
          height: 24,
        ),
      ),
    );
  }

  List<Widget> _buildItemsWithFabSpace() {
    if (role == NavbarRole.tu) {
      return [
        _navIcon('assets/icons/ic_home.svg', 0),
        _navIcon('assets/icons/ic_approval.svg', 1),

        const SizedBox(width: 48), // ⬅️ ruang FAB

        _navIcon('assets/icons/ic_history.svg', 2),
        _navIcon('assets/icons/ic_profile.svg', 3),
      ];
    } else {
      return [
        _navIcon('assets/icons/ic_home.svg', 0),

        const SizedBox(width: 48),

        _navIcon('assets/icons/ic_history.svg', 1),
        _navIcon('assets/icons/ic_profile.svg', 2),
      ];
    }
  }
}
