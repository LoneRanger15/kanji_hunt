import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/kanji_repository.dart';
import '../models/kanji_level.dart';
import '../models/new_kanji_model.dart';
import '../widgets/kanji_card.dart';
import '../services/storage_services.dart';

class CollectionScreen extends StatefulWidget {
  final KanjiLevel level;

  const CollectionScreen({super.key, required this.level});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen>
    with SingleTickerProviderStateMixin {
  List<Kanji> discoveredKanji = [];
  bool isLoading = true;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    loadCollection();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> loadCollection() async {
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();

    final key = "discovered_${widget.level.name}";

    final discoveredIds = prefs.getStringList(key) ?? [];

    final kanjiList = KanjiRepository.getByLevel(widget.level);

    final loadedKanji = kanjiList
        .where((k) => discoveredIds.contains(k.id))
        .toList();

    if (!mounted) return;

    setState(() {
      discoveredKanji = loadedKanji;
      isLoading = false;
    });
  }

  Future<void> _confirmReset() async {
    const Color accentColor = Color.fromARGB(255, 242, 89, 120);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Reset Collection",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text(
            "What do you want to clear?",
            style: TextStyle(fontSize: 14),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            // Clear This Level
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await _clearLevel();
                },
                child: const Text(
                  "Clear This Level",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Clear All
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await _clearAll();
                },
                child: const Text(
                  "Clear All",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Cancel (still clean secondary style)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearLevel() async {
    await StorageService.clearLevel(widget.level);

    _shakeController.forward(from: 0);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Level cleared!",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromARGB(255, 242, 89, 120),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
      ),
    );

    await loadCollection();
    Navigator.pop(context, true);
  }

  Future<void> _clearAll() async {
    for (final level in KanjiLevel.values) {
      await StorageService.clearLevel(level);
    }

    _shakeController.forward(from: 0);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "All collections cleared!",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromARGB(255, 242, 89, 120),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
      ),
    );

    await loadCollection();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Collection"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _confirmReset),
        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/wp2.jpg'),
            fit: BoxFit.cover,
          ),
        ),

        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : discoveredKanji.isEmpty
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
            : AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: GridView.builder(
                  key: ValueKey(discoveredKanji.length),
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
                            child: KanjiCard(
                              key: ValueKey("${kanji.id}_${kanji.level}"),
                              kanji: kanji,
                            ),
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
      ),
    );
  }
}
