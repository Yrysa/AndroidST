// made by Yrysa
import 'package:flutter/material.dart';

import '../../../../data/models/summary.dart';
import 'article_card.dart';

class ArticleContent extends StatelessWidget {
  final Summary article;
  final List<String> categories;
  final bool readingMode;
  final double readingFontSize;
  final VoidCallback onNext;
  final VoidCallback onMenu;
  final ValueChanged<String> onCategory;

  const ArticleContent({
    super.key,
    required this.article,
    required this.categories,
    required this.readingMode,
    required this.readingFontSize,
    required this.onNext,
    required this.onMenu,
    required this.onCategory,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 760;
        final horizontalPadding = isWide ? constraints.maxWidth * 0.12 : 18.0;
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(horizontalPadding, 18, horizontalPadding, 32),
          children: [
            if (!readingMode) ...[
              const _CleanHeader(),
              const SizedBox(height: 14),
              _Categories(categories: categories, onCategory: onCategory),
              const SizedBox(height: 18),
            ],
            ArticleCard(article: article, fontSize: readingFontSize, compact: readingMode),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onNext,
                  icon: const Icon(Icons.shuffle_rounded),
                  label: const Text('Следующая статья'),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                tooltip: 'Действия',
                onPressed: onMenu,
                icon: const Icon(Icons.more_horiz_rounded),
              ),
            ]),
          ],
        );
      },
    );
  }
}

class _CleanHeader extends StatelessWidget {
  const _CleanHeader();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(colors: [colors.primary.withValues(alpha: 0.16), colors.secondary.withValues(alpha: 0.10)]),
        border: Border.all(color: colors.primary.withValues(alpha: 0.14)),
      ),
      child: Row(children: [
        const Icon(Icons.auto_stories_rounded),
        const SizedBox(width: 10),
        Expanded(child: Text('Yrysa Wiki Reader', style: Theme.of(context).textTheme.titleMedium)),
      ]),
    );
  }
}

class _Categories extends StatelessWidget {
  final List<String> categories;
  final ValueChanged<String> onCategory;
  const _Categories({required this.categories, required this.onCategory});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in categories.take(8))
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Text(category),
                avatar: const Icon(Icons.travel_explore_rounded, size: 18),
                onPressed: () => onCategory(category),
              ),
            ),
        ],
      ),
    );
  }
}
