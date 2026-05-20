// made by Yrysa
import 'package:flutter/material.dart';

class ArticleImage extends StatelessWidget {
  final String? imageUrl;

  const ArticleImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.22),
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.16),
              ],
            ),
          ),
          child: url == null || url.isEmpty
              ? const _ImageFallback()
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const _ImageSkeleton();
                  },
                  errorBuilder: (context, error, stackTrace) => const _ImageFallback(),
                ),
        ),
      ),
    );
  }
}

class _ImageSkeleton extends StatelessWidget {
  const _ImageSkeleton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.44),
        ),
        child: const Icon(Icons.image_rounded, size: 34),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_stories_rounded, size: 44, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          const Text('Изображение недоступно'),
        ],
      ),
    );
  }
}
