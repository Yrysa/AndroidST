// made by Yrysa
import 'package:flutter/material.dart';

import 'ui/article_page/article_screen.dart';

void main() {
  runApp(const YrysaWikiApp());
}

class YrysaWikiApp extends StatelessWidget {
  const YrysaWikiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yrysa Wiki Reader',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF7F4FF),
      ),
      home: const ArticleScreen(),
    );
  }
}
