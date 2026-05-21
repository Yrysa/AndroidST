// made by Yrysa
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/wiki_state_scope.dart';
import '../../data/models/summary.dart';
import '../article/presentation/open_article_detail.dart';
import 'social_storage.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final List<Map<String, String>> _friends = <Map<String, String>>[];
  final TextEditingController _friendController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  @override
  void dispose() {
    _friendController.dispose();
    super.dispose();
  }

  Future<void> _loadFriends() async {
    final loaded = await SocialStorage.loadFriends();
    if (loaded.isEmpty) {
      loaded.addAll([
        _friend('Aruzhan', 'Любит космос', '🚀', ['Космос', 'Наука']),
        _friend('Dias', 'Читает IT-статьи', '💻', ['IT', 'Игры']),
      ]);
      await SocialStorage.saveFriends(loaded);
    }
    if (mounted) setState(() => _friends.addAll(loaded));
  }

  Map<String, String> _friend(String nick, String status, String avatar, List<String> categories) {
    return {
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'nick': nick,
      'status': status,
      'avatar': avatar,
      'addedAt': DateTime.now().toIso8601String(),
      'categories': categories.join(', '),
      'readArticles': '${15 + _friends.length * 7}',
    };
  }

  Future<void> _addFriend() async {
    final name = _friendController.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _friends.insert(0, _friend(name, 'Новый друг Wiki Discover', '🌍', ['История', 'Космос']));
      _friendController.clear();
    });
    await SocialStorage.saveFriends(_friends);
  }

  Future<void> _removeFriend(Map<String, String> friend) async {
    setState(() => _friends.removeWhere((item) => item['id'] == friend['id']));
    await SocialStorage.saveFriends(_friends);
  }

  void _openFriend(Map<String, String> friend) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FriendProfileScreen(friend: friend, onDelete: () => _removeFriend(friend)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: const TabBar(tabs: [
          Tab(icon: Icon(Icons.group_rounded), text: 'Друзья'),
          Tab(icon: Icon(Icons.chat_rounded), text: 'Чаты'),
          Tab(icon: Icon(Icons.recommend_rounded), text: 'Рекомендовано'),
          Tab(icon: Icon(Icons.bolt_rounded), text: 'Активность'),
        ]),
        body: TabBarView(children: [
          _FriendsTab(controller: _friendController, friends: _friends, onAdd: _addFriend, onOpen: _openFriend, onDelete: _removeFriend),
          _ChatsTab(friends: _friends),
          _RecommendationsTab(friends: _friends),
          _ActivityTab(friends: _friends),
        ]),
      ),
    );
  }
}

class _FriendsTab extends StatelessWidget {
  final TextEditingController controller;
  final List<Map<String, String>> friends;
  final VoidCallback onAdd;
  final ValueChanged<Map<String, String>> onOpen;
  final ValueChanged<Map<String, String>> onDelete;
  const _FriendsTab({required this.controller, required this.friends, required this.onAdd, required this.onOpen, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(18), children: [
      TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Ник друга',
          prefixIcon: const Icon(Icons.person_add_rounded),
          suffixIcon: IconButton(onPressed: onAdd, icon: const Icon(Icons.add_rounded)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onSubmitted: (_) => onAdd(),
      ),
      const SizedBox(height: 18),
      if (friends.isEmpty) const Center(child: Padding(padding: EdgeInsets.all(28), child: Text('Добавьте первого друга'))),
      for (final friend in friends)
        Card(
          elevation: 0,
          child: ListTile(
            leading: CircleAvatar(child: Text(friend['avatar'] ?? '🌍')),
            title: Text(friend['nick'] ?? 'Друг'),
            subtitle: Text(friend['status'] ?? ''),
            onTap: () => onOpen(friend),
            trailing: IconButton(icon: const Icon(Icons.delete_outline_rounded), onPressed: () => onDelete(friend)),
          ),
        ),
    ]);
  }
}

