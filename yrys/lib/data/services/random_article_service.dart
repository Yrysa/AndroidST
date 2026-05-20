// made by Yrysa
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exception.dart';

class RandomArticleService {
  final http.Client _client;

  RandomArticleService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, Object?>> fetchRandomArticleJson({required String host}) async {
    return _getJson(Uri.https(host, AppConstants.randomArticlePath));
  }

  Future<Map<String, Object?>> fetchSummaryByTitle({required String host, required String title}) async {
    return _getJson(Uri.https(host, '/api/rest_v1/page/summary/$title'));
  }

  Future<List<Map<String, Object?>>> searchArticles({required String host, required String query}) async {
    final uri = Uri.https(host, '/w/api.php', {
      'action': 'query',
      'format': 'json',
      'origin': '*',
      'generator': 'search',
      'gsrsearch': query,
      'gsrlimit': '12',
      'prop': 'pageimages|extracts|info',
      'exintro': '1',
      'explaintext': '1',
      'inprop': 'url',
      'pithumbsize': '700',
    });

    final json = await _getJson(uri);
    final queryMap = json['query'];
    if (queryMap is! Map<String, Object?>) return <Map<String, Object?>>[];
    final pages = queryMap['pages'];
    if (pages is! Map<String, Object?>) return <Map<String, Object?>>[];

    return pages.values.whereType<Map<String, Object?>>().toList()
      ..sort((a, b) => (a['index'] as int? ?? 0).compareTo(b['index'] as int? ?? 0));
  }

  Future<List<Map<String, Object?>>> searchSimilarTitles({required String host, required String query}) async {
    final uri = Uri.https(host, '/w/api.php', {
      'action': 'query',
      'format': 'json',
      'origin': '*',
      'list': 'search',
      'srsearch': query,
      'srlimit': '5',
    });
    final json = await _getJson(uri);
    final queryMap = json['query'];
    final list = queryMap is Map<String, Object?> ? queryMap['search'] : null;
    return list is List ? list.whereType<Map<String, Object?>>().toList() : <Map<String, Object?>>[];
  }

  Future<Map<String, Object?>> _getJson(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 404) throw AppException.notFound();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AppException.server(response.statusCode);
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, Object?>) throw AppException.invalidData();
      return decoded;
    } on AppException {
      rethrow;
    } on SocketException {
      throw AppException.noInternet();
    } on TimeoutException {
      throw AppException.timeout();
    } on FormatException {
      throw AppException.invalidData();
    } catch (_) {
      throw AppException.unknown();
    }
  }
}
