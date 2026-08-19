import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  final String name;
  final double radius;

  const ContactAvatar({super.key, required this.name, this.radius = 24});

  Color _colorFromName(String name) {
    final colors = [
      Colors.deepPurple, Colors.blue, Colors.green,
      Colors.orange, Colors.pink, Colors.teal,
    ];
    final index = name.isNotEmpty ? name.codeUnitAt(0) % colors.length : 0;
    return colors[index];
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
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
    );
  }
}