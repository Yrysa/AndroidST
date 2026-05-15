import 'package:dio/dio.dart';

class RandomArticleService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://en.wikipedia.org/api/rest_v1/page/random',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<Map<String, dynamic>> fetchRandomArticle() async {
    try {
      final uri = '/summary';

      final res = await _dio.get(uri);

      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}