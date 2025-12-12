// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:compatibilite_app/main.dart';

void main() {
  testWidgets('Affiche le header du parcours', (WidgetTester tester) async {
    await tester.pumpWidget(const CompatibiliteApp());
    // Use pump with duration instead of pumpAndSettle since we have infinite animations
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('Compatibilité'), findsWidgets);
    expect(find.textContaining('étape', findRichText: true), findsWidgets);
  });
}
