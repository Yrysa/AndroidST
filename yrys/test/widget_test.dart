// made by Yrysa
import 'package:flutter_test/flutter_test.dart';
import 'package:yrys/app/yrysa_wiki_app.dart';

void main() {
  testWidgets('Yrysa Wiki Reader запускается', (tester) async {
    await tester.pumpWidget(const YrysaWikiApp());
    expect(find.text('Yrysa Wiki Reader'), findsOneWidget);
  });
}
