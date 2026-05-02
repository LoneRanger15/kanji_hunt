import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/kanji_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kanji Hunt',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/kanji': (context) => const KanjiScreen(),
      },
    );
  }
}
