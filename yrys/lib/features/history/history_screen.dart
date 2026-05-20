// made by Yrysa
import 'package:flutter/material.dart';

import '../../app/wiki_state_scope.dart';
import '../article/presentation/open_article_detail.dart';
import '../common/article_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = WikiStateScope.of(context);
    final items = state.history;
    return Scaffold(
      appBar: AppBar(title: const Text('История'), actions: [IconButton(onPressed: items.isEmpty ? null : state.clearHistory, icon: const Icon(Icons.delete_sweep_rounded))]),
      body: items.isEmpty
          ? const Center(child: Text('История пока пустая'))
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final article = items[index];
                return ArticleTile(article: article, onTap: () => openArticleDetail(context, article));
              },
            ),
    );
  }
}
