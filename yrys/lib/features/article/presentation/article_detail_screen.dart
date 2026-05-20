// made by Yrysa
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/wiki_state_scope.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/summary.dart';
import 'widgets/article_card.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Summary article;

  const ArticleDetailScreen({super.key, required this.article});

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: article.url));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ссылка скопирована')));
    }
  }

  Future<void> _share() async {
    await Share.share('Посмотри интересную статью: ${article.titles.normalized} — ${article.url}');
  }

  @override
  Widget build(BuildContext context) {
    final state = WikiStateScope.of(context);
    final isFavorite = state.favorites.any((item) => item.url == article.url);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(article.titles.normalized, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () => _showActions(context, state, isFavorite),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [AppColors.darkBackgroundTop, AppColors.darkBackgroundBottom]
                : const [AppColors.lightBackgroundTop, AppColors.lightBackgroundBottom],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            ArticleCard(article: article, fontSize: state.readingFontSize, compact: state.readingMode),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => state.toggleFavorite(article),
              icon: Icon(isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
              label: Text(isFavorite ? 'В избранном' : 'Добавить в избранное'),
            ),
          ],
        ),
      ),
    );
  }

  void _showActions(BuildContext context, dynamic state, bool isFavorite) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(leading: const Icon(Icons.open_in_new_rounded), title: const Text('Открыть Wikipedia'), onTap: () { Navigator.pop(context); _openUrl(article.url); }),
              ListTile(leading: const Icon(Icons.link_rounded), title: const Text('Скопировать ссылку'), onTap: () { Navigator.pop(context); _copy(context); }),
              ListTile(leading: const Icon(Icons.ios_share_rounded), title: const Text('Поделиться'), onTap: () { Navigator.pop(context); _share(); }),
              ListTile(leading: Icon(isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded), title: Text(isFavorite ? 'Убрать из избранного' : 'Добавить в избранное'), onTap: () { Navigator.pop(context); state.toggleFavorite(article); }),
              ListTile(leading: const Icon(Icons.text_increase_rounded), title: const Text('Увеличить текст'), onTap: () { Navigator.pop(context); state.increaseFont(); }),
              ListTile(leading: const Icon(Icons.text_decrease_rounded), title: const Text('Уменьшить текст'), onTap: () { Navigator.pop(context); state.decreaseFont(); }),
              ListTile(leading: const Icon(Icons.menu_book_rounded), title: const Text('Режим чтения'), onTap: () { Navigator.pop(context); state.toggleReadingMode(); }),
              ListTile(leading: const Icon(Icons.code_rounded), title: const Text('GitHub автора'), onTap: () { Navigator.pop(context); _openUrl(AppConstants.githubUrl); }),
            ],
          ),
        ),
      ),
    );
  }
}
