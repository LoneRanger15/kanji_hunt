import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveKanji(String level, String kanji) async {
    final prefs = await SharedPreferences.getInstance();

    final key = "${level}_kanji";

    List<String> discovered = prefs.getStringList(key) ?? [];

    if (!discovered.contains(kanji)) {
      discovered.add(kanji);

      await prefs.setStringList(key, discovered);
    }
  }
}
