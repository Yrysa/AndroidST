// made by Yrysa
import 'package:flutter/material.dart';

import '../../data/models/summary.dart';

class ArticleTile extends StatelessWidget {
  final Summary article;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ArticleTile({super.key, required this.article, required this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.72),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 58,
            height: 58,
            child: article.imageUrl == null
                ? const ColoredBox(color: Colors.black12, child: Icon(Icons.article_rounded))
                : Image.network(article.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.article_rounded)),
          ),
        ),
        title: Text(article.titles.normalized, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(article.description ?? article.extract, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: onDelete == null ? const Icon(Icons.chevron_right_rounded) : IconButton(icon: const Icon(Icons.delete_outline_rounded), onPressed: onDelete),
      ),
    );
  }
}
