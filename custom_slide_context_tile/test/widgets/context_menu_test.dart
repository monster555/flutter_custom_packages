import 'package:custom_slide_context_tile/src/widgets/context_menu.dart';
import 'package:custom_slide_context_tile/src/widgets/menu_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContextMenu', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      final actions = [
        MenuAction(label: 'Action 1', icon: Icons.home, onPressed: () {}),
        MenuAction(label: 'Action 2', icon: Icons.person, onPressed: () {}),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContextMenu(
              actions: actions,
              child: const Text('Test Child'),
            ),
          ),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('constrains child width to screen width',
        (WidgetTester tester) async {
      final actions = [
        MenuAction(
          label: 'Destructive Action',
          icon: Icons.delete,
          onPressed: () {},
          isDestructive: true,
        ),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContextMenu(
              actions: actions,
              child: const Text('Test Child'),
            ),
          ),
        ),
      );

      final constrainedBox = tester.widget<ConstrainedBox>(
        find.descendant(
          of: find.byType(ContextMenu),
          matching: find.byType(ConstrainedBox),
        ),
      );

      // Default test screen width
      expect(constrainedBox.constraints.maxWidth, equals(800.0));
    });
  });
}
