import 'package:custom_slide_context_tile/custom_slide_context_tile.dart';
import 'package:custom_slide_context_tile/src/utils/menu_action_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MenuAction', () {
    group('Label and Icon rendering', () {
      testWidgets('renders icon with or without label based on showLabels',
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

    group('Background and Foreground Color', () {
      testWidgets('uses provided backgroundColor', (WidgetTester tester) async {
        const backgroundColor = Colors.red;
        const foregroundColor = Colors.white;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MenuActionScope(
                showLabels: true,
                child: MenuAction(
                  onPressed: () {},
                  icon: Icons.home,
                  label: 'Test Label',
                  foregroundColor: foregroundColor,
                  backgroundColor: backgroundColor,
                ),
              ),
            ),
          ),
        );

        final container =
            tester.widget<DecoratedBox>(find.byType(DecoratedBox));
        expect((container.decoration as BoxDecoration).color, backgroundColor);

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.color, foregroundColor);

        final text = tester.widget<Text>(find.text('Test Label'));
        expect(text.style?.color, foregroundColor);
      });

      testWidgets(
          'uses scaffold background color when no backgroundColor provided',
          (WidgetTester tester) async {
        const scaffoldColor = Colors.blue;
        const defaultForegroundColor = Colors.black;
        const defaultTextColor = Colors.yellow;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: scaffoldColor,
              iconTheme: const IconThemeData(
                color: defaultForegroundColor,
              ),
              textTheme: const TextTheme(
                  bodyMedium: TextStyle(color: defaultTextColor)),
            ),
            home: Scaffold(
              body: MenuActionScope(
                showLabels: true,
                child: MenuAction(
                  onPressed: () {},
                  icon: Icons.home,
                  label: 'Test Label',
                ),
              ),
            ),
          ),
        );

        final container =
            tester.widget<DecoratedBox>(find.byType(DecoratedBox));
        expect((container.decoration as BoxDecoration).color, scaffoldColor);

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.color, defaultForegroundColor);

        final text = tester.widget<Text>(find.text('Test Label'));
        expect(text.style?.color, defaultTextColor);
      });
    });

    group('Alignment', () {
      testWidgets(
          'aligns content correctly based on shouldExpandDefaultAction and isLeading',
          (WidgetTester tester) async {
        Future<void> buildWidget(bool shouldExpand, bool isLeading) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: MenuActionScope(
                  showLabels: true,
                  isLeading: isLeading,
                  shouldExpandDefaultAction: shouldExpand,
                  child: MenuAction(
                    onPressed: () {},
                    icon: Icons.home,
                    label: 'Home',
                  ),
                ),
              ),
            ),
          );
        }

        // Test case 1: shouldExpand = true, isLeading = true
        await buildWidget(true, true);
        expect(
            tester.widget<AnimatedAlign>(find.byType(AnimatedAlign)).alignment,
            Alignment.centerRight);

        // Test case 2: shouldExpand = true, isLeading = false
        await buildWidget(true, false);
        expect(
            tester.widget<AnimatedAlign>(find.byType(AnimatedAlign)).alignment,
            Alignment.centerLeft);

        // Test case 3: shouldExpand = false
        await buildWidget(
            false, true); // isLeading doesn't matter when shouldExpand is false
        expect(
            tester.widget<AnimatedAlign>(find.byType(AnimatedAlign)).alignment,
            Alignment.center);
      });
    });

    group('Padding', () {
      testWidgets('uses correct padding based on shouldExpandDefaultAction',
          (WidgetTester tester) async {
        Future<void> buildWidget(bool shouldExpand) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: MenuActionScope(
                  showLabels: true,
                  shouldExpandDefaultAction: shouldExpand,
                  child: MenuAction(
                    onPressed: () {},
                    icon: Icons.home,
                    label: 'Home',
                  ),
                ),
              ),
            ),
          );
        }

        // Test case 1
        await buildWidget(true);
        final padding1 = tester.widget<Padding>(find.byType(Padding));
        expect(padding1.padding,
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0));

        // Test case 2
        await buildWidget(false);
        final padding2 = tester.widget<Padding>(find.byType(Padding));
        expect(padding2.padding,
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0));
      });
    });

    group('Interaction', () {
      testWidgets('calls onPressed and closes controller when tapped',
          (WidgetTester tester) async {
        final controller = CustomSlidableController();
        bool wasTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MenuActionScope(
                showLabels: true,
                // Pass the controller to test the controller.close() call when an action is tapped
                controller: controller,
                child: MenuAction(
                  onPressed: () => wasTapped = true,
                  icon: Icons.home,
                ),
              ),
            ),
          ),
        );

        expect(wasTapped, isFalse);
        expect(controller.isOpen, isFalse);

        await tester.tap(find.byType(InkWell));

        expect(wasTapped, isTrue);
        // Verify that the controller is closed after tap
        expect(controller.isOpen, isFalse);
      });
    });

    group('text Handling', () {
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

    group('Animation', () {
      testWidgets('AnimatedAlign has correct duration and curve',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: MenuActionScope(
            showLabels: true,
            child:
                MenuAction(onPressed: () {}, icon: Icons.home, label: 'Home'),
          )),
        ));

        final animatedAlign =
            tester.widget<AnimatedAlign>(find.byType(AnimatedAlign));
        expect(animatedAlign.duration, const Duration(milliseconds: 300));
        expect(animatedAlign.curve, Curves.fastOutSlowIn);
      });
    });
  });
}