class FriendProfileScreen extends StatelessWidget {
  final Map<String, String> friend;
  final VoidCallback onDelete;
  const FriendProfileScreen({super.key, required this.friend, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final interests = friend['categories'] ?? 'Космос, История';
    return Scaffold(
      appBar: AppBar(title: Text(friend['nick'] ?? 'Друг')),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
          CircleAvatar(radius: 42, child: Text(friend['avatar'] ?? '🌍', style: const TextStyle(fontSize: 34))),
          const SizedBox(height: 12),
          Text(friend['nick'] ?? 'Друг', style: Theme.of(context).textTheme.headlineMedium),
          Text(friend['status'] ?? ''),
          const SizedBox(height: 10),
          Text('Добавлен: ${(friend['addedAt'] ?? '').split('T').first}'),
          Text('Прочитал статей: ${friend['readArticles'] ?? '0'}'),
          Text('Любимые категории: $interests'),
          Text('Общие интересы: $interests'),
        ]))),
        FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(friend: friend))), icon: const Icon(Icons.chat_rounded), label: const Text('Написать')),
        const SizedBox(height: 8),
        OutlinedButton.icon(onPressed: () { onDelete(); Navigator.pop(context); }, icon: const Icon(Icons.delete_outline_rounded), label: const Text('Удалить из друзей')),
      ]),
    );
  }
}

class _ChatsTab extends StatelessWidget {
  final List<Map<String, String>> friends;
  const _ChatsTab({required this.friends});
  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) return const Center(child: Text('Добавьте друга, чтобы начать чат'));
    return ListView(padding: const EdgeInsets.all(18), children: [
      for (final friend in friends)
        Card(elevation: 0, child: ListTile(
          leading: CircleAvatar(child: Text(friend['avatar'] ?? '🌍')),
          title: Text(friend['nick'] ?? 'Друг'),
          subtitle: const Text('Открыть переписку'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(friend: friend))),
        )),
    ]);
  }
}

class ChatScreen extends StatefulWidget {
  final Map<String, String> friend;
  final Summary? initialArticle;
  const ChatScreen({super.key, required this.friend, this.initialArticle});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = <Map<String, String>>[];
  String get _key => SocialStorage.chatKey(widget.friend);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const <String>[];
    final loaded = raw.map((e) => jsonDecode(e)).whereType<Map>().map((item) => item.map((key, value) => MapEntry(key.toString(), value.toString()))).toList();
    if (widget.initialArticle != null && loaded.where((m) => m['articleUrl'] == widget.initialArticle!.url).isEmpty) {
      await SocialStorage.sendArticleToFriend(friend: widget.friend, article: widget.initialArticle!);
      final updated = prefs.getStringList(_key) ?? const <String>[];
      loaded
        ..clear()
        ..addAll(updated.map((e) => jsonDecode(e)).whereType<Map>().map((item) => item.map((key, value) => MapEntry(key.toString(), value.toString()))));
    }
    if (mounted) setState(() => _messages.addAll(loaded));
  }

  Map<String, String> _baseMessage(String type) {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return {'id': now.microsecondsSinceEpoch.toString(), 'senderId': 'me', 'type': type, 'createdAt': now.toIso8601String(), 'time': '$h:$m', 'isRead': 'true'};
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _messages.map(jsonEncode).toList());
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({..._baseMessage('text'), 'text': text});
      _controller.clear();
    });
    await _save();
  }

  Summary _articleFromMessage(Map<String, String> item) {
    return Summary.fromStorage({
      'titles': {'canonical': item['articleTitle'], 'normalized': item['articleTitle'], 'display': item['articleTitle']},
      'extract': item['articleDescription'],
      'url': item['articleUrl'],
      'thumbnail': item['articleImage']?.isEmpty == true ? null : {'source': item['articleImage'], 'width': 0, 'height': 0},
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = WikiStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.friend['nick'] ?? 'Чат')),
      body: Column(children: [
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final item = _messages[index];
            final isArticle = item['type'] == 'article';
            return Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: isArticle ? 310 : null,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(18)),
                child: isArticle
                    ? _ArticleMessage(item: item, onSave: () => state.toggleFavorite(_articleFromMessage(item)), onOpen: () => openArticleDetail(context, _articleFromMessage(item)))
                    : Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(item['text'] ?? ''), const SizedBox(height: 4), Text(item['time'] ?? '', style: Theme.of(context).textTheme.labelSmall)]),
              ),
            );
          },
        )),
        Padding(padding: const EdgeInsets.all(12), child: Row(children: [
          Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Сообщение'))),
          IconButton.filled(onPressed: _send, icon: const Icon(Icons.send_rounded)),
        ])),
      ]),
    );
  }
}

