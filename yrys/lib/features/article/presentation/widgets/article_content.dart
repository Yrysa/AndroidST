// made by Yrysa
import 'package:flutter/material.dart';

import '../../../../data/models/summary.dart';
import 'article_actions.dart';
import 'article_card.dart';

class ArticleContent extends StatelessWidget {
  final Summary article;
  final List<Summary> history;
  final VoidCallback onNext;
  final VoidCallback onOpenWikipedia;
  final VoidCallback onOpenGithub;
  final VoidCallback onCopyLink;
  final VoidCallback onShare;

  const ArticleContent({
    super.key,
    required this.article,
    required this.history,
    required this.onNext,
    required this.onOpenWikipedia,
    required this.onOpenGithub,
    required this.onCopyLink,
    required this.onShare,
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
            _HeroHeader(onOpenGithub: onOpenGithub),
            const SizedBox(height: 18),
            AnimatedSlide(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              offset: Offset.zero,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 450),
                opacity: 1,
                child: ArticleCard(article: article),
              ),
            ),
            const SizedBox(height: 16),
            ArticleActions(
              onNext: onNext,
              onOpenWikipedia: onOpenWikipedia,
              onCopyLink: onCopyLink,
              onShare: onShare,
            ),
            if (history.length > 1) ...[
              const SizedBox(height: 22),
              _HistorySection(history: history.skip(1).toList()),
            ],
          ],
        );
      },
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final VoidCallback onOpenGithub;

  const _HeroHeader({required this.onOpenGithub});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            colors.primary.withValues(alpha: 0.18),
            colors.secondary.withValues(alpha: 0.12),
          ],
        ),
        border: Border.all(color: colors.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_stories_rounded),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Премиальный читатель Wikipedia',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Открывай случайные статьи, сохраняй историю и делись интересными находками.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onOpenGithub,
            icon: const Icon(Icons.code_rounded),
            label: const Text('GitHub автора'),
          ),
        ],
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  final List<Summary> history;

  const _HistorySection({required this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.62),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Недавние статьи', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          for (final item in history.take(5))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.history_rounded, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.titles.normalized,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
