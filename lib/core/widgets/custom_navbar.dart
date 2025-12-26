import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'notched_custom.dart';

enum NavbarRole { tu, kepsek, other }

class CustomNavbar extends StatelessWidget {
  final NavbarRole role;
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavbar({
    super.key,
    required this.role,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Material(
        elevation: 14,
        shadowColor: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(40), // CAPSULE LUAR
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40), // CAPSULE LUAR
          child: BottomAppBar(
            color: Colors.white,
            elevation: 0,
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,

            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _buildItems(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navIcon(String asset, int index) {
    final isActive = currentIndex == index;

    return IconButton(
      onPressed: () => onTap(index),
      icon: SvgPicture.asset(
        asset,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          isActive ? const Color(0xFF2E8BC0) : Colors.grey,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    return [
      Expanded(child: _navIcon('assets/icons/ic_home.svg', 0)),
      Expanded(child: _navIcon('assets/icons/ic_approval.svg', 1)),

      const SizedBox(width: 64), // ruang FAB (SIMETRIS)

      Expanded(child: _navIcon('assets/icons/ic_history.svg', 2)),
      Expanded(child: _navIcon('assets/icons/ic_profile.svg', 3)),
    ];
  }
}
