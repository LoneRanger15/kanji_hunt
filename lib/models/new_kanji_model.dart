class Kanji {
  final String kanji;
  final String hiragana;
  final String meaning;

  final String level; // beginner/intermediate/expert

  final List<String> keywords;

  final List<String> compounds;

  final String? imagePath;

  final String? strokeGif;

  final bool discovered;

  Kanji({
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
