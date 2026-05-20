// made by Yrysa
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/wiki_state_scope.dart';
import '../../core/constants/app_constants.dart';
import '../favorites/favorites_screen.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String> _user = const {
    'nick': 'Yrysa Guest',
    'email': 'guest@local.app',
    'status': 'Discover knowledge beautifully',
    'avatar': '🧠',
    'guest': 'true',
  };

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('wiki_user');
    if (raw != null) {
      final data = jsonDecode(raw);
      if (data is Map) {
        setState(() => _user = data.map((key, value) => MapEntry(key.toString(), value.toString())));
      }
    }
  }

  Future<void> _saveUser(Map<String, String> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wiki_user', jsonEncode(user));
    setState(() => _user = user);
  }

  void _openAuth({required bool register}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AuthScreen(
        register: register,
        onDone: _saveUser,
      ),
    ));
  }

  void _editProfile() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditProfileScreen(user: _user, onDone: _saveUser)));
  }

  Future<void> _openGithub() async {
    await launchUrl(Uri.parse(AppConstants.githubUrl), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final state = WikiStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(children: [
                CircleAvatar(radius: 42, child: Text(_user['avatar'] ?? '🧠', style: const TextStyle(fontSize: 34))),
                const SizedBox(height: 12),
                Text(_user['nick'] ?? 'Yrysa Guest', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                Text(_user['email'] ?? '', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(_user['status'] ?? '', textAlign: TextAlign.center),
                const SizedBox(height: 14),
                Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
                  FilledButton.icon(onPressed: _editProfile, icon: const Icon(Icons.edit_rounded), label: const Text('Редактировать')),
                  OutlinedButton.icon(onPressed: () => _openAuth(register: false), icon: const Icon(Icons.login_rounded), label: const Text('Войти')),
                  OutlinedButton.icon(onPressed: () => _openAuth(register: true), icon: const Icon(Icons.person_add_rounded), label: const Text('Регистрация')),
                ]),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Статистика', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Всего прочитано: ${state.totalRead}'),
                Text('Сегодня: ${state.todayRead}'),
                Text('Избранное: ${state.favorites.length}'),
                Text('Серия дней: ${state.streak}'),
                Text('Последняя статья: ${state.lastArticleTitle.isEmpty ? '—' : state.lastArticleTitle}'),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(leading: const Icon(Icons.favorite_rounded), title: const Text('Избранное'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()))),
          ListTile(leading: const Icon(Icons.history_rounded), title: const Text('История'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()))),
          ListTile(leading: const Icon(Icons.settings_rounded), title: const Text('Настройки'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
          ListTile(leading: const Icon(Icons.code_rounded), title: const Text('GitHub Yrysa'), subtitle: const Text(AppConstants.githubUrl), onTap: _openGithub),
          const ListTile(leading: Icon(Icons.info_outline_rounded), title: Text('Yrysa Wiki Reader 2.82.47'), subtitle: Text('made by Yrysa • Powered by Wikipedia')),
        ],
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  final bool register;
  final ValueChanged<Map<String, String>> onDone;
  const AuthScreen({super.key, required this.register, required this.onDone});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _nick = TextEditingController(text: 'Yrysa');
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _nick.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit({bool guest = false}) {
    if (!guest && widget.register && _password.text != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Пароли не совпадают')));
      return;
    }
    widget.onDone({
      'nick': guest ? 'Yrysa Guest' : (_nick.text.trim().isEmpty ? 'Yrysa User' : _nick.text.trim()),
      'email': guest ? 'guest@local.app' : _email.text.trim(),
      'status': guest ? 'Гость Wiki Discover' : 'Изучаю мир через Wikipedia',
      'avatar': guest ? '🧠' : '🚀',
      'guest': guest.toString(),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.register ? 'Регистрация' : 'Вход')),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        if (widget.register) TextField(controller: _nick, decoration: const InputDecoration(labelText: 'Никнейм')),
        TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
        TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Пароль')),
        if (widget.register) TextField(controller: _confirm, obscureText: true, decoration: const InputDecoration(labelText: 'Подтверждение пароля')),
        const SizedBox(height: 18),
        FilledButton(onPressed: _submit, child: Text(widget.register ? 'Создать аккаунт' : 'Войти')),
        TextButton(onPressed: () => _submit(guest: true), child: const Text('Войти как гость')),
      ]),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final Map<String, String> user;
  final ValueChanged<Map<String, String>> onDone;
  const EditProfileScreen({super.key, required this.user, required this.onDone});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nick = TextEditingController(text: widget.user['nick']);
  late final TextEditingController _status = TextEditingController(text: widget.user['status']);
  String _avatar = '🧠';

  @override
  void initState() {
    super.initState();
    _avatar = widget.user['avatar'] ?? '🧠';
  }

  @override
  void dispose() {
    _nick.dispose();
    _status.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const avatars = ['🧠', '🚀', '🌍', '📚', '💻', '⭐'];
    return Scaffold(
      appBar: AppBar(title: const Text('Редактировать профиль')),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Wrap(spacing: 8, children: [for (final item in avatars) ChoiceChip(label: Text(item), selected: _avatar == item, onSelected: (_) => setState(() => _avatar = item))]),
        TextField(controller: _nick, decoration: const InputDecoration(labelText: 'Ник')),
        TextField(controller: _status, decoration: const InputDecoration(labelText: 'Статус')),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: () {
            widget.onDone({...widget.user, 'nick': _nick.text.trim(), 'status': _status.text.trim(), 'avatar': _avatar});
            Navigator.pop(context);
          },
          child: const Text('Сохранить'),
        ),
      ]),
    );
  }
}
