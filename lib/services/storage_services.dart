import 'package:shared_preferences/shared_preferences.dart';
import '../models/kanji_level.dart';

class StorageService {
  static String _key(KanjiLevel level) {
    return "discovered_${level.name}";
  }

  /// ✅ Save Kanji using UNIQUE ID (IMPORTANT)
  static Future<void> saveKanji(KanjiLevel level, String kanjiId) async {
    final prefs = await SharedPreferences.getInstance();

    final key = _key(level);

    final List<String> discovered = prefs.getStringList(key) ?? [];

    if (!discovered.contains(kanjiId)) {
      discovered.add(kanjiId);
      await prefs.setStringList(key, discovered);
    }
  }

  /// ✅ Load saved Kanji IDs for a level
  static Future<List<String>> getKanji(KanjiLevel level) async {
    final prefs = await SharedPreferences.getInstance();

    final key = _key(level);

    return prefs.getStringList(key) ?? [];
  }

  /// ✅ Clear all Kanji for a level (useful for reset/testing)
  static Future<void> clearLevel(KanjiLevel level) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key(level));
  }

  /// ✅ Optional helper: check if Kanji already discovered
  static Future<bool> isDiscovered(KanjiLevel level, String kanjiId) async {
    final prefs = await SharedPreferences.getInstance();

    final key = _key(level);

    final discovered = prefs.getStringList(key) ?? [];

    return discovered.contains(kanjiId);
  }
}
