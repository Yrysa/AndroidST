// made by Yrysa
import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/errors/app_exception.dart';
import '../core/storage/local_storage.dart';
import '../data/models/summary.dart';
import '../data/repositories/article_repository.dart';

class WikiLanguage {
  final String title;
  final String host;
  final String code;

  const WikiLanguage({required this.title, required this.host, required this.code});

  static const values = <WikiLanguage>[
    WikiLanguage(title: 'Русский', host: 'ru.wikipedia.org', code: 'ru'),
    WikiLanguage(title: 'English', host: 'en.wikipedia.org', code: 'en'),
    WikiLanguage(title: 'Қазақша', host: 'kk.wikipedia.org', code: 'kk'),
  ];

  static WikiLanguage byHost(String host) => values.firstWhere((item) => item.host == host, orElse: () => values.first);
}

class Achievement {
  final String title;
  final String description;
  final bool unlocked;

  const Achievement({required this.title, required this.description, required this.unlocked});
}

class WikiAppState extends ChangeNotifier {
  final LocalStorage storage;
  final ArticleRepository repository;

  WikiAppState({required this.storage, ArticleRepository? repository}) : repository = repository ?? ArticleRepository();

  bool initialized = false;
  bool onboardingCompleted = false;
  bool isLoading = true;
  bool reminderEnabled = false;
  ThemeMode themeMode = ThemeMode.system;
  WikiLanguage language = WikiLanguage.values.first;
  Summary? currentArticle;
  Summary? articleOfDay;
  AppException? error;
  double readingFontSize = 16;
  bool readingMode = false;

  final List<Summary> favorites = <Summary>[];
  final List<Summary> history = <Summary>[];
  final List<Summary> similarArticles = <Summary>[];
  final List<Summary> searchResults = <Summary>[];

  int totalRead = 0;
  int todayRead = 0;
  int streak = 0;
  String lastArticleTitle = '';

  String get host => language.host;
  bool get isFavorite => currentArticle != null && favorites.any((item) => item.url == currentArticle!.url);

  Future<void> initialize() async {
    onboardingCompleted = storage.getBool(LocalStorage.onboardingKey);
    language = WikiLanguage.byHost(storage.getString(LocalStorage.languageKey, fallback: WikiLanguage.values.first.host));
    themeMode = storage.getString(LocalStorage.themeKey, fallback: 'light') == 'dark' ? ThemeMode.dark : ThemeMode.light;
    reminderEnabled = storage.getBool(LocalStorage.reminderKey);
    totalRead = storage.getInt(LocalStorage.totalReadKey);
    todayRead = storage.getInt(LocalStorage.todayReadKey);
    streak = storage.getInt(LocalStorage.streakKey);
    lastArticleTitle = storage.getString(LocalStorage.lastArticleKey);
    _loadLists();
    _rollTodayIfNeeded();
    _updateStreak();
    await loadInitialArticle();
    initialized = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    onboardingCompleted = true;
    await storage.setBool(LocalStorage.onboardingKey, true);
    notifyListeners();
  }

  Future<void> loadInitialArticle() async {
    final started = DateTime.now();
    await loadArticle(showLoading: true);
    final elapsed = DateTime.now().difference(started);
    if (elapsed < const Duration(milliseconds: 1600)) {
      await Future<void>.delayed(const Duration(milliseconds: 1600) - elapsed);
    }
    await loadArticleOfDay();
  }

