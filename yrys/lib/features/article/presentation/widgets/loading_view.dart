// made by Yrysa
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(18),
      children: [
        const SizedBox(height: 18),
        Text(AppConstants.ownerLabel, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text('Загружаем случайную статью Wikipedia...', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
        _SkeletonCard(controller: _controller),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final Animation<double> controller;

  const _SkeletonCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final alpha = 0.26 + controller.value * 0.22;
        final color = Theme.of(context).colorScheme.surface.withValues(alpha: alpha);
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.42),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonBox(height: 210, color: color, radius: 26),
              const SizedBox(height: 18),
              _SkeletonBox(height: 18, width: 180, color: color),
              const SizedBox(height: 14),
              _SkeletonBox(height: 30, color: color),
              const SizedBox(height: 10),
              _SkeletonBox(height: 30, width: 260, color: color),
              const SizedBox(height: 18),
              _SkeletonBox(height: 16, color: color),
              const SizedBox(height: 8),
              _SkeletonBox(height: 16, color: color),
              const SizedBox(height: 8),
              _SkeletonBox(height: 16, width: 220, color: color),
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;
  final Color color;

  const _SkeletonBox({required this.height, required this.color, this.width, this.radius = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
    );
  }
}
