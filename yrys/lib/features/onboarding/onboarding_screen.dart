// made by Yrysa
import 'package:flutter/material.dart';

import '../../app/wiki_state_scope.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const _items = [
    ('Открывай случайные статьи', 'Wikipedia становится красивой лентой знаний.'),
    ('Сохраняй интересное', 'Добавляй статьи в избранное и читай оффлайн.'),
    ('Изучай мир каждый день', 'Следи за статистикой, историей и достижениями.'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = WikiStateScope.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.20),
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (value) => setState(() => _page = value),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_stories_rounded, size: 96, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 28),
                          Text(item.$1, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge),
                          const SizedBox(height: 12),
                          Text(item.$2, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_items.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: _page == index ? 28 : 9,
                      height: 9,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: _page == index ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () async {
                    if (_page < _items.length - 1) {
                      await _controller.nextPage(duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
                    } else {
                      await state.completeOnboarding();
                    }
                  },
                  child: Text(_page == _items.length - 1 ? 'Начать' : 'Далее'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
