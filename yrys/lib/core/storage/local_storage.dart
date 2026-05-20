// made by Yrysa
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String onboardingKey = 'onboarding_completed';
  static const String languageKey = 'wiki_language';
  static const String themeKey = 'theme_mode';
  static const String favoritesKey = 'favorites';
  static const String historyKey = 'history';
  static const String totalReadKey = 'total_read';
  static const String todayReadKey = 'today_read';
  static const String todayDateKey = 'today_date';
  static const String lastArticleKey = 'last_article';
  static const String dayArticleKey = 'day_article';
  static const String dayArticleDateKey = 'day_article_date';
  static const String streakKey = 'streak';
  static const String lastOpenDateKey = 'last_open_date';
  static const String reminderKey = 'daily_reminder_enabled';

  final SharedPreferences _prefs;

  const LocalStorage(this._prefs);

  static Future<LocalStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorage(prefs);
  }

  bool getBool(String key, {bool fallback = false}) => _prefs.getBool(key) ?? fallback;
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  String getString(String key, {String fallback = ''}) => _prefs.getString(key) ?? fallback;
  Future<void> setString(String key, String value) => _prefs.setString(key, value);

  int getInt(String key, {int fallback = 0}) => _prefs.getInt(key) ?? fallback;
  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);

  List<Map<String, Object?>> getJsonList(String key) {
    final raw = _prefs.getStringList(key) ?? const <String>[];
    return raw
        .map((item) => jsonDecode(item))
        .whereType<Map<String, Object?>>()
        .toList();
  }

  Future<void> setJsonList(String key, List<Map<String, Object?>> values) {
    return _prefs.setStringList(key, values.map(jsonEncode).toList());
  }

  Map<String, Object?>? getJsonMap(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    return decoded is Map<String, Object?> ? decoded : null;
  }

  Future<void> setJsonMap(String key, Map<String, Object?> value) {
    return _prefs.setString(key, jsonEncode(value));
  }

  Future<void> remove(String key) => _prefs.remove(key);
}
