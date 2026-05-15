import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki_reader/data/repositories/random_article_repository.dart';
import 'package:wiki_reader/summary.dart';

class ArticleState {}

class ArticleIntial extends ArticleState {}

class ArticleLoading extends ArticleState {}

class ArticleLoaded extends ArticleState {
  final Summary summary;
ArticleLoaded (this.summary);}

class ArticleError extends ArticleState {
final Exception error;
ArticleError(this.error);}






class ArticleCubit extends Cubit<ArticleState> {
  final _repo = RandomArticleRepository();
  ArticleCubit() : super(ArticleIntial());
  void updateArticle() async {
    emit(ArticleLoading());
    try {
      final summary = 
      await _repo.getRandomArticle();
      emit(ArticleLoaded(summary));
    } on Exception catch (e) {
      emit(ArticleError(e));
    }
  }
}

