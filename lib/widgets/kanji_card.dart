import 'package:flutter/material.dart';
import '../models/new_kanji_model.dart';

class KanjiCard extends StatefulWidget {
  final Kanji kanji;

  const KanjiCard({super.key, required this.kanji});

  @override
  State<KanjiCard> createState() => _KanjiCardState();
}

class _KanjiCardState extends State<KanjiCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kanji = widget.kanji;

    Color _getLevelColor() {
      switch (widget.kanji.level.name) {
        case "beginner":
          return const Color(0xFF6BCB77);
        case "intermediate":
          return const Color(0xFFFFB347);
        case "expert":
          return const Color(0xFFFF6B6B);
        default:
          return const Color(0xFF6A5AE0);
      }
    }

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.8, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: Opacity(opacity: scale.clamp(0.0, 1.0), child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_getLevelColor(), const Color(0xFF6A5AE0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tabs
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.30),
                      Colors.white.withValues(alpha: 0.12),
                    ],
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                labelPadding: const EdgeInsets.symmetric(vertical: 10),
                tabs: const [
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("📖 Info"),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("✍️ Stroke"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 380,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // ================= INFO TAB =================
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (kanji.imagePath != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              kanji.imagePath!,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),

                        const SizedBox(height: 16),

                        Text(
                          kanji.kanji,
                          style: const TextStyle(
                            fontSize: 80,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          kanji.hiragana,
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.yellowAccent,
                          ),
                        ),

                        Text(
                          kanji.meaning,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 20),

                        if (kanji.compounds.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "📚 Compounds",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...kanji.compounds.map(
                                  (c) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      c,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ================= STROKE TAB =================
                  Center(
                    child: kanji.strokeGif != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              kanji.strokeGif!,
                              fit: BoxFit.contain,
                            ),
                          )
                        : const Text(
                            "No Stroke Order",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
