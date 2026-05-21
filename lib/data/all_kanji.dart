import '../data/beginner_kanji.dart';
import '../data/intermediate_kanji.dart';
import '../data/expert_kanji.dart';
import '../models/kanji_level.dart';
import '../models/new_kanji_model.dart';

List<Kanji> getKanjiForLevel(KanjiLevel level) {
  switch (level) {
    case KanjiLevel.beginner:
      return beginnerKanji;

    case KanjiLevel.intermediate:
      return intermediateKanji;

    case KanjiLevel.expert:
      return expertKanji;
  }
}
