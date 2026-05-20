// made by Yrysa
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('wiki_friends') ?? const <String>[];
    final loaded = raw.map((item) => jsonDecode(item)).whereType<Map>().map((item) {
      return item.map((key, value) => MapEntry(key.toString(), value.toString()));
    }).toList();
    if (loaded.isEmpty) {
      loaded.addAll(const [
        {'nick': 'Aruzhan', 'status': 'Любит космос', 'avatar': '🚀'},
        {'nick': 'Dias', 'status': 'Читает IT-статьи', 'avatar': '💻'},
      ]);
    }
    setState(() => _friends.addAll(loaded));
  }

  Future<void> _saveFriends() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('wiki_friends', _friends.map(jsonEncode).toList());
  }

  Future<void> _addFriend() async {
    final name = _friendController.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _friends.insert(0, {'nick': name, 'status': 'Новый друг Wiki Discover', 'avatar': '🌍'});
      _friendController.clear();
    });
    await _saveFriends();
  }

  Future<void> _removeFriend(int index) async {
    setState(() => _friends.removeAt(index));
    await _saveFriends();
  }

  void _openChat(Map<String, String> friend) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatScreen(friend: friend)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Друзья и чаты')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          TextField(
            controller: _friendController,
            decoration: InputDecoration(
              labelText: 'Ник друга',
              prefixIcon: const Icon(Icons.person_add_rounded),
              suffixIcon: IconButton(onPressed: _addFriend, icon: const Icon(Icons.add_rounded)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onSubmitted: (_) => _addFriend(),
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < _friends.length; i++)
            Card(
              elevation: 0,
              child: ListTile(
                leading: CircleAvatar(child: Text(_friends[i]['avatar'] ?? '🌍')),
                title: Text(_friends[i]['nick'] ?? 'Друг'),
                subtitle: Text(_friends[i]['status'] ?? ''),
                onTap: () => _openChat(_friends[i]),
                trailing: IconButton(icon: const Icon(Icons.delete_outline_rounded), onPressed: () => _removeFriend(i)),
              ),
            ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final Map<String, String> friend;
  const ChatScreen({super.key, required this.friend});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = <Map<String, String>>[];

  String get _key => 'chat_${widget.friend['nick']}';

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
    setState(() {
      _messages.addAll(raw.map((e) => jsonDecode(e)).whereType<Map>().map((item) {
        return item.map((key, value) => MapEntry(key.toString(), value.toString()));
      }));
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _messages.map(jsonEncode).toList());
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'time': TimeOfDay.now().format(context), 'mine': 'true'});
      _controller.clear();
    });
    await _save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.friend['nick'] ?? 'Чат')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final item = _messages[index];
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(item['text'] ?? ''),
                      const SizedBox(height: 4),
                      Text(item['time'] ?? '', style: Theme.of(context).textTheme.labelSmall),
                    ]),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Сообщение'))),
              IconButton.filled(onPressed: _send, icon: const Icon(Icons.send_rounded)),
            ]),
          ),
        ],
      ),
    );
  }
}
