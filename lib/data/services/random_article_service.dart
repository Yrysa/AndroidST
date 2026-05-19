// made by Yrysa
import 'package:dio/dio.dart';

class RandomArticleService {
  final Dio _dio;

  RandomArticleService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Map<String, dynamic>> fetchRandomArticle() async {
    final uri = Uri.https(
      'ru.wikipedia.org',
      '/api/rest_v1/page/random/summary',
    );

    try {
      final response = await _dio.getUri(uri);
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (error) {
      throw Exception('Failed to load random article: ${error.message}');
    }
  }
}
