// made by Yrysa
import 'package:flutter/material.dart';

import '../../app/wiki_state_scope.dart';
import '../common/article_tile.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = WikiStateScope.of(context);
    final items = state.favorites;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        actions: [
          IconButton(
            onPressed: items.isEmpty ? null : state.clearFavorites,
            icon: const Icon(Icons.delete_sweep_rounded),
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: Text('Пока нет избранных статей'))
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final article = items[index];
                return ArticleTile(
                  article: article,
                  onTap: () => state.openArticle(article, addToHistory: true),
                  onDelete: () => state.toggleFavorite(article),
                );
              },
            ),
    );
  }
}
