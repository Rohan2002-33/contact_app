import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  final String name;
  final bool isFavorite;
  final double radius;

  ContactAvatar({required this.name, this.isFavorite = false, this.radius = 20});

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(radius: radius, child: Text(initials)),
        if (isFavorite)
          Positioned(
            right: -4,
            bottom: -4,
            child: Container(
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(Icons.star, size: radius * 0.8, color: Colors.amber),
            ),
          ),
      ],
    );
  }
}
