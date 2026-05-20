// made by Yrysa
import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exception.dart';
import '../models/summary.dart';
import '../services/random_article_service.dart';

class ArticleRepository {
  final RandomArticleService _service;
  final List<Summary> _history = <Summary>[];

  ArticleRepository({RandomArticleService? service}) : _service = service ?? RandomArticleService();

  List<Summary> get history => List<Summary>.unmodifiable(_history);

  Future<Summary> getRandomArticle() async {
    final json = await _service.fetchRandomArticleJson();
    final summary = Summary.fromJson(json);

    if (!summary.hasUrl || summary.titles.normalized.trim().isEmpty) {
      throw AppException.invalidData();
    }

    _addToHistory(summary);
    return summary;
  }

  void _addToHistory(Summary summary) {
    _history.removeWhere((item) => item.url == summary.url);
    _history.insert(0, summary);
    if (_history.length > AppConstants.historyLimit) {
      _history.removeRange(AppConstants.historyLimit, _history.length);
    }
  }
}
