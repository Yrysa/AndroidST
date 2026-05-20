# Yrysa Wiki Reader

Премиальное Flutter-приложение для просмотра случайных статей Wikipedia.

**Автор:** Yrysa  
**GitHub:** https://github.com/Yrysa

## Возможности

- Загрузка случайных статей Wikipedia.
- Премиальный Material 3 интерфейс.
- Светлая и тёмная тема.
- Градиентный фон и glassmorphism-карточки.
- Hero image статьи с fallback-состоянием.
- Skeleton/shimmer-style загрузка.
- Pull-to-refresh для новой статьи.
- Кнопки: следующая статья, открыть Wikipedia, скопировать ссылку, поделиться.
- Локальная история последних статей в памяти приложения.
- Понятные ошибки: нет интернета, timeout, ошибка Wikipedia, статья не найдена.
- Авторский блок `made by Yrysa` и ссылка на GitHub.

## Технологии

- Flutter
- Dart
- Material 3
- http
- url_launcher
- share_plus

## Запуск

```bash
cd yrys
flutter pub get
flutter analyze
flutter test
flutter run
```

Для запуска в Chrome:

```bash
flutter run -d chrome
```

## Структура проекта

```text
lib/
  main.dart
  app/
    yrysa_wiki_app.dart
  core/
    theme/
      app_theme.dart
      app_colors.dart
      app_text_styles.dart
    constants/
      app_constants.dart
    errors/
      app_exception.dart
  data/
    models/
      summary.dart
      image_file.dart
      titles_set.dart
    services/
      random_article_service.dart
    repositories/
      article_repository.dart
  features/
    article/
      presentation/
        article_screen.dart
        widgets/
          article_content.dart
          article_card.dart
          article_actions.dart
          article_image.dart
          error_view.dart
          loading_view.dart
```

## Автор

Made by **Yrysa**  
GitHub: https://github.com/Yrysa
