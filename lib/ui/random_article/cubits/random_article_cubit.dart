// made by Yrysa
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/random_article_repository.dart';
import '../../../models/summary.dart';

sealed class ArticleState {
  const ArticleState();
}

class ArticleInitial extends ArticleState {
  const ArticleInitial();
}

class ArticleLoading extends ArticleState {
  const ArticleLoading();
}

class ArticleLoaded extends ArticleState {
  final Summary summary;

  const ArticleLoaded(this.summary);
}

class ArticleError extends ArticleState {
  final String message;

  const ArticleError(this.message);
}

class ArticleCubit extends Cubit<ArticleState> {
  final RandomArticleRepository repository;

  ArticleCubit({RandomArticleRepository? repository})
      : repository = repository ?? RandomArticleRepository(),
        super(const ArticleInitial()) {
    updateArticle();
  }

  Future<void> updateArticle() async {
    emit(const ArticleLoading());
    try {
      final summary = await repository.getRandomArticle();
      emit(ArticleLoaded(summary));
    } catch (error) {
      emit(ArticleError(error.toString()));
    }
  }
}
