import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'notched_custom.dart';
import 'package:ta_mobile_disposisi_surat/shared/models/navbar_role.dart';

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

  bool get _hasFab => role == NavbarRole.tu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Material(
        color: Colors.transparent,
        elevation: 8,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(36),
        clipBehavior: Clip.antiAlias,
        child: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          shape: const _NoNotch(),
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildItems(),
            ),
          ),
        ),
      ),
    );
  }

  // ================= ITEMS BASED ON ROLE =================
  List<Widget> _buildItems() {
    if (role == NavbarRole.tu) {
      return [
        Expanded(child: _navIcon('assets/icons/ic_home.svg', 0)),
        Expanded(
          child: _navIcon('assets/icons/ic_approval.svg', 1),
        ), // FAB slot
        Expanded(child: _navIcon('assets/icons/ic_history.svg', 2)),
        Expanded(child: _navIcon('assets/icons/ic_profile.svg', 3)),
      ];
    }

    // Kepsek & Other (tanpa approval & tanpa FAB)
    return [
      Expanded(child: _navIcon('assets/icons/ic_home.svg', 0)),
      Expanded(child: _navIcon('assets/icons/ic_history.svg', 1)),
      Expanded(child: _navIcon('assets/icons/ic_profile.svg', 2)),
    ];
  }

  // ================= ICON =================
  Widget _navIcon(String asset, int index) {
    final bool isActive = currentIndex == index;

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
                isActive ? const Color(0xFF2E8BC0) : Color(0xFF9FB8C2),
                BlendMode.srcIn,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NoNotch extends NotchedShape {
  const _NoNotch();

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    return Path()..addRect(host);
  }
}
