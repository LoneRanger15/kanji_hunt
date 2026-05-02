import 'package:flutter/material.dart';
import '../models/kanji_model.dart';

class KanjiCard extends StatelessWidget {
  final Kanji kanji;

  const KanjiCard({super.key, required this.kanji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6A5AE0), // purple-blue
            Color(0xFFFF7A7A), // soft red/pink
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Kanji
          Text(
            kanji.kanji,
            style: const TextStyle(
              fontSize: 80,
              color: Colors.white,
              fontWeight: FontWeight.bold,
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
    );
  }
}
