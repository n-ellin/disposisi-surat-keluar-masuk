import 'package:flutter/material.dart';

class SmoothFabNotch extends NotchedShape {
  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null)
      return Path()
        ..addRRect(RRect.fromRectAndRadius(host, const Radius.circular(40)));

    final double fabRadius = guest.width / 2;
    final double fabCenterX = guest.center.dx;
    final double notchDepth = 28;

    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(fabCenterX - fabRadius - 12, host.top)
      ..quadraticBezierTo(
        fabCenterX - fabRadius,
        host.top,
        fabCenterX - fabRadius + 6,
        host.top + notchDepth,
      )
      ..arcToPoint(
        Offset(fabCenterX + fabRadius - 6, host.top + notchDepth),
        radius: Radius.circular(fabRadius),
        clockwise: false,
      )
      ..quadraticBezierTo(
        fabCenterX + fabRadius,
        host.top,
        fabCenterX + fabRadius + 12,
        host.top,
      )
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}
