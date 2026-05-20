// made by Yrysa
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/summary.dart';
import '../../../data/repositories/article_repository.dart';
import 'widgets/article_content.dart';
import 'widgets/error_view.dart';
import 'widgets/loading_view.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final ArticleRepository _repository = ArticleRepository();
  Summary? _article;
  AppException? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticle();
  }

  Future<void> _loadArticle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final article = await _repository.getRandomArticle();
      if (!mounted) return;
      setState(() {
        _article = article;
        _isLoading = false;
      });
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = AppException.unknown();
        _isLoading = false;
      });
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      _showSnack('Не удалось открыть ссылку.');
    }
  }

  Future<void> _copyLink() async {
    final url = _article?.url;
    if (url == null || url.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: url));
    if (mounted) _showSnack('Ссылка скопирована.');
  }

  Future<void> _shareArticle() async {
    final article = _article;
    if (article == null || article.url.isEmpty) return;
    await Share.share('${article.titles.normalized}\n${article.url}');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: 'GitHub автора',
            onPressed: () => _openUrl(AppConstants.githubUrl),
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
            onRefresh: _loadArticle,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: _buildBody(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingView(key: ValueKey('loading'));
    }

    final error = _error;
    if (error != null) {
      return ErrorView(
        key: const ValueKey('error'),
        message: error.message,
        onRetry: _loadArticle,
      );
    }

    final article = _article;
    if (article == null) {
      return ErrorView(
        key: const ValueKey('not-found'),
        message: AppException.notFound().message,
        onRetry: _loadArticle,
      );
    }

    return ArticleContent(
      key: ValueKey(article.url),
      article: article,
      history: _repository.history,
      onNext: _loadArticle,
      onOpenWikipedia: () => _openUrl(article.url),
      onOpenGithub: () => _openUrl(AppConstants.githubUrl),
      onCopyLink: _copyLink,
      onShare: _shareArticle,
    );
  }
}
