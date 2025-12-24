import 'package:flutter/material.dart';

class CustomNavbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<IconData> icons;
  final bool hasFloatingMenu;
  final VoidCallback? onMenu1;
  final VoidCallback? onMenu2;

  const CustomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.icons,
    this.hasFloatingMenu = false,
    this.onMenu1,
    this.onMenu2,
  });

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isOpen = false;

  late Animation<double> _rotation;
  late Animation<double> _fade;
  late Animation<double> _scale;

  late Animation<Offset> _slide1;
  late Animation<Offset> _slide2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotation = Tween<double>(begin: 0, end: 0.75).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _slide1 = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: const Offset(0, -1.5),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slide2 = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: const Offset(0, -2.7),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void toggleMenu() {
    if (!widget.hasFloatingMenu) return;

    setState(() {
      isOpen = !isOpen;
      isOpen ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // NAVBAR BACKGROUND
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          margin: const EdgeInsets.only(top: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                spreadRadius: -5,
                offset: const Offset(0, 6),
                color: Colors.black.withOpacity(0.15),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.icons.length, (index) {
              return GestureDetector(
                onTap: () => widget.onTap(index),
                child: Icon(
                  widget.icons[index],
                  size: 28,
                  color: widget.selectedIndex == index
                      ? const Color(0xFF066A7F)
                      : Colors.grey[400],
                ),
              );
            }),
          ),
        ),

        // BUTTON +
        if (widget.hasFloatingMenu)
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: toggleMenu,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return Transform.rotate(
                    angle: _rotation.value * 3.14,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Color(0xFF066A7F),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add,
                          size: 32, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),

        // POPUP 1 — SURAT MASUK
        if (widget.hasFloatingMenu)
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _slide1,
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: _popupButton(
                    icon: Icons.mail_outline,
                    label: "Surat Masuk",
                    onTap: () {
                      widget.onMenu1?.call();
                      toggleMenu();
                    },
                  ),
                ),
              ),
            ),
          ),

        // POPUP 2 — SURAT KELUAR
        if (widget.hasFloatingMenu)
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _slide2,
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: _popupButton(
                    icon: Icons.outbox_outlined,
                    label: "Surat Keluar",
                    onTap: () {
                      widget.onMenu2?.call();
                      toggleMenu();
                    },
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _popupButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.15),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF066A7F)),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF066A7F), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
