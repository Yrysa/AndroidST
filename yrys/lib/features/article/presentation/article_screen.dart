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
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Случайный факт'),
        content: Text(article.shortFact),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Понятно'))],
      ),
    );
  }

  void _showQuiz(BuildContext context, Summary article) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Мини-викторина'),
        content: Text('1. Как называется статья?\nОтвет: ${article.titles.normalized}\n\n2. К какой теме она относится?\nПодсказка: ${article.description ?? 'прочитай описание статьи'}\n\n3. Какой главный факт ты запомнил?'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Готово'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = WikiStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: state.readingMode
          ? null
          : AppBar(
              title: const Text(AppConstants.appName),
              actions: [
                IconButton(
                  tooltip: 'GitHub автора',
                  onPressed: () => _openUrl(context, AppConstants.githubUrl),
                  icon: const Icon(Icons.code_rounded),
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
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: state.loadArticle,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if ((details.primaryVelocity ?? 0) < -260) state.loadArticle();
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _buildBody(context, state),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WikiAppState state) {
    if (state.isLoading) return const LoadingView(key: ValueKey('loading'));
    final error = state.error;
    if (error != null) {
      return ErrorView(key: const ValueKey('error'), message: error.message, onRetry: state.loadArticle);
    }
    final article = state.currentArticle;
    if (article == null) {
      return ErrorView(key: const ValueKey('not-found'), message: AppException.notFound().message, onRetry: state.loadArticle);
    }
    return ArticleContent(
      key: ValueKey(article.url),
      article: article,
      history: state.history,
      articleOfDay: state.articleOfDay,
      categories: ArticleRepository.categories,
      similarArticles: state.similarArticles,
      isFavorite: state.isFavorite,
      readingFontSize: state.readingFontSize,
      readingMode: state.readingMode,
      onNext: state.loadArticle,
      onOpenWikipedia: () => _openUrl(context, article.url),
      onOpenGithub: () => _openUrl(context, AppConstants.githubUrl),
      onCopyLink: () => _copyLink(context, article),
      onShare: () => _shareArticle(article),
      onFavorite: state.toggleFavorite,
      onCategory: state.loadCategory,
      onOpenArticle: (item) => state.openArticle(item, addToHistory: true),
      onShowFact: () => _showFact(context, article),
      onQuiz: () => _showQuiz(context, article),
      onIncreaseFont: state.increaseFont,
      onDecreaseFont: state.decreaseFont,
      onToggleReadingMode: state.toggleReadingMode,
    );
  }
}
