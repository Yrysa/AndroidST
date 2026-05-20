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

  Future<Map<String, Object?>> fetchRandomArticleJson() async {
    final uri = Uri.https(AppConstants.wikipediaHost, AppConstants.randomArticlePath);

    try {
      final response = await _client.get(uri).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 404) {
        throw AppException.notFound();
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AppException.server(response.statusCode);
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, Object?>) {
        throw AppException.invalidData();
      }
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
