import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/all_kanji.dart';
import '../models/new_kanji_model.dart';
import '../widgets/kanji_card.dart';

class CollectionScreen extends StatefulWidget {
  final String level;

  const CollectionScreen({super.key, required this.level});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  List<Kanji> discoveredKanji = [];

  @override
  void initState() {
    super.initState();
    loadCollection();
  }

  Future<void> loadCollection() async {
    final prefs = await SharedPreferences.getInstance();

    final key = "${widget.level}_kanji";

    final discoveredSymbols = prefs.getStringList(key) ?? [];

    final loadedKanji = allKanji
        .where(
          (k) => k.level == widget.level && discoveredSymbols.contains(k.kanji),
        )
        .toList();

    setState(() {
      discoveredKanji = loadedKanji;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text("Collection")),

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/wp2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: discoveredKanji.isEmpty
            ? const Center(
                child: Text(
                  "No Kanji Discovered Yet",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: discoveredKanji.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final kanji = discoveredKanji[index];

                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: KanjiCard(kanji: kanji),
                        ),
                      );
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6A5AE0), Color(0xFFFF7A7A)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Center(
                        child: Text(
                          kanji.kanji,
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
