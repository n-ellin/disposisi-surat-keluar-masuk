import 'package:flutter/material.dart';

class SmoothFabNotch extends NotchedShape {
  final double notchDepth;
  final double notchPadding;
  final double bottomDip; // 👈 INI KUNCI

  SmoothFabNotch({
    this.notchDepth = 8,
    this.notchPadding = 12,
    this.bottomDip = 6, // 👈 BESAR = makin turun
  });

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null) {
      return Path()
        ..addRRect(RRect.fromRectAndRadius(host, const Radius.circular(36)));
    }

    final fabRadius = guest.width / 2;
    final centerX = host.center.dx;

    final path = Path()..moveTo(host.left, host.top);

    // kiri lurus
    path.lineTo(centerX - fabRadius - notchPadding, host.top);

    // turun kiri
    path.quadraticBezierTo(
      centerX - fabRadius,
      host.top,
      centerX - fabRadius,
      host.top + notchDepth,
    );

    // 🔥 ARC FAB (INI TETAP)
    path.arcToPoint(
      Offset(centerX + fabRadius, host.top + notchDepth),
      radius: Radius.circular(fabRadius),
      clockwise: false,
    );

    // 🔥 INI YANG HILANG SELAMA INI
    // 👇 CEKUNG KE BAWAH DI BAWAH FAB
    path.quadraticBezierTo(
      centerX,
      host.top + notchDepth + bottomDip, // 👈 TURUN KE BAWAH
      centerX + fabRadius + notchPadding,
      host.top,
    );

    // kanan lurus
    path.lineTo(host.right, host.top);
    path.lineTo(host.right, host.bottom);
    path.lineTo(host.left, host.bottom);
    path.close();

    return path;
  }
}