  Future<void> loadArticle({bool showLoading = true}) async {
    if (showLoading) {
      isLoading = true;
      error = null;
      notifyListeners();
    }
    try {
      final article = await repository.getRandomArticle(host: host);
      await openArticle(article, addToHistory: true);
      error = null;
    } on AppException catch (e) {
      error = e;
    } catch (_) {
      error = AppException.unknown();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> openArticle(Summary article, {bool addToHistory = true}) async {
    currentArticle = article;
    lastArticleTitle = article.titles.normalized;
    await storage.setString(LocalStorage.lastArticleKey, lastArticleTitle);
    if (addToHistory) await _addHistory(article);
    await _incrementReadStats();
    _loadSimilar(article);
    notifyListeners();
  }

  Future<void> loadCategory(String category) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final article = await repository.getCategoryArticle(host: host, category: category);
      await openArticle(article);
    } on AppException catch (e) {
      error = e;
    } catch (_) {
      error = AppException.unknown();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadArticleOfDay() async {
    final today = _todayKey();
    final cachedDate = storage.getString(LocalStorage.dayArticleDateKey);
    final cachedMap = storage.getJsonMap(LocalStorage.dayArticleKey);
    if (cachedDate == today && cachedMap != null) {
      articleOfDay = Summary.fromStorage(cachedMap);
      notifyListeners();
      return;
    }
    try {
      articleOfDay = await repository.getRandomArticle(host: host);
      await storage.setString(LocalStorage.dayArticleDateKey, today);
      await storage.setJsonMap(LocalStorage.dayArticleKey, articleOfDay!.toJson());
      notifyListeners();
    } catch (_) {}
  }

  Future<void> search(String query) async {
    searchResults.clear();
    if (query.trim().isEmpty) {
      notifyListeners();
      return;
    }
    try {
      searchResults.addAll(await repository.searchArticles(host: host, query: query));
    } catch (_) {}
    notifyListeners();
  }

  Future<void> setLanguage(WikiLanguage value) async {
    language = value;
    await storage.setString(LocalStorage.languageKey, value.host);
    await loadArticle(showLoading: true);
  }

  Future<void> setThemeMode(ThemeMode value) async {
    themeMode = value;
    await storage.setString(LocalStorage.themeKey, value == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> toggleFavorite([Summary? article]) async {
    final item = article ?? currentArticle;
    if (item == null) return;
    final index = favorites.indexWhere((fav) => fav.url == item.url);
    if (index >= 0) {
      favorites.removeAt(index);
    } else {
      favorites.insert(0, item);
    }
    await storage.setJsonList(LocalStorage.favoritesKey, favorites.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    favorites.clear();
    await storage.setJsonList(LocalStorage.favoritesKey, const <Map<String, Object?>>[]);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    history.clear();
    await storage.setJsonList(LocalStorage.historyKey, const <Map<String, Object?>>[]);
    notifyListeners();
  }

  Future<void> setReminder(bool value) async {
    reminderEnabled = value;
    await storage.setBool(LocalStorage.reminderKey, value);
    notifyListeners();
  }

  void increaseFont() {
    readingFontSize = (readingFontSize + 1).clamp(14, 24).toDouble();
    notifyListeners();
  }

  void decreaseFont() {
    readingFontSize = (readingFontSize - 1).clamp(14, 24).toDouble();
    notifyListeners();
  }

  void toggleReadingMode() {
    readingMode = !readingMode;
    notifyListeners();
  }

  List<Achievement> get achievements => [
        Achievement(title: 'Первая статья', description: 'Открыл первую статью', unlocked: totalRead >= 1),
        Achievement(title: 'Любознательный', description: 'Прочитал 10 статей', unlocked: totalRead >= 10),
        Achievement(title: 'Исследователь', description: 'Прочитал 50 статей', unlocked: totalRead >= 50),
        Achievement(title: 'Коллекционер', description: 'Добавил 10 статей в избранное', unlocked: favorites.length >= 10),
        Achievement(title: 'Серия', description: 'Заходил 3 дня подряд', unlocked: streak >= 3),
      ];

  void _loadLists() {
    favorites
      ..clear()
      ..addAll(storage.getJsonList(LocalStorage.favoritesKey).map(Summary.fromStorage));
    history
      ..clear()
      ..addAll(storage.getJsonList(LocalStorage.historyKey).map(Summary.fromStorage));
  }

  Future<void> _addHistory(Summary article) async {
    history.removeWhere((item) => item.url == article.url);
    history.insert(0, article);
    if (history.length > 20) history.removeRange(20, history.length);
    await storage.setJsonList(LocalStorage.historyKey, history.map((e) => e.toJson()).toList());
  }

  Future<void> _incrementReadStats() async {
    _rollTodayIfNeeded();
    totalRead++;
    todayRead++;
    await storage.setInt(LocalStorage.totalReadKey, totalRead);
    await storage.setInt(LocalStorage.todayReadKey, todayRead);
  }

  void _rollTodayIfNeeded() {
    final today = _todayKey();
    if (storage.getString(LocalStorage.todayDateKey) != today) {
      todayRead = 0;
      storage.setString(LocalStorage.todayDateKey, today);
      storage.setInt(LocalStorage.todayReadKey, todayRead);
    }
  }

  void _updateStreak() {
    final today = _todayKey();
    final last = storage.getString(LocalStorage.lastOpenDateKey);
    if (last == today) return;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayKey = _dateKey(yesterday);
    streak = last == yesterdayKey ? streak + 1 : 1;
    storage.setInt(LocalStorage.streakKey, streak);
    storage.setString(LocalStorage.lastOpenDateKey, today);
  }

  Future<void> _loadSimilar(Summary article) async {
    similarArticles.clear();
    notifyListeners();
    try {
      similarArticles.addAll(await repository.getSimilarArticles(host: host, article: article));
      notifyListeners();
    } catch (_) {}
  }

  String _todayKey() => _dateKey(DateTime.now());
  String _dateKey(DateTime date) => '${date.year}-${date.month}-${date.day}';
}
