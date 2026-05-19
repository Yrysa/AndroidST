// made by Yrysa
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../random_article/cubits/random_article_cubit.dart';
import 'article_view.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticleCubit(),
      child: const ArticleView(),
    );
  }
}
