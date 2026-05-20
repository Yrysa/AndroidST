// made by Yrysa
import 'package:flutter/material.dart';

class SplashFeatureText extends StatefulWidget {
  const SplashFeatureText({super.key});

  @override
  State<SplashFeatureText> createState() => _SplashFeatureTextState();
}

class _SplashFeatureTextState extends State<SplashFeatureText> {
  static const _phrases = [
    'Открывай случайные статьи',
    'Сохраняй интересное в избранное',
    'Изучай мир каждый день',
    'Читай статьи на RU / EN / KK',
    'Открывай знания красиво',
  ];

  int _index = 0;

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      if (!mounted) return false;
      setState(() => _index = (_index + 1) % _phrases.length);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      child: Text(
        _phrases[_index],
        key: ValueKey(_index),
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }
}
