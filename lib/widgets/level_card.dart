import 'package:flutter/material.dart';
import '../models/kanji_level.dart';

class LevelCard extends StatelessWidget {
  final KanjiLevel level;
  final VoidCallback onTap;

  const LevelCard({super.key, required this.level, required this.onTap});

  String get title {
    switch (level) {
      case KanjiLevel.beginner:
        return "Beginner";
      case KanjiLevel.intermediate:
        return "Intermediate";
      case KanjiLevel.expert:
        return "Expert";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
