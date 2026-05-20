// made by Yrysa
import 'package:flutter/material.dart';

import '../../../../data/models/summary.dart';
import 'article_image.dart';

class ArticleCard extends StatelessWidget {
  final Summary article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.16),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.78),
            border: Border.all(color: colors.outline.withValues(alpha: 0.12)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArticleImage(imageUrl: article.imageUrl),
                const SizedBox(height: 18),
                const _OwnerChip(),
                const SizedBox(height: 14),
                Text(
                  article.titles.normalized,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (article.description != null && article.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    article.description!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colors.primary,
                        ),
                  ),
                ],
                const SizedBox(height: 14),
                Text(
                  article.extract,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OwnerChip extends StatelessWidget {
  const _OwnerChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          const Flexible(child: Text('made by Yrysa • github.com/Yrysa')),
        ],
      ),
    );
  }
}
