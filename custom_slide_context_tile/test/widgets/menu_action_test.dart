import 'package:custom_slide_context_tile/src/utils/menu_action_scope.dart';
import 'package:custom_slide_context_tile/src/widgets/menu_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MenuAction', () {
    testWidgets('renders icon without label when showLabels is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuActionScope(
              showLabels: false,
              child: MenuAction(
                onPressed: () {},
                icon: Icons.home,
                label: 'Home',
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('Home'), findsNothing);
    });

    testWidgets('renders icon and label when showLabels is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuActionScope(
              showLabels: true,
              child: MenuAction(
                onPressed: () {},
                icon: Icons.home,
                label: 'Home',
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('uses provided backgroundColor', (WidgetTester tester) async {
      const backgroundColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuActionScope(
              showLabels: true,
              child: MenuAction(
                onPressed: () {},
                icon: Icons.home,
                backgroundColor: backgroundColor,
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
      expect((container.decoration as BoxDecoration).color, backgroundColor);
    });

    testWidgets(
        'uses scaffold background color when no backgroundColor provided',
        (WidgetTester tester) async {
      const scaffoldColor = Colors.blue;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(scaffoldBackgroundColor: scaffoldColor),
          home: Scaffold(
            body: MenuActionScope(
              showLabels: true,
              child: MenuAction(
                onPressed: () {},
                icon: Icons.home,
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
      expect((container.decoration as BoxDecoration).color, scaffoldColor);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuActionScope(
              showLabels: true,
              child: MenuAction(
                onPressed: () => wasTapped = true,
                icon: Icons.home,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(wasTapped, isTrue);
    });

    testWidgets('truncates long label text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuActionScope(
              showLabels: true,
              child: SizedBox(
                width: 100, // Constrain width to force truncation
                child: MenuAction(
                  onPressed: () {},
                  icon: Icons.home,
                  label: 'This is a very long label that should be truncated',
                ),
              ),
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.maxLines, 1);
      expect(textWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('does not render label when label is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuActionScope(
              showLabels: true,
              child: MenuAction(
                onPressed: () {},
                icon: Icons.home,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Text), findsNothing);
    });
  });
}
