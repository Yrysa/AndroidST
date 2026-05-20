// made by Yrysa
import 'package:flutter/widgets.dart';

import 'wiki_app_state.dart';

class WikiStateScope extends InheritedNotifier<WikiAppState> {
  const WikiStateScope({super.key, required WikiAppState state, required super.child}) : super(notifier: state);

  static WikiAppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<WikiStateScope>();
    assert(scope != null, 'WikiStateScope not found');
    return scope!.notifier!;
  }
}
