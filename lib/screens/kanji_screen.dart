import 'package:flutter/material.dart';
import '../data/kanji_data.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/kanji_card.dart';

class KanjiScreen extends StatefulWidget {
  const KanjiScreen({super.key});

  @override
  State<KanjiScreen> createState() => _KanjiScreenState();
}

class _KanjiScreenState extends State<KanjiScreen> {
  int currentIndex = 0;

  List get discoveredKanji => kanjiList.where((k) => k.isDiscovered).toList();

  void nextKanji() {
    setState(() {
      currentIndex = (currentIndex + 1) % discoveredKanji.length;
    });
  }

  void previousKanji() {
    if (discoveredKanji.isEmpty) return;

    setState(() {
      currentIndex =
          (currentIndex - 1 + discoveredKanji.length) % discoveredKanji.length;
    });
  }

  // void initState() {
  //   super.initState();

  //   // ⚠️ TEMP for testing (remove later)
  //   kanjiList[0].isDiscovered = true;
  //   kanjiList[1].isDiscovered = true;
  // }

  @override
  Widget build(BuildContext context) {
    if (discoveredKanji.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Go hunt some kanji! 🔍",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;

          if (velocity < 0) {
            nextKanji();
          } else if (velocity > 0) {
            previousKanji();
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔥 Animated switch
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: KanjiCard(
                  key: ValueKey(currentIndex),
                  kanji: discoveredKanji[currentIndex],
                ),
              ),

              const SizedBox(height: 20),

              // 🔢 Index indicator
              Text(
                "${currentIndex + 1} / ${discoveredKanji.length}",
                style: const TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: previousKanji,
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: nextKanji,
                    icon: const Icon(Icons.arrow_forward_ios),
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
