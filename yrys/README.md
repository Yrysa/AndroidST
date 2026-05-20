# Yrysa Wiki Reader

**Yrysa Wiki Reader 2.82.47** — Flutter Wiki Discover app для открытия, чтения, сохранения и обсуждения статей Wikipedia.

**Автор:** Yrysa  
**GitHub:** https://github.com/Yrysa

## Что реализовано

- Branded splash screen: `Yrysa Wiki Reader`, `made by Yrysa`, `github.com/Yrysa`, `Powered by Wikipedia`.
- Чистый главный экран Discover без перегруза.
- Действия статьи вынесены в меню `три точки` / bottom sheet.
- История и избранное открывают полноценный экран статьи и работают оффлайн.
- Отдельная вкладка `Статья дня`.
- Поиск Wikipedia.
- Выбор языка Wikipedia: RU / EN / KK.
- MVP выбора языка приложения: RU / EN / KK в настройках.
- Тёмная тема.
- Настройки с версией `Yrysa Wiki Reader 2.82.47`.
- Профиль, локальный вход, локальная регистрация и гостевой режим.
- Локальные друзья и MVP-чат без backend.
- Копирование ссылки, поделиться, открыть Wikipedia, GitHub автора.
- Режим чтения и изменение размера текста.
- Категории, статья дня, статистика, достижения.

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
dart format .
flutter analyze
flutter test
flutter run
```

Для Chrome:

```bash
flutter run -d chrome
```

## Структура

```text
lib/
  app/
  core/
  data/
  features/
    article/
    day/
    favorites/
    history/
    profile/
    saved/
    search/
    settings/
    social/
    splash/
```

## Автор

Made by **Yrysa**  
GitHub: https://github.com/Yrysa
