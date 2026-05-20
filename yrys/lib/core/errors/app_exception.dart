// made by Yrysa
enum AppExceptionType { noInternet, timeout, server, notFound, invalidData, unknown }

class AppException implements Exception {
  final AppExceptionType type;
  final String message;

  const AppException(this.type, this.message);

  factory AppException.noInternet() => const AppException(AppExceptionType.noInternet, 'Нет подключения к интернету. Проверь сеть и попробуй снова.');
  factory AppException.timeout() => const AppException(AppExceptionType.timeout, 'Wikipedia слишком долго отвечает. Попробуй ещё раз.');
  factory AppException.server(int code) => AppException(AppExceptionType.server, 'Wikipedia временно недоступна. Код ответа: $code.');
  factory AppException.notFound() => const AppException(AppExceptionType.notFound, 'Статья не найдена. Попробуй загрузить другую.');
  factory AppException.invalidData() => const AppException(AppExceptionType.invalidData, 'Wikipedia вернула неполные данные. Загрузи другую статью.');
  factory AppException.unknown() => const AppException(AppExceptionType.unknown, 'Произошла неизвестная ошибка. Попробуй снова.');

  @override
  String toString() => message;
}
