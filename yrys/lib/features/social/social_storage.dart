// made by Yrysa
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/summary.dart';

class SocialStorage {
  static const String friendsKey = 'wiki_friends';
  static const String sentArticlesKey = 'sent_articles_count';

  static Future<List<Map<String, String>>> loadFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(friendsKey) ?? const <String>[];
    return raw.map((item) => jsonDecode(item)).whereType<Map>().map(_stringMap).toList();
  }

  static Future<void> saveFriends(List<Map<String, String>> friends) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(friendsKey, friends.map(jsonEncode).toList());
  }

  static Future<void> sendArticleToFriend({required Map<String, String> friend, required Summary article}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = chatKey(friend);
    final messages = prefs.getStringList(key) ?? <String>[];
    final now = DateTime.now();
    final message = {
      'id': now.microsecondsSinceEpoch.toString(),
      'senderId': 'me',
      'type': 'article',
      'text': 'Посмотри интересную статью',
      'articleTitle': article.titles.normalized,
      'articleDescription': article.description ?? article.extract,
      'articleImage': article.imageUrl ?? '',
      'articleUrl': article.url,
      'createdAt': now.toIso8601String(),
      'time': TimeOfDay.now().format(_FakeBuildContext()),
      'isRead': 'true',
    };
    messages.add(jsonEncode(message));
    await prefs.setStringList(key, messages);
    await prefs.setInt(sentArticlesKey, (prefs.getInt(sentArticlesKey) ?? 0) + 1);
  }

  static String chatKey(Map<String, String> friend) => 'chat_${friend['id'] ?? friend['nick'] ?? 'friend'}';

  static Map<String, String> _stringMap(Map item) => item.map((key, value) => MapEntry(key.toString(), value.toString()));
}

class _FakeBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
