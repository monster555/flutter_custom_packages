import 'package:custom_slide_context_tile/src/widgets/context_menu.dart';
import 'package:custom_slide_context_tile/src/widgets/menu_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContextMenu', () {
    group('Rendering', () {
      testWidgets('renders child widget and constraints width',
          (WidgetTester tester) async {
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

    group('Actions', () {
      testWidgets('throws assertion error when no valid actions',
          (WidgetTester tester) async {
        final actions = [
          MenuAction(
            icon: Icons.edit,
            onPressed: () {},
          ), // Invalid action (no label)
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

        // Check if there's an error in the console output
        expect(tester.takeException(), isAssertionError);

        // Verify that the CupertinoContextMenu widget is not in the tree
        expect(find.byType(CupertinoContextMenu), findsNothing);

        // Verify that the child widget is not in the tree either
        expect(find.text('Test Child'), findsNothing);
      });

      testWidgets('renders CupertinoContextMenu with valid actions',
          (WidgetTester tester) async {
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

        expect(find.byType(CupertinoContextMenu), findsOneWidget);

        // Verify that the child is rendered
        expect(find.text('Test Child'), findsOneWidget);

        // Verify that the correct number of actions were passed to CupertinoContextMenu
        final contextMenu = tester
            .widget<CupertinoContextMenu>(find.byType(CupertinoContextMenu));
        expect(contextMenu.actions.length, equals(2));

        // Verify the content of the valid actions
        for (var action in contextMenu.actions) {
          expect(action, isA<CupertinoContextMenuAction>());
          final actionWidget = action as CupertinoContextMenuAction;
          expect(actionWidget.child, isA<Row>());

          final row = actionWidget.child as Row;
          expect(row.children.length, equals(2)); // Text and Icon
          expect(row.children[0], isA<Text>());
          expect(row.children[1], isA<Icon>());
        }
      });

      testWidgets('renders CupertinoContextMenu with only valid actions',
          (WidgetTester tester) async {
        final actions = [
          MenuAction(label: 'Action 1', icon: Icons.home, onPressed: () {}),
          MenuAction(
              icon: Icons.person,
              onPressed: () {}), // Invalid action (no label)
          MenuAction(label: 'Action 2', icon: Icons.settings, onPressed: () {}),
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

        expect(find.byType(CupertinoContextMenu), findsOneWidget);

        // Verify that the child is rendered
        expect(find.text('Test Child'), findsOneWidget);

        // Verify that only valid actions were passed to CupertinoContextMenu
        final contextMenu = tester
            .widget<CupertinoContextMenu>(find.byType(CupertinoContextMenu));
        expect(contextMenu.actions.length,
            equals(2)); // Only 2 valid actions should be passed

        // Verify the content of the valid actions
        for (var action in contextMenu.actions) {
          expect(action, isA<CupertinoContextMenuAction>());
          final actionWidget = action as CupertinoContextMenuAction;
          expect(actionWidget.child, isA<Row>());

          final row = actionWidget.child as Row;
          expect(row.children.length, equals(2)); // Text and Icon
          expect(row.children[0], isA<Text>());
          expect(row.children[1], isA<Icon>());
        }
      });
    });
  });
}
