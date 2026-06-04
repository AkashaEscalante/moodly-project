import 'package:flutter/material.dart';

class CatAvatar extends StatelessWidget {
  final double size;
  final double fontSize;

  const CatAvatar({super.key, this.size = 48, this.fontSize = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFAB47BC), Color(0xFF4A148C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text('🐱', style: TextStyle(fontSize: fontSize)),
      ),
    );
  }
}
