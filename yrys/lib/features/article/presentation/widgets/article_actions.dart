// made by Yrysa
import 'package:flutter/material.dart';

class ArticleActions extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onOpenWikipedia;
  final VoidCallback onCopyLink;
  final VoidCallback onShare;

  const ArticleActions({
    super.key,
    required this.onNext,
    required this.onOpenWikipedia,
    required this.onCopyLink,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 520;
        final children = [
          Expanded(
            child: FilledButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.shuffle_rounded),
              label: const Text('Следующая статья'),
            ),
          ),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onOpenWikipedia,
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('Открыть Wikipedia'),
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Скопировать ссылку',
            onPressed: onCopyLink,
            icon: const Icon(Icons.link_rounded),
          ),
          IconButton.filledTonal(
            tooltip: 'Поделиться статьёй',
            onPressed: onShare,
            icon: const Icon(Icons.ios_share_rounded),
          ),
        ];

        if (isNarrow) {
          return Column(
            children: [
              Row(children: children.take(1).toList()),
              const SizedBox(height: 10),
              Row(children: children.skip(1).take(1).toList()),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [children[2], const SizedBox(width: 10), children[3]],
              ),
            ],
          );
        }

        return Row(
          children: [
            children[0],
            const SizedBox(width: 10),
            children[1],
            const SizedBox(width: 10),
            children[2],
            const SizedBox(width: 10),
            children[3],
          ],
        );
      },
    );
  }
}
