import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/kanji_level.dart';
import 'home_screen.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});

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
            padding: const EdgeInsets.symmetric(horizontal: 28),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🎌 Title
                Text(
                  "Kanji Hunt",
                  style: GoogleFonts.fredoka(
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,

                    shadows: [
                      Shadow(
                        offset: Offset.zero,
                        blurRadius: 20,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Choose Your Level",
                  style: GoogleFonts.baloo2(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,

                    shadows: [Shadow(blurRadius: 10, color: Colors.black54)],
                  ),
                ),

                const SizedBox(height: 50),

                // 🌱 Beginner
                levelCard(
                  context,
                  title: "Beginner",
                  subtitle: "30 Basic Kanji",
                  color: const Color(0xFF6BCB77),
                  level: KanjiLevel.beginner,
                ),

                const SizedBox(height: 20),

                // 🔥 Intermediate
                levelCard(
                  context,
                  title: "Intermediate",
                  subtitle: "JLPT N5 / N4 Kanji",
                  color: const Color(0xFFFFB347),
                  level: KanjiLevel.intermediate,
                ),

                const SizedBox(height: 20),

                // 👑 Expert
                levelCard(
                  context,
                  title: "Expert",
                  subtitle: "Advanced Compounds",
                  color: const Color(0xFFFF6B6B),
                  level: KanjiLevel.expert,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget levelCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color color,
    required KanjiLevel level,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(level: level)),
        );
      },

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.9),

          borderRadius: BorderRadius.circular(25),

          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 6),
              color: Colors.black.withValues(alpha: 0.25),
            ),
          ],
        ),

        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.baloo2(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              subtitle,
              style: GoogleFonts.baloo2(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.95),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
