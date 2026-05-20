// made by Yrysa
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/wiki_app_state.dart';
import '../../app/wiki_state_scope.dart';
import '../../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _openGithub() async {
    await launchUrl(Uri.parse(AppConstants.githubUrl), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final state = WikiStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text('Wikipedia', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final language in WikiLanguage.values)
            RadioListTile<WikiLanguage>(
              title: Text(language.title),
              subtitle: Text(language.host),
              value: language,
              groupValue: state.language,
              onChanged: (value) {
                if (value != null) state.setLanguage(value);
              },
            ),
          const Divider(height: 28),
          SwitchListTile(
            title: const Text('Тёмная тема'),
            value: state.themeMode == ThemeMode.dark,
            onChanged: (value) => state.setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
          ),
          SwitchListTile(
            title: const Text('Ежедневное напоминание'),
            subtitle: const Text('Прочитай одну интересную статью сегодня'),
            value: state.reminderEnabled,
            onChanged: state.setReminder,
          ),
          const Divider(height: 28),
          _StatsCard(state: state),
          const SizedBox(height: 12),
          _AchievementsCard(state: state),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.history_rounded),
            title: const Text('Очистить историю'),
            onTap: state.clearHistory,
          ),
          ListTile(
            leading: const Icon(Icons.favorite_rounded),
            title: const Text('Очистить избранное'),
            onTap: state.clearFavorites,
          ),
          ListTile(
            leading: const Icon(Icons.code_rounded),
            title: const Text('Открыть GitHub автора'),
            subtitle: const Text(AppConstants.githubUrl),
            onTap: _openGithub,
          ),
          const AboutListTile(
            icon: Icon(Icons.info_outline_rounded),
            applicationName: AppConstants.appName,
            applicationVersion: '1.1.0',
            applicationLegalese: 'made by Yrysa',
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final WikiAppState state;
  const _StatsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Статистика чтения', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Text('Всего просмотрено: ${state.totalRead}'),
          Text('Сегодня просмотрено: ${state.todayRead}'),
          Text('В избранном: ${state.favorites.length}'),
          Text('Последняя статья: ${state.lastArticleTitle.isEmpty ? '—' : state.lastArticleTitle}'),
        ]),
      ),
    );
  }
}

class _AchievementsCard extends StatelessWidget {
  final WikiAppState state;
  const _AchievementsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Достижения', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          for (final achievement in state.achievements)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(achievement.unlocked ? Icons.emoji_events_rounded : Icons.lock_outline_rounded),
              title: Text(achievement.title),
              subtitle: Text(achievement.description),
            ),
        ]),
      ),
    );
  }
}
