// made by Yrysa
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/wiki_state_scope.dart';
import '../../core/theme/app_colors.dart';
import '../article/presentation/widgets/article_card.dart';

class ArticleDayScreen extends StatelessWidget {
  const ArticleDayScreen({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final state = WikiStateScope.of(context);
    final article = state.articleOfDay;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Статья дня')),
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
        child: article == null
            ? Center(
                child: FilledButton.icon(
                  onPressed: state.loadArticleOfDay,
                  icon: const Icon(Icons.today_rounded),
                  label: const Text('Загрузить статью дня'),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  ArticleCard(article: article, fontSize: state.readingFontSize),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: () => state.toggleFavorite(article),
                        icon: const Icon(Icons.favorite_border_rounded),
                        label: const Text('Добавить в избранное'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _open(article.url),
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: const Text('Открыть Wikipedia'),
                      ),
                      IconButton.filledTonal(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: article.url));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ссылка скопирована')));
                          }
                        },
                        icon: const Icon(Icons.link_rounded),
                      ),
                      IconButton.filledTonal(
                        onPressed: () => Share.share('Посмотри интересную статью: ${article.titles.normalized} — ${article.url}'),
                        icon: const Icon(Icons.ios_share_rounded),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
