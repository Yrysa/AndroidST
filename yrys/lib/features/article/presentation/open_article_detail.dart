// made by Yrysa
import 'package:flutter/material.dart';

import '../../../data/models/summary.dart';
import 'article_detail_screen.dart';

void openArticleDetail(BuildContext context, Summary article) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: article)),
  );
}
