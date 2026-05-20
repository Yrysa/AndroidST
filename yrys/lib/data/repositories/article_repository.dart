// made by Yrysa
import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exception.dart';
import '../models/image_file.dart';
import '../models/summary.dart';
import '../models/titles_set.dart';
import '../services/random_article_service.dart';

class ArticleRepository {
  final RandomArticleService _service;

  ArticleRepository({RandomArticleService? service}) : _service = service ?? RandomArticleService();

  Future<Summary> getRandomArticle({required String host}) async {
    final json = await _service.fetchRandomArticleJson(host: host);
    return _summaryFromApi(json);
  }

  Future<Summary> getArticleByTitle({required String host, required String title}) async {
    final json = await _service.fetchSummaryByTitle(host: host, title: title);
    return _summaryFromApi(json);
  }

  Future<Summary> getCategoryArticle({required String host, required String category}) async {
    final keyword = _categoryKeywords[category]?.first ?? category;
    final results = await searchArticles(host: host, query: keyword);
    if (results.isEmpty) return getRandomArticle(host: host);
    return results.first;
  }

  Future<List<Summary>> searchArticles({required String host, required String query}) async {
    if (query.trim().isEmpty) return <Summary>[];
    final pages = await _service.searchArticles(host: host, query: query.trim());
    return pages.map(_summaryFromSearchPage).where((item) => item.hasUrl).toList();
  }

  Future<List<Summary>> getSimilarArticles({required String host, required Summary article}) async {
    final query = article.description?.trim().isNotEmpty == true ? article.description! : article.titles.normalized;
    final results = await _service.searchSimilarTitles(host: host, query: query);
    final summaries = <Summary>[];
    for (final item in results) {
      final title = item['title'] as String?;
      if (title == null || title == article.titles.normalized) continue;
      try {
        summaries.add(await getArticleByTitle(host: host, title: title));
      } catch (_) {
        continue;
      }
    }
    return summaries.take(4).toList();
  }

  Summary _summaryFromApi(Map<String, Object?> json) {
    final summary = Summary.fromJson(json);
    if (!summary.hasUrl || summary.titles.normalized.trim().isEmpty) {
      throw AppException.invalidData();
    }
    return summary;
  }

  Summary _summaryFromSearchPage(Map<String, Object?> page) {
    final title = page['title'] as String? ?? 'Без названия';
    final fullUrl = page['fullurl'] as String? ?? '';
    final extract = page['extract'] as String? ?? 'Описание недоступно.';
    final thumbnail = page['thumbnail'];
    final pageId = page['pageid'] as int? ?? 0;

    return Summary(
      titles: TitlesSet(canonical: title, normalized: title, display: title),
      pageId: pageId,
      extract: extract,
      extractHtml: '',
      lang: 'ru',
      dir: 'ltr',
      url: fullUrl,
      description: extract.length > 120 ? '${extract.substring(0, 117)}...' : extract,
      thumbnail: thumbnail is Map<String, Object?> ? ImageFile.fromJson(thumbnail) : null,
      originalImage: null,
    );
  }

  static const Map<String, List<String>> _categoryKeywords = {
    'Наука': ['наука', 'физика', 'биология', 'химия'],
    'Космос': ['космос', 'галактика', 'планета', 'звезда'],
    'IT': ['информационные технологии', 'программирование', 'компьютер', 'интернет'],
    'История': ['история', 'древний мир', 'средневековье', 'война'],
    'География': ['география', 'страна', 'город', 'континент'],
    'Люди': ['биография', 'учёный', 'писатель', 'изобретатель'],
    'Животные': ['животные', 'млекопитающие', 'птицы', 'рыбы'],
    'Игры': ['игра', 'видеоигра', 'настольная игра', 'спорт'],
  };

  static List<String> get categories => _categoryKeywords.keys.toList();
}
