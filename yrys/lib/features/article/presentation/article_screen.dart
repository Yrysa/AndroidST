// made by Yrysa
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/wiki_app_state.dart';
import '../../../app/wiki_state_scope.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/summary.dart';
import '../../../data/repositories/article_repository.dart';
import '../../social/social_storage.dart';
import 'widgets/article_content.dart';
import 'widgets/error_view.dart';
import 'widgets/loading_view.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) _showSnack(context, 'Не удалось открыть ссылку.');
  }

  Future<void> _copyLink(BuildContext context, Summary article) async {
    await Clipboard.setData(ClipboardData(text: article.url));
    if (context.mounted) _showSnack(context, 'Ссылка скопирована');
  }

  Future<void> _shareArticle(Summary article) async {
    await Share.share('Посмотри интересную статью: ${article.titles.normalized} — ${article.url}');
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showFact(BuildContext context, Summary article) {
    showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('Случайный факт'), content: Text(article.shortFact), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Понятно'))]));
  }

  void _showQuiz(BuildContext context, Summary article) {
    showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('Мини-викторина'), content: Text('1. Как называется статья?\nОтвет: ${article.titles.normalized}\n\n2. Какой главный факт описан?\nОтвет можно найти в тексте статьи.\n\n3. Открой Wikipedia и найди дополнительный факт.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Готово'))]));
  }

  Future<void> _showSendToFriend(BuildContext context, Summary article) async {
    final friends = await SocialStorage.loadFriends();
    if (!context.mounted) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(sheetContext).size.height * 0.74),
            child: friends.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(mainAxisSize: MainAxisSize.min, children: const [
                      Icon(Icons.group_off_rounded, size: 46),
                      SizedBox(height: 12),
                      Text('Сначала добавь друга во вкладке Соцсеть', textAlign: TextAlign.center),
                    ]),
                  )
                : ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                    children: [
                      Text('Отправить статью другу', style: Theme.of(sheetContext).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      for (final friend in friends)
                        ListTile(
                          leading: CircleAvatar(child: Text(friend['avatar'] ?? '🌍')),
                          title: Text(friend['nick'] ?? 'Друг'),
                          subtitle: Text(friend['status'] ?? ''),
                          onTap: () async {
                            await SocialStorage.sendArticleToFriend(friend: friend, article: article);
                            if (sheetContext.mounted) Navigator.pop(sheetContext);
                            if (context.mounted) _showSnack(context, 'Статья отправлена');
                          },
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void _showActions(BuildContext context, WikiAppState state, Summary article) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(sheetContext).size.height * 0.86),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 12),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ListTile(leading: const Icon(Icons.open_in_new_rounded), title: const Text('Открыть Wikipedia'), onTap: () { Navigator.pop(sheetContext); _openUrl(context, article.url); }),
                ListTile(leading: Icon(state.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded), title: Text(state.isFavorite ? 'Убрать из избранного' : 'Добавить в избранное'), onTap: () { Navigator.pop(sheetContext); state.toggleFavorite(); }),
                ListTile(leading: const Icon(Icons.link_rounded), title: const Text('Скопировать ссылку'), onTap: () { Navigator.pop(sheetContext); _copyLink(context, article); }),
                ListTile(leading: const Icon(Icons.ios_share_rounded), title: const Text('Поделиться'), onTap: () { Navigator.pop(sheetContext); _shareArticle(article); }),
                ListTile(leading: const Icon(Icons.text_increase_rounded), title: const Text('Увеличить текст'), onTap: () { Navigator.pop(sheetContext); state.increaseFont(); }),
                ListTile(leading: const Icon(Icons.text_decrease_rounded), title: const Text('Уменьшить текст'), onTap: () { Navigator.pop(sheetContext); state.decreaseFont(); }),
                ListTile(leading: const Icon(Icons.menu_book_rounded), title: const Text('Режим чтения'), onTap: () { Navigator.pop(sheetContext); state.toggleReadingMode(); }),
                ListTile(leading: const Icon(Icons.group_rounded), title: const Text('Отправить другу'), onTap: () { Navigator.pop(sheetContext); _showSendToFriend(context, article); }),
                ListTile(leading: const Icon(Icons.lightbulb_rounded), title: const Text('Случайный факт'), onTap: () { Navigator.pop(sheetContext); _showFact(context, article); }),
                ListTile(leading: const Icon(Icons.quiz_rounded), title: const Text('Проверить себя'), onTap: () { Navigator.pop(sheetContext); _showQuiz(context, article); }),
                ListTile(leading: const Icon(Icons.code_rounded), title: const Text('GitHub автора'), onTap: () { Navigator.pop(sheetContext); _openUrl(context, AppConstants.githubUrl); }),
              ]),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = WikiStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: state.readingMode ? null : AppBar(title: const Text(AppConstants.appName)),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: isDark ? const [AppColors.darkBackgroundTop, AppColors.darkBackgroundBottom] : const [AppColors.lightBackgroundTop, AppColors.lightBackgroundBottom])),
        child: SafeArea(child: RefreshIndicator(onRefresh: state.loadArticle, child: GestureDetector(onVerticalDragEnd: (details) { if ((details.primaryVelocity ?? 0) < -260) state.loadArticle(); }, child: AnimatedSwitcher(duration: const Duration(milliseconds: 350), child: _buildBody(context, state))))),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WikiAppState state) {
    if (state.isLoading) return const LoadingView(key: ValueKey('loading'));
    final error = state.error;
    if (error != null && state.currentArticle == null) return ErrorView(key: const ValueKey('error'), message: error.message, onRetry: state.loadArticle);
    final article = state.currentArticle;
    if (article == null) return ErrorView(key: const ValueKey('not-found'), message: AppException.notFound().message, onRetry: state.loadArticle);
    return ArticleContent(key: ValueKey(article.url), article: article, categories: ArticleRepository.categories, readingMode: state.readingMode, readingFontSize: state.readingFontSize, onNext: state.loadArticle, onMenu: () => _showActions(context, state, article), onCategory: state.loadCategory);
  }
}
