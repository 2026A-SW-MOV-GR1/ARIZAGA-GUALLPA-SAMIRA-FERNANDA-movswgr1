// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:t_clase03/main.dart';

void main() {
  testWidgets('renders the three-module shell', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Bitácora de películas'), findsOneWidget);
    expect(find.text('Películas'), findsOneWidget);
    expect(find.text('API'), findsOneWidget);
    expect(find.text('Secretos'), findsOneWidget);
  });
}
