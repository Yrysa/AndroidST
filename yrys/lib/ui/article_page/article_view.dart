// made by Yrysa
import 'package:flutter/material.dart';

import '../../summary.dart';
import 'article_content.dart';
import 'error_view.dart';

class ArticleView extends StatelessWidget {
  final Summary? summary;
  final String? error;
  final VoidCallback onRetry;
  final VoidCallback onNext;
  final VoidCallback onOpenWiki;
  final VoidCallback onOpenGithub;

  const ArticleView({
    super.key,
    required this.summary,
    required this.error,
    required this.onRetry,
    required this.onNext,
    required this.onOpenWiki,
    required this.onOpenGithub,
  });

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return ErrorView(message: error!, onRetry: onRetry);
    }

    final article = summary;
    if (article == null) {
      return ErrorView(message: 'Статья не найдена', onRetry: onRetry);
    }

    return ArticleContent(
      summary: article,
      onNext: onNext,
      onOpenWiki: onOpenWiki,
      onOpenGithub: onOpenGithub,
    );
  }
}
