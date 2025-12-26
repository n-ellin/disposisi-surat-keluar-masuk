import 'package:flutter/material.dart';

enum NavbarRole { tu, kepsek, other }

class CustomNavbar extends StatelessWidget {
  final NavbarRole role;
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback? onAddPressed;
  final bool isFabOpen;

  const CustomNavbar({
    super.key,
    required this.role,
    required this.currentIndex,
    required this.onTap,
    required this.isFabOpen,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
  height: 60,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: _buildItemsWithFabSpace(),
  ),
),
    );
  }

  Widget _icon(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: currentIndex == index ? Colors.blue : Colors.grey,
      ),
      onPressed: () => onTap(index),
    );
  }
  List<Widget> _buildItemsWithFabSpace() {
  if (role == NavbarRole.tu) {
    return [
      _icon(Icons.home, 0),
      _icon(Icons.people, 1),

      const SizedBox(width: 40), // ⬅️ RUANG FAB (INI PENTING)

      _icon(Icons.history, 2),
      _icon(Icons.person, 3),
    ];
  } else {
    return [
      _icon(Icons.home, 0),

      const SizedBox(width: 40), // ⬅️ tetap kasih ruang

      _icon(Icons.history, 1),
      _icon(Icons.person, 2),
    ];
  }
}

}
