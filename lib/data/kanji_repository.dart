import '../models/kanji_level.dart';
import '../models/new_kanji_model.dart';

import 'beginner_kanji.dart';
import 'intermediate_kanji.dart';
import 'expert_kanji.dart';

class KanjiRepository {
  static List<Kanji> getByLevel(KanjiLevel level) {
    switch (level) {
      case KanjiLevel.beginner:
        return beginnerKanji;

      case KanjiLevel.intermediate:
        return intermediateKanji;

      case KanjiLevel.expert:
        return expertKanji;
    }
  }
}
