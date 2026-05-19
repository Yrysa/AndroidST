// made by Yrysa
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../summary.dart';

class RandomArticleService {
  final http.Client _client;

  RandomArticleService({http.Client? client}) : _client = client ?? http.Client();

  Future<Summary> fetchRandomArticle() async {
    final uri = Uri.https(
      'ru.wikipedia.org',
      '/api/rest_v1/page/random/summary',
    );

    try {
      final response = await _client.get(uri);

      if (response.statusCode != 200) {
        throw HttpException('Wikipedia returned status ${response.statusCode}');
      }

      final jsonMap = jsonDecode(response.body) as Map<String, Object?>;
      return Summary.fromJson(jsonMap);
    } on SocketException {
      throw const SocketException('Нет подключения к интернету');
    } on FormatException catch (error) {
      throw FormatException('Не удалось прочитать ответ Wikipedia: $error');
    }
  }
}
