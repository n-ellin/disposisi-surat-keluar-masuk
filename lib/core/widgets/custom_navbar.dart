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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Material(
        color: Colors.transparent,
        elevation: 8,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(36), // capsule shape
        clipBehavior: Clip.antiAlias,
        child: BottomAppBar(
          color: Colors.white, // biar shadow terlihat
          elevation: 0,
          notchMargin: 10,
          shape: SmoothFabNotch(
            notchDepth: 2, // atur seberapa dalam lekukan
            notchPadding:
                12, // atur lebar lekukan kiri/kanan// atur kelengkungan lekukan
          ),
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildItems(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    return [
      Expanded(child: _navIcon('assets/icons/ic_home.svg', 0)),
      Expanded(child: _navIcon('assets/icons/ic_approval.svg', 1)),
      const SizedBox(width: 72), // untuk FAB
      Expanded(child: _navIcon('assets/icons/ic_history.svg', 2)),
      Expanded(child: _navIcon('assets/icons/ic_profile.svg', 3)),
    ];
  }

  Widget _navIcon(String asset, int index) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1, end: isActive ? 1.2 : 1.0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.elasticOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: SvgPicture.asset(
              asset,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isActive ? const Color(0xFF2E8BC0) : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
          );
        },
      ),
    );
  }
}
