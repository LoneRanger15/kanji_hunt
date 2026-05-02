class Kanji {
  final String kanji;
  final String hiragana;
  final String meaning;
  final List<String> keywords;
  bool isDiscovered;

  Kanji({
    required this.kanji,
    required this.hiragana,
    required this.meaning,
    required this.keywords,
    this.isDiscovered = false, // 👈 default hidden
  });
}
