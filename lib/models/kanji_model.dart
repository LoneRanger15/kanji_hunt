class Kanji {
  final String kanji;
  final String hiragana;
  final String meaning;
  bool isDiscovered;

  Kanji({
    required this.kanji,
    required this.hiragana,
    required this.meaning,
    this.isDiscovered = false, // 👈 default hidden
  });
}
