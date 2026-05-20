// made by Yrysa
class AppConstants {
  const AppConstants._();

  static const String appName = 'Yrysa Wiki Reader';
  static const String author = 'Yrysa';
  static const String ownerLabel = 'made by Yrysa';
  static const String githubUrl = 'https://github.com/Yrysa';
  static const String wikipediaHost = 'ru.wikipedia.org';
  static const String randomArticlePath = '/api/rest_v1/page/random/summary';
  static const Duration apiTimeout = Duration(seconds: 10);
  static const int historyLimit = 8;
}
