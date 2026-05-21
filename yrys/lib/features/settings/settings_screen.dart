// made by Yrysa
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/wiki_app_state.dart';
import '../../app/wiki_state_scope.dart';
import '../../core/constants/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appLanguage = 'ru';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _appLanguage = prefs.getString('app_language') ?? 'ru');
  }

  Future<void> _setAppLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', value);
    setState(() => _appLanguage = value);
  }

  Future<void> _clearLocalData(WikiAppState state) async {
    await state.clearHistory();
    await state.clearFavorites();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('wiki_friends');
    final chatKeys = prefs.getKeys().where((key) => key.startsWith('chat_')).toList();
    for (final key in chatKeys) {
      await prefs.remove(key);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Локальные данные очищены')));
    }
  }

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
          Text('Язык приложения', style: Theme.of(context).textTheme.titleMedium),
          RadioListTile<String>(title: const Text('Русский'), value: 'ru', groupValue: _appLanguage, onChanged: (v) => _setAppLanguage(v!)),
          RadioListTile<String>(title: const Text('English'), value: 'en', groupValue: _appLanguage, onChanged: (v) => _setAppLanguage(v!)),
          RadioListTile<String>(title: const Text('Қазақша'), value: 'kk', groupValue: _appLanguage, onChanged: (v) => _setAppLanguage(v!)),
          const Divider(height: 28),
          Text('Язык Wikipedia', style: Theme.of(context).textTheme.titleMedium),
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
          ListTile(leading: const Icon(Icons.history_rounded), title: const Text('Очистить историю'), onTap: state.clearHistory),
          ListTile(leading: const Icon(Icons.favorite_rounded), title: const Text('Очистить избранное'), onTap: state.clearFavorites),
          ListTile(leading: const Icon(Icons.cleaning_services_rounded), title: const Text('Очистить локальные данные'), onTap: () => _clearLocalData(state)),
          ListTile(leading: const Icon(Icons.code_rounded), title: const Text('Открыть GitHub автора'), subtitle: const Text(AppConstants.githubUrl), onTap: _openGithub),
          const AboutListTile(
            icon: Icon(Icons.info_outline_rounded),
            applicationName: AppConstants.appName,
            applicationVersion: '2.82.47',
            applicationLegalese: 'made by Yrysa • Powered by Wikipedia',
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Версия: Yrysa Wiki Reader 2.82.47', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
