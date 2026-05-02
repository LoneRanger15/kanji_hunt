import 'package:flutter/material.dart';
import '../models/kanji_model.dart';

class KanjiCard extends StatelessWidget {
  final Kanji kanji;

  const KanjiCard({super.key, required this.kanji});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.8, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: scale.clamp(0.0, 1.0), // ✅ FIX
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A5AE0), Color(0xFFFF7A7A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white.withValues(alpha: 0.1), Colors.transparent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Kanji
            Text(
              kanji.kanji,
              style: TextStyle(
                fontSize: 80,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.yellowAccent.withValues(alpha: 0.8),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Hiragana
            Text(
              kanji.hiragana,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.yellowAccent,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),

            // Meaning
            Text(
              kanji.meaning,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
