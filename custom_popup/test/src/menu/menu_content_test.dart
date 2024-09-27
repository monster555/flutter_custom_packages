import 'package:custom_popup/custom_popup.dart';
import 'package:custom_popup/src/menu/menu_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MenuContent', () {
    testWidgets('renders actions correctly', (WidgetTester tester) async {
      final actions = [
        MenuItem(icon: Icons.home, onPressed: () {}, label: 'Action 1'),
        MenuItem(icon: Icons.settings, onPressed: () {}, label: 'Action 2'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuContent(actions: actions),
          ),
        ),
      );

      expect(find.byType(MenuItem), findsNWidgets(2));
      expect(find.text('Action 1'), findsOneWidget);
      expect(find.text('Action 2'), findsOneWidget);
    });

    testWidgets('applies default border radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MenuContent(actions: []),
          ),
        ),
      );

      final menuContent = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(menuContent.borderRadius, MenuContent.defaultBorderRadius);
    });

    testWidgets('applies default padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MenuContent(actions: []),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, MenuContent.defaultPadding);
    });

    testWidgets('respects minWidth and maxHeight', (WidgetTester tester) async {
      const minWidth = 200.0;
      const maxHeight = 300.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MenuContent(
              actions: [],
              minWidth: minWidth,
              maxHeight: maxHeight,
            ),
          ),
        ),
      );

      final constrainedBox =
          tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox)).last;

      expect(constrainedBox.constraints.minWidth, minWidth - 16.0);
      expect(constrainedBox.constraints.maxHeight, maxHeight - 16.0);
    });

    testWidgets('uses full screen height if maxHeight is not provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MenuContent(actions: []),
          ),
        ),
      );

      final constrainedBox =
          tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox)).last;
      expect(constrainedBox.constraints.maxHeight,
          MediaQuery.sizeOf(tester.element(find.byType(MenuContent))).height);
    });
  });
}
