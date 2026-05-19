// made by Yrysa
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'root_screen.dart';
import 'ui/article_page/article_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/random',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return RootScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/random',
              builder: (context, state) => const ArticleScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorite',
              builder: (context, state) => const Center(
                child: Text(
                  'Favorite articles by Yrysa',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
