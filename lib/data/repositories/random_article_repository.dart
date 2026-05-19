// made by Yrysa
import '../../models/summary.dart';
import '../services/random_article_service.dart';

class RandomArticleRepository {
  final RandomArticleService service;

  RandomArticleRepository({RandomArticleService? service})
      : service = service ?? RandomArticleService();

  Future<Summary> getRandomArticle() async {
    final json = await service.fetchRandomArticle();
    return Summary.fromJson(json);
  }
}
