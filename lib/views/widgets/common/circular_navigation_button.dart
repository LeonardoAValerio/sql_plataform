import 'package:flutter/material.dart';

class CircularNavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;

  const CircularNavigationButton({
    required this.icon,
    required this.onPressed,
    required this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: onPressed != null
            ? Colors.grey.shade300
            : Colors.grey.shade400,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: backgroundColor,
        iconSize: 16,
      ),
    );
  }
}