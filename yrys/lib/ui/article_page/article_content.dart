// made by Yrysa
import 'package:flutter/material.dart';

import '../../summary.dart';

class ArticleContent extends StatelessWidget {
  final Summary summary;
  final VoidCallback onNext;
  final VoidCallback onOpenWiki;
  final VoidCallback onOpenGithub;

  const ArticleContent({
    super.key,
    required this.summary,
    required this.onNext,
    required this.onOpenWiki,
    required this.onOpenGithub,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = summary.originalImage?.source ?? summary.thumbnail?.source;

    return ListView(
      key: const ValueKey('article'),
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified_rounded),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: onOpenGithub,
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            'made by Yrysa • github.com/Yrysa',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (imageUrl != null && imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                          height: 220,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 160,
                          child: Center(
                            child: Icon(Icons.image_not_supported_rounded, size: 42),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 18),
                Text(
                  summary.titles.normalized,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                if (summary.description != null && summary.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    summary.description!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
                const SizedBox(height: 14),
                Text(
                  summary.extract,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onNext,
                        icon: const Icon(Icons.shuffle_rounded),
                        label: const Text('Next Article'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onOpenWiki,
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: const Text('Open Wiki'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
