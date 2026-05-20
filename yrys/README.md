# Yrysa Wiki Reader

**Yrysa Wiki Reader** — полноценное Flutter-приложение формата Wiki Discover app для изучения случайных и найденных статей Wikipedia.

**Автор:** Yrysa  
**GitHub:** https://github.com/Yrysa

## Возможности

- Премиальный splash screen с анимированным кольцом, `made by Yrysa` и GitHub автора.
- Onboarding при первом запуске.
- Случайные статьи Wikipedia.
- Выбор языка Wikipedia: Русский, English, Қазақша.
- Категории: Наука, Космос, IT, История, География, Люди, Животные, Игры.
- Статья дня, которая сохраняется на текущий день.
- Избранное с сохранением после перезапуска.
- История последних 20 статей с оффлайн-доступом.
- Поиск статей Wikipedia.
- Похожие статьи.
- Случайный факт из статьи.
- Мини-викторина по статье.
- Режим чтения с изменением размера текста.
- Свайп вверх для загрузки новой статьи.
- Копирование ссылки.
- Поделиться статьёй через приложения телефона.
- Статистика чтения.
- Достижения.
- Настройки: язык, тема, очистка истории, очистка избранного, GitHub автора, версия.
- Светлая и тёмная тема.

## Технологии

- Flutter
- Dart
- Material 3
- http
- shared_preferences
- share_plus
- url_launcher

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
    wiki_app_state.dart
    wiki_state_scope.dart
    main_navigation.dart
  core/
    constants/
    errors/
    storage/
    theme/
  data/
    models/
    repositories/
    services/
  features/
    article/
    common/
    favorites/
    history/
    onboarding/
    search/
    settings/
    splash/
```

## Автор

Made by **Yrysa**  
GitHub: https://github.com/Yrysa
