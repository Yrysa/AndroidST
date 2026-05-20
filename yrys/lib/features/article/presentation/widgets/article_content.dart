// made by Yrysa
import 'package:flutter/material.dart';

import '../../../../data/models/summary.dart';
import 'article_actions.dart';
import 'article_card.dart';

class ArticleContent extends StatelessWidget {
  final Summary article;
  final List<Summary> history;
  final Summary? articleOfDay;
  final List<String> categories;
  final List<Summary> similarArticles;
  final bool isFavorite;
  final double readingFontSize;
  final bool readingMode;
  final VoidCallback onNext;
  final VoidCallback onOpenWikipedia;
  final VoidCallback onOpenGithub;
  final VoidCallback onCopyLink;
  final VoidCallback onShare;
  final VoidCallback onFavorite;
  final ValueChanged<String> onCategory;
  final ValueChanged<Summary> onOpenArticle;
  final VoidCallback onShowFact;
  final VoidCallback onQuiz;
  final VoidCallback onIncreaseFont;
  final VoidCallback onDecreaseFont;
  final VoidCallback onToggleReadingMode;

  const ArticleContent({
    super.key,
    required this.article,
    required this.history,
    required this.articleOfDay,
    required this.categories,
    required this.similarArticles,
    required this.isFavorite,
    required this.readingFontSize,
    required this.readingMode,
    required this.onNext,
    required this.onOpenWikipedia,
    required this.onOpenGithub,
    required this.onCopyLink,
    required this.onShare,
    required this.onFavorite,
    required this.onCategory,
    required this.onOpenArticle,
    required this.onShowFact,
    required this.onQuiz,
    required this.onIncreaseFont,
    required this.onDecreaseFont,
    required this.onToggleReadingMode,
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
              _HeroHeader(onOpenGithub: onOpenGithub),
              if (articleOfDay != null) ...[
                const SizedBox(height: 16),
                _CompactArticleTile(title: 'Статья дня', article: articleOfDay!, onTap: () => onOpenArticle(articleOfDay!)),
              ],
              const SizedBox(height: 16),
              _Categories(categories: categories, onCategory: onCategory),
              const SizedBox(height: 18),
            ],
            ArticleCard(article: article, fontSize: readingFontSize, compact: readingMode),
            const SizedBox(height: 16),
            if (!readingMode)
              ArticleActions(
                onNext: onNext,
                onOpenWikipedia: onOpenWikipedia,
                onCopyLink: onCopyLink,
                onShare: onShare,
                onFavorite: onFavorite,
                onShowFact: onShowFact,
                onQuiz: onQuiz,
                isFavorite: isFavorite,
              ),
            const SizedBox(height: 12),
            _ReadingTools(
              onIncrease: onIncreaseFont,
              onDecrease: onDecreaseFont,
              onToggle: onToggleReadingMode,
              readingMode: readingMode,
            ),
            if (!readingMode && similarArticles.isNotEmpty) ...[
              const SizedBox(height: 22),
              _ArticleListSection(title: 'Похожие статьи', items: similarArticles, onOpenArticle: onOpenArticle),
            ],
            if (!readingMode && history.length > 1) ...[
              const SizedBox(height: 22),
              _ArticleListSection(title: 'Недавние статьи', items: history.skip(1).take(5).toList(), onOpenArticle: onOpenArticle),
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
        gradient: LinearGradient(colors: [colors.primary.withValues(alpha: 0.18), colors.secondary.withValues(alpha: 0.12)]),
        border: Border.all(color: colors.primary.withValues(alpha: 0.18)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.auto_stories_rounded),
          const SizedBox(width: 10),
          Expanded(child: Text('Wiki Discover app', style: Theme.of(context).textTheme.titleMedium)),
        ]),
        const SizedBox(height: 10),
        Text('Свайпай вверх для новой статьи, сохраняй избранное и изучай мир каждый день.', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 14),
        OutlinedButton.icon(onPressed: onOpenGithub, icon: const Icon(Icons.code_rounded), label: const Text('GitHub автора')),
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final category in categories)
          ActionChip(label: Text(category), avatar: const Icon(Icons.travel_explore_rounded, size: 18), onPressed: () => onCategory(category)),
      ],
    );
  }
}

class _ReadingTools extends StatelessWidget {
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onToggle;
  final bool readingMode;
  const _ReadingTools({required this.onIncrease, required this.onDecrease, required this.onToggle, required this.readingMode});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      IconButton.filledTonal(onPressed: onDecrease, icon: const Icon(Icons.text_decrease_rounded), tooltip: 'Уменьшить текст'),
      const SizedBox(width: 8),
      IconButton.filledTonal(onPressed: onIncrease, icon: const Icon(Icons.text_increase_rounded), tooltip: 'Увеличить текст'),
      const SizedBox(width: 8),
      FilledButton.tonalIcon(
        onPressed: onToggle,
        icon: Icon(readingMode ? Icons.dashboard_customize_rounded : Icons.menu_book_rounded),
        label: Text(readingMode ? 'Обычный режим' : 'Режим чтения'),
      ),
    ]);
  }
}

class _ArticleListSection extends StatelessWidget {
  final String title;
  final List<Summary> items;
  final ValueChanged<Summary> onOpenArticle;
  const _ArticleListSection({required this.title, required this.items, required this.onOpenArticle});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.62),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        for (final item in items) _CompactArticleTile(article: item, onTap: () => onOpenArticle(item)),
      ]),
    );
  }
}

class _CompactArticleTile extends StatelessWidget {
  final String? title;
  final Summary article;
  final VoidCallback onTap;
  const _CompactArticleTile({this.title, required this.article, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: CircleAvatar(backgroundImage: article.imageUrl == null ? null : NetworkImage(article.imageUrl!), child: article.imageUrl == null ? const Icon(Icons.article_rounded) : null),
      title: Text(title ?? article.titles.normalized, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: title == null ? Text(article.description ?? article.extract, maxLines: 1, overflow: TextOverflow.ellipsis) : Text(article.titles.normalized, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
