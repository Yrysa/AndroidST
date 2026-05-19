// made by Yrysa
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const RootScreen({super.key, required this.navigationShell});

  List<NavigationDestination> get _items => const [
        NavigationDestination(
          icon: Icon(Icons.casino_outlined),
          selectedIcon: Icon(Icons.casino),
          label: 'Random',
        ),
        NavigationDestination(
          icon: Icon(Icons.star_border_rounded),
          selectedIcon: Icon(Icons.star_rounded),
          label: 'Favorite',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: _items,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
