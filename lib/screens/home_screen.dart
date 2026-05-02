import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/kanji_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 🔢 Count discovered kanji
  int get discoveredCount => kanjiList.where((k) => k.isDiscovered).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 79, 168, 10),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🎌 Title
                Text(
                  "Kanji Hunt",
                  style: GoogleFonts.fredoka(
                    fontSize: 45,
                    color: const Color.fromARGB(255, 245, 244, 244),
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Find kanji in the real world",
                  style: GoogleFonts.baloo2(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 30),

                // 📊 Progress
                Text(
                  "$discoveredCount / ${kanjiList.length} discovered",
                  style: GoogleFonts.baloo2(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 40),

                // 🔍 Primary button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF58CC02), // fun purple
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // round = friendly
                    ),
                    elevation: 8,
                  ),
                  onPressed: () {},
                  child: Text(
                    "Start Hunting",
                    style: GoogleFonts.baloo2(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 📚 Secondary button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF58CC02), // fun purple
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // round = friendly
                    ),
                    elevation: 8,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/kanji');
                  },
                  child: Text(
                    "Practice Kanji",
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
