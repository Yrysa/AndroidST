// made by Yrysa
import 'package:flutter/material.dart';

import '../../models/summary.dart';
import 'article_widget.dart';

class ArticlePage extends StatelessWidget {
  final Summary summary;
  final VoidCallback nextArticle;

  const ArticlePage({super.key, required this.summary, required this.nextArticle});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          pinned: true,
          title: const Text('AndroidST'),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(child: Text('made by Yrysa')),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                ArticleWidget(summary: summary),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: nextArticle,
                    icon: const Icon(Icons.shuffle_rounded),
                    label: const Text('Next Article'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
