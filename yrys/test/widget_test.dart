// made by Yrysa
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yrys/app/yrysa_wiki_app.dart';

void main() {
  testWidgets('Yrysa Wiki Reader запускается со splash screen', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const YrysaWikiApp());

    expect(find.text('Yrysa Wiki Reader'), findsOneWidget);
    expect(find.text('made by Yrysa'), findsOneWidget);
  });
}
