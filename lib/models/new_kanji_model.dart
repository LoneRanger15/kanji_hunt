import 'kanji_level.dart';

class Kanji {
  final String id; // ⭐ UNIQUE IDENTIFIER (MOST IMPORTANT)
  final String kanji;

  final String hiragana;
  final String meaning;

  final KanjiLevel level;

  final List<String> keywords;

  final List<String> compounds;

  final String? imagePath;
  final String? strokeGif;

  final bool discovered;

  const Kanji({
    required this.id,
    required this.kanji,
    required this.hiragana,
    required this.meaning,
    required this.level,
    required this.keywords,
    required this.compounds,
    this.imagePath,
    this.strokeGif,
    this.discovered = false,
  });
}
