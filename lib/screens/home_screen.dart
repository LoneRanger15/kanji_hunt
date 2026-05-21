import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/kanji_repository.dart';
import '../models/new_kanji_model.dart';
import '../screens/camera_screen.dart';
import '../screens/collection_screen.dart';
import '../models/kanji_level.dart';

class HomeScreen extends StatefulWidget {
  final KanjiLevel level;

  const HomeScreen({super.key, required this.level});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int discoveredCount = 0;

  List<Kanji> get currentKanji => KanjiRepository.getByLevel(widget.level);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadDiscoveredCount();
  }

  Future<void> loadDiscoveredCount() async {
    final prefs = await SharedPreferences.getInstance();

    // IMPORTANT: store by level name safely
    final key = "discovered_${widget.level.name}";

    final discovered = prefs.getStringList(key) ?? [];

    setState(() {
      discoveredCount = discovered.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/wp2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$discoveredCount / ${currentKanji.length} discovered",
                  style: GoogleFonts.baloo2(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 4,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 242, 89, 120),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CameraScreen(level: widget.level),
                      ),
                    );

                    if (!mounted) return;

                    await loadDiscoveredCount();
                    setState(() {}); // force UI refresh
                  },
                  child: Text(
                    "Start Hunting",
                    style: GoogleFonts.baloo2(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 242, 89, 120),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CollectionScreen(level: widget.level),
                      ),
                    );
                  },
                  child: Text(
                    "Collection",
                    style: GoogleFonts.baloo2(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
