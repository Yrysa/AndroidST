// made by Yrysa
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../random_article/cubits/random_article_cubit.dart';
import 'article_page.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCubit, ArticleState>(
      builder: (context, state) {
        return switch (state) {
          ArticleInitial() => const Center(child: Text('made by Yrysa')),
          ArticleLoading() => const Center(child: CircularProgressIndicator()),
          ArticleError(message: final message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ArticleLoaded(summary: final summary) => ArticlePage(
              summary: summary,
              nextArticle: context.read<ArticleCubit>().updateArticle,
            ),
        };
      },
    );
  }
}
