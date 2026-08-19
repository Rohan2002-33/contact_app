import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final bool isFavorite;

  const ContactAvatar({super.key, required this.name, this.radius = 24, this.isFavorite = false});

  Color _colorFromName(String name) {
    final colors = [
      Color(0xFF6C63FF), Color(0xFF5AA9E6), Color(0xFF3CCF8E),
      Color(0xFFFFB86B), Color(0xFFEA6EA8), Color(0xFF8EE1D5),
    ];
    final index = name.isNotEmpty ? name.codeUnitAt(0) % colors.length : 0;
    return colors[index];
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: _colorFromName(name),
          child: Text(
            _initials(name),
            style: TextStyle(
              color: Colors.white,
              fontSize: radius * 0.7,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (isFavorite)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.star, color: Colors.amber, size: 14),
            ),
          ),
      ],
    );
  }
}