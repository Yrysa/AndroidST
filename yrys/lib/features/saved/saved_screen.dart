// made by Yrysa
import 'package:flutter/material.dart';

import '../favorites/favorites_screen.dart';
import '../history/history_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.favorite_rounded), text: 'Избранное'),
            Tab(icon: Icon(Icons.history_rounded), text: 'История'),
          ],
        ),
        body: TabBarView(children: [FavoritesScreen(), HistoryScreen()]),
      ),
    );
  }
}
