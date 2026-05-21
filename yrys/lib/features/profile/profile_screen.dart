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
  static const _userKey = 'wiki_user';
  static const _sessionKey = 'wiki_session_email';

  Map<String, String> _user = _guestUser();

  static Map<String, String> _guestUser() => {
        'id': 'guest',
        'nick': 'Гость',
        'email': 'guest@local.app',
        'password': '',
        'status': 'Гостевой режим Wiki Discover',
        'avatar': '🧠',
        'createdAt': DateTime.now().toIso8601String(),
        'guest': 'true',
      };

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    final session = prefs.getString(_sessionKey);
    if (raw == null || session == null) {
      setState(() => _user = _guestUser());
      return;
    }
    final data = jsonDecode(raw);
    if (data is Map) {
      final user = data.map((key, value) => MapEntry(key.toString(), value.toString()));
      if (user['email'] == session) setState(() => _user = user);
    }
  }

  Future<void> _saveUser(Map<String, String> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
    await prefs.setString(_sessionKey, user['email'] ?? 'guest@local.app');
    setState(() => _user = user);
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    setState(() => _user = _guestUser());
  }

  void _openAuth({required bool register}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AuthScreen(register: register, onDone: _saveUser),
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
    final isGuest = _user['guest'] == 'true';
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
                Text(_user['nick'] ?? 'Гость', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                Text(_user['email'] ?? '', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(_user['status'] ?? '', textAlign: TextAlign.center),
                const SizedBox(height: 14),
                Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
                  FilledButton.icon(onPressed: _editProfile, icon: const Icon(Icons.edit_rounded), label: const Text('Редактировать')),
                  if (isGuest) OutlinedButton.icon(onPressed: () => _openAuth(register: false), icon: const Icon(Icons.login_rounded), label: const Text('Войти')),
                  if (isGuest) OutlinedButton.icon(onPressed: () => _openAuth(register: true), icon: const Icon(Icons.person_add_rounded), label: const Text('Регистрация')),
                  if (!isGuest) OutlinedButton.icon(onPressed: _logout, icon: const Icon(Icons.logout_rounded), label: const Text('Выйти')),
                ]),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          _StatsCard(total: state.totalRead, today: state.todayRead, favs: state.favorites.length, streak: state.streak, last: state.lastArticleTitle),
          const SizedBox(height: 12),
          _AchievementsCard(total: state.totalRead, favs: state.favorites.length, streak: state.streak),
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
  static const _userKey = 'wiki_user';
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

  Future<Map<String, String>?> _storedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    final data = jsonDecode(raw);
    if (data is! Map) return null;
    return data.map((key, value) => MapEntry(key.toString(), value.toString()));
  }

  Future<void> _submit({bool guest = false}) async {
    final email = _email.text.trim();
    final password = _password.text;
    final nick = _nick.text.trim();

    if (guest) {
      widget.onDone({
        'id': 'guest',
        'nick': 'Гость',
        'email': 'guest@local.app',
        'password': '',
        'status': 'Гостевой режим Wiki Discover',
        'avatar': '🧠',
        'createdAt': DateTime.now().toIso8601String(),
        'guest': 'true',
      });
      if (mounted) Navigator.pop(context);
      return;
    }

    if (email.isEmpty || !email.contains('@')) return _error('Введите корректный email');
    if (password.length < 6) return _error('Пароль должен быть минимум 6 символов');

    final saved = await _storedUser();
    if (widget.register) {
      if (nick.isEmpty) return _error('Введите ник');
      if (password != _confirm.text) return _error('Пароли не совпадают');
      if (saved != null && saved['email'] == email) return _error('Пользователь с таким email уже есть');
      widget.onDone({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'nick': nick,
        'email': email,
        'password': password,
        'status': 'Изучаю мир через Wikipedia',
        'avatar': '🚀',
        'createdAt': DateTime.now().toIso8601String(),
        'guest': 'false',
      });
    } else {
      if (saved == null || saved['email'] != email || saved['password'] != password) return _error('Неверный email или пароль');
      widget.onDone(saved);
    }
    if (mounted) Navigator.pop(context);
  }

  void _error(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
        FilledButton(onPressed: () => _submit(), child: Text(widget.register ? 'Создать аккаунт' : 'Войти')),
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
            widget.onDone({...widget.user, 'nick': _nick.text.trim().isEmpty ? 'Yrysa User' : _nick.text.trim(), 'status': _status.text.trim(), 'avatar': _avatar});
            Navigator.pop(context);
          },
          child: const Text('Сохранить'),
        ),
      ]),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final int total;
  final int today;
  final int favs;
  final int streak;
  final String last;
  const _StatsCard({required this.total, required this.today, required this.favs, required this.streak, required this.last});

  @override
  Widget build(BuildContext context) {
    return Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Статистика', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      Text('Всего прочитано: $total'),
      Text('Сегодня: $today'),
      Text('Избранное: $favs'),
      Text('Серия дней: $streak'),
      Text('Последняя статья: ${last.isEmpty ? '—' : last}'),
    ])));
  }
}

class _AchievementsCard extends StatelessWidget {
  final int total;
  final int favs;
  final int streak;
  const _AchievementsCard({required this.total, required this.favs, required this.streak});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Первая статья', total >= 1),
      ('Любознательный — 10 статей', total >= 10),
      ('Исследователь — 50 статей', total >= 50),
      ('Коллекционер — 10 избранных', favs >= 10),
      ('Серия — 3 дня подряд', streak >= 3),
      ('Wiki Master — 100 статей', total >= 100),
    ];
    return Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Достижения', style: Theme.of(context).textTheme.titleMedium),
      for (final item in items) ListTile(contentPadding: EdgeInsets.zero, leading: Icon(item.$2 ? Icons.emoji_events_rounded : Icons.lock_outline_rounded), title: Text(item.$1)),
    ])));
  }
}
