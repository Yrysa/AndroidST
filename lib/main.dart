// made by Yrysa
import 'package:flutter/material.dart';

import 'app_router.dart';

void main() {
  runApp(const YrysaApp());
}

class YrysaApp extends StatelessWidget {
  const YrysaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'AndroidST by Yrysa',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF7F4FF),
      ),
      routerConfig: appRouter,
    );
  }
}
