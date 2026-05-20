// made by Yrysa
import 'package:flutter/material.dart';

class YrysaLoadingIndicator extends StatefulWidget {
  const YrysaLoadingIndicator({super.key});

  @override
  State<YrysaLoadingIndicator> createState() => _YrysaLoadingIndicatorState();
}

class _YrysaLoadingIndicatorState extends State<YrysaLoadingIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: SweepGradient(
            colors: [
              Colors.white.withValues(alpha: 0.12),
              Colors.cyanAccent.withValues(alpha: 0.95),
              Colors.purpleAccent.withValues(alpha: 0.95),
              Colors.white.withValues(alpha: 0.12),
            ],
          ),
          boxShadow: [
            BoxShadow(color: Colors.purpleAccent.withValues(alpha: 0.35), blurRadius: 32),
          ],
        ),
        child: Center(
          child: Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(color: Color(0xFF15102A), shape: BoxShape.circle),
            child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 34),
          ),
        ),
      ),
    );
  }
}
