import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/role.dart';

// ── WIDGET ────────────────────────────────────────────────────────────────────

class CustomNavbar extends StatelessWidget {
  final Role role;
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
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Material(
        color: Colors.transparent,
        elevation: 4,
        shadowColor: Colors.black12,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          shape: const _NoNotch(),
          child: SizedBox(
            height: 54,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _navIcon('assets/icons/ic_home.svg', 0)),
                Expanded(child: _navIcon('assets/icons/ic_history.svg', 1)),
                Expanded(child: _navIcon('assets/icons/ic_profile.svg', 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── NAV ICON ─────────────────────────────────────────────────────────────────

  Widget _navIcon(String asset, int index) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1, end: isActive ? 1.1 : 1.0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.elasticOut,
        builder: (context, scale, _) {
          return Transform.scale(
            scale: scale,
            child: SvgPicture.asset(
              asset,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                isActive ? const Color(0xFF2E8BC0) : const Color(0xFF9FB8C2),
                BlendMode.srcIn,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── NO NOTCH SHAPE ────────────────────────────────────────────────────────────

class _NoNotch extends NotchedShape {
  const _NoNotch();

  @override
  Path getOuterPath(Rect host, Rect? guest) => Path()..addRect(host);
}