class _ArticleMessage extends StatelessWidget {
  final Map<String, String> item;
  final VoidCallback onSave;
  final VoidCallback onOpen;
  const _ArticleMessage({required this.item, required this.onSave, required this.onOpen});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(item['articleTitle'] ?? 'Статья', style: const TextStyle(fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      Text(item['articleDescription'] ?? '', maxLines: 3, overflow: TextOverflow.ellipsis),
      const SizedBox(height: 8),
      Row(children: [
        TextButton(onPressed: onSave, child: const Text('Сохранить')),
        TextButton(onPressed: onOpen, child: const Text('Открыть')),
      ]),
      Align(alignment: Alignment.centerRight, child: Text(item['time'] ?? '', style: Theme.of(context).textTheme.labelSmall)),
    ]);
  }
}

class _RecommendationsTab extends StatelessWidget {
  final List<Map<String, String>> friends;
  const _RecommendationsTab({required this.friends});
  @override
  Widget build(BuildContext context) {
    final state = WikiStateScope.of(context);
    return FutureBuilder<List<Map<String, String>>>(
      future: _loadRecommendations(friends),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <Map<String, String>>[];
        if (items.isEmpty) return const Center(child: Text('Пока никто не отправил вам статьи'));
        return ListView(padding: const EdgeInsets.all(18), children: [
          for (final item in items)
            Card(elevation: 0, child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.recommend_rounded)),
              title: Text(item['articleTitle'] ?? 'Статья'),
              subtitle: Text('Отправил: ${item['friend'] ?? 'Друг'}'),
              onTap: () => openArticleDetail(context, Summary.fromStorage({
                'titles': {'canonical': item['articleTitle'], 'normalized': item['articleTitle'], 'display': item['articleTitle']},
                'extract': item['articleDescription'],
                'url': item['articleUrl'],
                'thumbnail': item['articleImage']?.isEmpty == true ? null : {'source': item['articleImage'], 'width': 0, 'height': 0},
              })),
              trailing: IconButton(
                icon: const Icon(Icons.favorite_border_rounded),
                onPressed: () => state.toggleFavorite(Summary.fromStorage({
                  'titles': {'canonical': item['articleTitle'], 'normalized': item['articleTitle'], 'display': item['articleTitle']},
                  'extract': item['articleDescription'],
                  'url': item['articleUrl'],
                  'thumbnail': item['articleImage']?.isEmpty == true ? null : {'source': item['articleImage'], 'width': 0, 'height': 0},
                })),
              ),
            )),
        ]);
      },
    );
  }

  Future<List<Map<String, String>>> _loadRecommendations(List<Map<String, String>> friends) async {
    final prefs = await SharedPreferences.getInstance();
    final result = <Map<String, String>>[];
    for (final friend in friends) {
      final key = SocialStorage.chatKey(friend);
      final raw = prefs.getStringList(key) ?? const <String>[];
      for (final item in raw.map((e) => jsonDecode(e)).whereType<Map>()) {
        final map = item.map((key, value) => MapEntry(key.toString(), value.toString()));
        if (map['type'] == 'article') result.add({...map, 'friend': friend['nick'] ?? 'Друг'});
      }
    }
    return result.reversed.toList();
  }
}

class _ActivityTab extends StatelessWidget {
  final List<Map<String, String>> friends;
  const _ActivityTab({required this.friends});
  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) return const Center(child: Text('Активность появится после добавления друзей'));
    return ListView(padding: const EdgeInsets.all(18), children: [
      for (final friend in friends)
        Card(elevation: 0, child: ListTile(
          leading: CircleAvatar(child: Text(friend['avatar'] ?? '🌍')),
          title: Text('${friend['nick']} прочитал статью из категории ${friend['categories']}'),
          subtitle: const Text('Локальная MVP-активность'),
        )),
    ]);
  }
}
