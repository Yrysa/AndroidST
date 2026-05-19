// made by Yrysa
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/services/random_article_service.dart';
import 'summary.dart';

void main() {
  runApp(const YrysaWikiApp());
}

class YrysaWikiApp extends StatelessWidget {
  const YrysaWikiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yrysa Wiki Reader',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF7F4FF),
      ),
      home: const ArticleHomePage(),
    );
  }
}

class ArticleHomePage extends StatefulWidget {
  const ArticleHomePage({super.key});

  @override
  State<ArticleHomePage> createState() => _ArticleHomePageState();
}

class _ArticleHomePageState extends State<ArticleHomePage> {
  final RandomArticleService _service = RandomArticleService();
  Summary? _summary;
  String? _error;
  bool _isLoading = true;

  static final Uri _githubUri = Uri.parse('https://github.com/Yrysa');

  @override
  void initState() {
    super.initState();
    _loadRandomArticle();
  }

  Future<void> _loadRandomArticle() async {
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

  Future<void> _openUrl(Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось открыть ссылку: $uri')),
      );
    }
  }

  Future<void> _openArticle() async {
    final url = _summary?.url;
    if (url == null || url.isEmpty) return;

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));

    if (!mounted) return;
    setState(() => _isLoading = false);
    await _openUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yrysa Wiki Reader'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'GitHub Yrysa',
            onPressed: () => _openUrl(_githubUri),
            icon: const Icon(Icons.code_rounded),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _isLoading
            ? const OwnerLoadingView()
            : _error != null
                ? ErrorView(message: _error!, onRetry: _loadRandomArticle)
                : summary == null
                    ? ErrorView(message: 'Статья не найдена', onRetry: _loadRandomArticle)
                    : ArticleContent(
                        summary: summary,
                        onNext: _loadRandomArticle,
                        onOpenWiki: _openArticle,
                        onOpenGithub: () => _openUrl(_githubUri),
                      ),
      ),
    );
  }
}

class OwnerLoadingView extends StatelessWidget {
  const OwnerLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      key: ValueKey('loading'),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 22),
            Text(
              'made by Yrysa',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'GitHub: https://github.com/Yrysa',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Загрузка случайной статьи Wikipedia...',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('error'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 56),
            const SizedBox(height: 14),
            const Text(
              'Ошибка загрузки статьи',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Попробовать снова'),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleContent extends StatelessWidget {
  final Summary summary;
  final VoidCallback onNext;
  final VoidCallback onOpenWiki;
  final VoidCallback onOpenGithub;

  const ArticleContent({
    super.key,
    required this.summary,
    required this.onNext,
    required this.onOpenWiki,
    required this.onOpenGithub,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = summary.originalImage?.source ?? summary.thumbnail?.source;

    return ListView(
      key: const ValueKey('article'),
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified_rounded),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: onOpenGithub,
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            'made by Yrysa • github.com/Yrysa',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (imageUrl != null && imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                          height: 220,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 160,
                          child: Center(child: Icon(Icons.image_not_supported_rounded, size: 42)),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 18),
                Text(
                  summary.titles.normalized,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                if (summary.description != null && summary.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    summary.description!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
                const SizedBox(height: 14),
                Text(
                  summary.extract,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onNext,
                        icon: const Icon(Icons.shuffle_rounded),
                        label: const Text('Next Article'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onOpenWiki,
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: const Text('Open Wiki'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
