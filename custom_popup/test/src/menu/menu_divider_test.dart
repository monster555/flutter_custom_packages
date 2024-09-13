import 'package:custom_popup/src/menu/menu_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MenuDivider', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MenuDivider(),
          ),
        ),
      );

      expect(find.byType(Divider), findsOneWidget);
    });
  });
}
