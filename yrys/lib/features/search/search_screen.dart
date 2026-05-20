// made by Yrysa
import 'package:flutter/material.dart';

import '../../app/wiki_state_scope.dart';
import '../common/article_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  bool _searched = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final state = WikiStateScope.of(context);
    setState(() {
      _loading = true;
      _searched = true;
    });
    await state.search(_controller.text);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final state = WikiStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Поиск')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              hintText: 'Введите название или ключевое слово',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(onPressed: _search, icon: const Icon(Icons.arrow_forward_rounded)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          const SizedBox(height: 18),
          if (!_searched) const _EmptyState(text: 'Начни поиск интересной статьи Wikipedia.'),
          if (_loading) const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
          if (_searched && !_loading && state.searchResults.isEmpty) const _EmptyState(text: 'Ничего не найдено. Попробуй другой запрос.'),
          if (!_loading)
            for (final article in state.searchResults)
              ArticleTile(
                article: article,
                onTap: () => state.openArticle(article, addToHistory: true),
              ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(children: [
        Icon(Icons.manage_search_rounded, size: 62, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 12),
        Text(text, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
      ]),
    );
  }
}
