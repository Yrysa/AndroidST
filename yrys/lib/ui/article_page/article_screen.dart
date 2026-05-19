// made by Yrysa
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/services/random_article_service.dart';
import '../../summary.dart';
import 'article_view.dart';
import 'owner_loading_view.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final RandomArticleService _service = RandomArticleService();
  Summary? _summary;
  String? _error;
  bool _isLoading = true;

  static final Uri _githubUri = Uri.parse('https://github.com/Yrysa');

  @override
  void initState() {
    super.initState();
    loadRandomArticle();
  }

  Future<void> loadRandomArticle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final summary = await _service.fetchRandomArticle();
      if (!mounted) return;
      setState(() {
        _summary = summary;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> openUrl(Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось открыть ссылку: $uri')),
      );
    }
  }

  Future<void> openArticle() async {
    final url = _summary?.url;
    if (url == null || url.isEmpty) return;

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));

    if (!mounted) return;
    setState(() => _isLoading = false);
    await openUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yrysa Wiki Reader'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'GitHub Yrysa',
            onPressed: () => openUrl(_githubUri),
            icon: const Icon(Icons.code_rounded),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _isLoading
            ? const OwnerLoadingView()
            : ArticleView(
                summary: _summary,
                error: _error,
                onRetry: loadRandomArticle,
                onNext: loadRandomArticle,
                onOpenWiki: openArticle,
                onOpenGithub: () => openUrl(_githubUri),
              ),
      ),
    );
  }
}
