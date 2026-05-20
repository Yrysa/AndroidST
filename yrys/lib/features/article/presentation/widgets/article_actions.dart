// made by Yrysa
import 'package:flutter/material.dart';

class ArticleActions extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onOpenWikipedia;
  final VoidCallback onCopyLink;
  final VoidCallback onShare;
  final VoidCallback onFavorite;
  final VoidCallback onShowFact;
  final VoidCallback onQuiz;
  final bool isFavorite;

  const ArticleActions({
    super.key,
    required this.onNext,
    required this.onOpenWikipedia,
    required this.onCopyLink,
    required this.onShare,
    required this.onFavorite,
    required this.onShowFact,
    required this.onQuiz,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        FilledButton.icon(onPressed: onNext, icon: const Icon(Icons.shuffle_rounded), label: const Text('Следующая статья')),
        OutlinedButton.icon(onPressed: onOpenWikipedia, icon: const Icon(Icons.open_in_new_rounded), label: const Text('Открыть Wikipedia')),
        FilledButton.tonalIcon(
          onPressed: onFavorite,
          icon: Icon(isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
          label: Text(isFavorite ? 'В избранном' : 'Добавить в избранное'),
        ),
        IconButton.filledTonal(tooltip: 'Скопировать ссылку', onPressed: onCopyLink, icon: const Icon(Icons.link_rounded)),
        IconButton.filledTonal(tooltip: 'Поделиться статьёй', onPressed: onShare, icon: const Icon(Icons.ios_share_rounded)),
        IconButton.filledTonal(tooltip: 'Случайный факт', onPressed: onShowFact, icon: const Icon(Icons.lightbulb_rounded)),
        IconButton.filledTonal(tooltip: 'Проверить себя', onPressed: onQuiz, icon: const Icon(Icons.quiz_rounded)),
      ],
    );
  }
}
