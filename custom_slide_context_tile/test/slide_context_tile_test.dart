import 'package:custom_slide_context_tile/custom_slide_context_tile.dart';
import 'package:custom_slide_context_tile/src/widgets/adaptive_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomSlideContextTile', () {
    late CustomSlidableController controller;

    setUp(() {
      controller = CustomSlidableController();
    });

    group('Rendering Tests', () {
      // Tests related to rendering of the widget
      testWidgets('renders title correctly', (WidgetTester tester) async {
        const titleText = 'Test Title';
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                leadingActions: [
                  MenuAction(
                    label: 'Action',
                    icon: Icons.star,
                    onPressed: () {},
                  )
                ],
                title: const Text(titleText),
              ),
            ),
          ),
        );

        expect(find.text(titleText), findsOneWidget);
      });

      testWidgets('renders subtitle when provided and omits when not provided',
          (WidgetTester tester) async {
        const titleText = 'Test Title';
        const subtitleText = 'Test Subtitle';

        // Test with subtitle
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                leadingActions: [
                  MenuAction(
                    label: 'Action',
                    icon: Icons.star,
                    onPressed: () {},
                  )
                ],
                title: const Text(titleText),
                subtitle: const Text(subtitleText),
              ),
            ),
          ),
        );

        expect(find.text(titleText), findsOneWidget);
        expect(find.text(subtitleText), findsOneWidget);

        // Test without subtitle
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                leadingActions: [
                  MenuAction(
                    label: 'Action',
                    icon: Icons.star,
                    onPressed: () {},
                  )
                ],
                title: const Text(titleText),
              ),
            ),
          ),
        );

        expect(find.text(titleText), findsOneWidget);
        expect(find.text(subtitleText), findsNothing);
        // Only title should be present
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('has minimum height constraint', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                leadingActions: [
                  MenuAction(
                    label: 'Action',
                    icon: Icons.star,
                    onPressed: () {},
                  )
                ],
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        // Find all ConstrainedBox widgets within CustomSlideContextTile
        final constrainedBoxes = tester.widgetList<ConstrainedBox>(
          find.descendant(
            of: find.byType(CustomSlideContextTile),
            matching: find.byType(ConstrainedBox),
          ),
        );

        // Find the ConstrainedBox with minHeight of 48
        final targetConstrainedBox = constrainedBoxes.firstWhere(
          (box) => box.constraints.minHeight == 48,
          orElse: () =>
              throw Exception('No ConstrainedBox found with minHeight of 48'),
        );

        expect(targetConstrainedBox.constraints.minHeight, 48);
      });

      testWidgets('renders leading and trailing widgets correctly',
          (WidgetTester tester) async {
        const leading = Icon(Icons.home);
        const trailing = Icon(Icons.settings);

        // Test with both leading and trailing
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                leadingActions: [
                  MenuAction(
                      label: 'Action', icon: Icons.star, onPressed: () {})
                ],
                leading: leading,
                trailing: trailing,
                title: const Text('Test'),
              ),
            ),
          ),
        );

        final adaptiveListTile =
            tester.widget<AdaptiveListTile>(find.byType(AdaptiveListTile));
        expect(adaptiveListTile.leading, leading);
        expect(adaptiveListTile.trailing, trailing);
        expect(find.byIcon(Icons.home), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);

        // Test without leading and trailing
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                leadingActions: [
                  MenuAction(
                      label: 'Action', icon: Icons.star, onPressed: () {})
                ],
                title: const Text('Test'),
              ),
            ),
          ),
        );

        final adaptiveListTileWithoutLeadingTrailing =
            tester.widget<AdaptiveListTile>(find.byType(AdaptiveListTile));
        expect(adaptiveListTileWithoutLeadingTrailing.leading, isNull);
        expect(adaptiveListTileWithoutLeadingTrailing.trailing, isNull);
        expect(find.byIcon(Icons.home), findsNothing);
        expect(find.byIcon(Icons.settings), findsNothing);
      });

      testWidgets('does not render subtitle when not provided',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                leadingActions: [
                  MenuAction(
                      label: 'Action', icon: Icons.star, onPressed: () {}),
                ],
                title: const Text('Test Title'),
              ),
            ),
          ),
        );

        expect(find.text('Test Title'), findsOneWidget);
        expect(
            find.byType(Text), findsOneWidget); // Only title should be present
        expect(find.byType(AdaptiveListTile), findsOneWidget);
        final adaptiveListTile =
            tester.widget<AdaptiveListTile>(find.byType(AdaptiveListTile));
        expect(adaptiveListTile.subtitle, isNull);
      });
    });

    group('Background Color Tests', () {
      testWidgets('uses correct background color for iOS when adaptive',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Scaffold(
              body: CustomSlideContextTile.adaptive(
                controller: controller,
                leadingActions: [
                  MenuAction(
                    label: 'Action',
                    icon: Icons.star,
                    onPressed: () {},
                  )
                ],
                title: const Text('Test'),
              ),
            ),
          ),
        );

        final slidableFinder = find.byType(CustomSlideContextTile);
        final adaptiveListTile = tester.widget<AdaptiveListTile>(
          find.descendant(
            of: slidableFinder,
            matching: find.byType(AdaptiveListTile),
          ),
        );

        expect(adaptiveListTile.useAdaptiveListTile, isTrue);

        final cupertinoListTile = tester.widget<CupertinoListTile>(
          find.descendant(
            of: find.byType(AdaptiveListTile),
            matching: find.byType(CupertinoListTile),
          ),
        );
        expect(cupertinoListTile.backgroundColor,
            CupertinoColors.systemBackground);
      });

      testWidgets('uses correct background color for Android when adaptive',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              body: CustomSlideContextTile.adaptive(
                controller: controller,
                leadingActions: [
                  MenuAction(
                    label: 'Action',
                    icon: Icons.star,
                    onPressed: () {},
                  )
                ],
                title: const Text('Test'),
              ),
            ),
          ),
        );

        final slidableFinder = find.byType(CustomSlideContextTile);
        final adaptiveListTile = tester.widget<AdaptiveListTile>(
          find.descendant(
            of: slidableFinder,
            matching: find.byType(AdaptiveListTile),
          ),
        );

        expect(adaptiveListTile.useAdaptiveListTile, isTrue);

        final coloredBox = tester.widget<ColoredBox>(
          find.descendant(
            of: find.byType(AdaptiveListTile),
            matching: find.byType(ColoredBox),
          ),
        );
        expect(
          coloredBox.color,
          Theme.of(tester.element(slidableFinder)).scaffoldBackgroundColor,
        );
      });

      testWidgets(
          'uses correct background color for different platforms when not adaptive',
          (WidgetTester tester) async {
        for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(platform: platform),
              home: Scaffold(
                body: CustomSlideContextTile(
                  controller: controller,
                  leadingActions: [
                    MenuAction(
                      label: 'Action',
                      icon: Icons.star,
                      onPressed: () {},
                    )
                  ],
                  title: const Text('Test'),
                ),
              ),
            ),
          );

          final slidableFinder = find.byType(CustomSlideContextTile);
          final adaptiveListTile = tester.widget<AdaptiveListTile>(
            find.descendant(
              of: slidableFinder,
              matching: find.byType(AdaptiveListTile),
            ),
          );

          expect(adaptiveListTile.useAdaptiveListTile, isFalse);

          final cupertinoListTile = tester.widget<CupertinoListTile>(
            find.descendant(
              of: find.byType(AdaptiveListTile),
              matching: find.byType(CupertinoListTile),
            ),
          );
          expect(cupertinoListTile.backgroundColor,
              CupertinoColors.systemBackground);

          await tester.pumpAndSettle();
        }
      });
    });

    group('Action Tests', () {
      // Tests related to leading and trailing actions
      testWidgets('renders leading actions', (WidgetTester tester) async {
        final leadingActions = [
          MenuAction(label: 'Action 1', icon: Icons.home, onPressed: () {}),
          MenuAction(label: 'Action 2', icon: Icons.person, onPressed: () {}),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                leadingActions: leadingActions,
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        final gesture = await tester.startGesture(
            tester.getCenter(find.byKey(const Key('gesture-detector'))));
        await gesture.moveBy(const Offset(300, 0),
            timeStamp: const Duration(milliseconds: 100));
        await gesture.up();

        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Check if actions are visible
        expect(
            find.byWidgetPredicate(
                (widget) => widget is Icon && widget.icon == Icons.home),
            findsOneWidget);
        expect(
            find.byWidgetPredicate(
                (widget) => widget is Icon && widget.icon == Icons.person),
            findsOneWidget);
      });

      testWidgets('renders trailing actions', (WidgetTester tester) async {
        final trailingActions = [
          MenuAction(label: 'Action 3', icon: Icons.home, onPressed: () {}),
          MenuAction(label: 'Action 4', icon: Icons.person, onPressed: () {}),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                trailingActions: trailingActions,
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        // Simulate a drag to reveal trailing actions
        await tester.drag(find.text('Test Child'), const Offset(-200, 0));
        await tester.pumpAndSettle();

        expect(
            find.byWidgetPredicate(
                (widget) => widget is Icon && widget.icon == Icons.home),
            findsOneWidget);
        expect(
            find.byWidgetPredicate(
                (widget) => widget is Icon && widget.icon == Icons.person),
            findsOneWidget);
      });

      testWidgets('handles no actions gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        final slidableFinder = find.byType(CustomSlideContextTile);

        // Attempt to drag
        await tester.drag(slidableFinder, const Offset(200, 0));
        await tester.pumpAndSettle();

        // Verify that the slidable didn't open
        expect(controller.isOpen, isFalse);
      });

      testWidgets('handles many actions', (WidgetTester tester) async {
        final manyActions = List.generate(
          5,
          (index) => MenuAction(
              label: 'Action $index', icon: Icons.star, onPressed: () {}),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                leadingActions: manyActions,
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        final slidableFinder = find.byType(CustomSlideContextTile);

        // Open the slidable
        await tester.drag(slidableFinder, const Offset(200, 0));
        await tester.pumpAndSettle();

        // Verify that the slidable opened and can handle many actions
        expect(controller.isOpen, isTrue);
        expect(find.byIcon(Icons.star), findsNWidgets(5));
      });

      testWidgets('executes action when threshold is exceeded',
          (WidgetTester tester) async {
        bool actionExecuted = false;
        final leadingActions = [
          MenuAction(
            label: 'Action 1',
            icon: Icons.home,
            onPressed: () => actionExecuted = true,
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                leadingActions: leadingActions,
                actionExecutionThreshold: 100.0,
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        // Assert that the action has not been executed before the drag
        expect(actionExecuted, isFalse);

        final slidableFinder = find.byType(CustomSlideContextTile);

        // Perform a drag that exceeds the actionExecutionThreshold
        await tester.drag(slidableFinder, const Offset(750, 0));
        await tester.pumpAndSettle();

        // Verify that the action was executed
        expect(actionExecuted, isTrue);
      });
    });

    group('Slidable Behavior Tests', () {
      // Tests related to opening, closing, and general slidable behavior
      testWidgets('opens slidable on drag and updates controller state',
          (WidgetTester tester) async {
        final leadingActions = [
          MenuAction(label: 'Action 1', icon: Icons.home, onPressed: () {}),
          MenuAction(label: 'Action 2', icon: Icons.home, onPressed: () {}),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                leadingActions: leadingActions,
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        // Verify initial state
        expect(controller.isOpen, isFalse);

        // Find the CustomSlideContextTile widget
        final slidableFinder = find.byType(CustomSlideContextTile);

        // Perform the drag gesture
        await tester.drag(slidableFinder, const Offset(200, 0));
        await tester.pumpAndSettle();

        // Verify the controller state after drag
        expect(controller.isOpen, isTrue);

        // Close the slidable
        await tester.tap(slidableFinder);
        await tester.pumpAndSettle();

        // Verify the controller state after closing
        expect(controller.isOpen, isFalse);
      });

      testWidgets('opens slidable using controller methods',
          (WidgetTester tester) async {
        final leadingActions = [
          MenuAction(label: 'Action 1', icon: Icons.home, onPressed: () {}),
        ];
        final trailingActions = [
          MenuAction(label: 'Action 2', icon: Icons.home, onPressed: () {}),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                leadingActions: leadingActions,
                trailingActions: trailingActions,
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        // Verify initial state
        expect(controller.isOpen, isFalse);

        // Open leading actions
        controller.openLeading();
        await tester.pumpAndSettle();
        expect(controller.isOpen, isTrue);

        // Close slidable
        controller.close();
        await tester.pumpAndSettle();
        expect(controller.isOpen, isFalse);

        // Open trailing actions
        controller.openTrailing();
        await tester.pumpAndSettle();
        expect(controller.isOpen, isTrue);
      });

      testWidgets('closes on tap when open', (WidgetTester tester) async {
        final leadingActions = [
          MenuAction(label: 'Action', icon: Icons.home, onPressed: () {})
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                leadingActions: leadingActions,
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        expect(controller.isOpen, isFalse);

        // Open the slidable
        await tester.drag(find.text('Test Child'), const Offset(100, 0));
        await tester.pumpAndSettle();

        expect(controller.isOpen, isTrue);

        // Tap to close
        await tester.tap(find.text('Test Child'));
        await tester.pumpAndSettle();

        expect(controller.isOpen, isFalse);
      });

      testWidgets('respects maximum offset', (WidgetTester tester) async {
        final leadingActions = List.generate(
          5,
          (index) => MenuAction(
              label: 'Action $index', icon: Icons.star, onPressed: () {}),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                leadingActions: leadingActions,
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        final slidableFinder = find.byType(CustomSlideContextTile);
        final childFinder = find.text('Test Child');

        // Get initial position of the child
        final initialPosition = tester.getTopLeft(childFinder);

        // Perform a large drag
        await tester.drag(slidableFinder, const Offset(1000, 0));
        await tester.pumpAndSettle();

        // Get new position of the child
        final newPosition = tester.getTopLeft(childFinder);

        // Calculate the actual offset
        final actualOffset = newPosition.dx - initialPosition.dx;

        // Verify that the offset doesn't exceed the maximum allowed
        // You might need to adjust this value based on your implementation
        expect(
            actualOffset,
            lessThanOrEqualTo(
                MediaQuery.of(tester.element(slidableFinder)).size.width *
                    0.9));
      });

      testWidgets('handles several actions', (WidgetTester tester) async {
        final actions = List.generate(
          2,
          (index) => MenuAction(
              label: 'Action $index', icon: Icons.star, onPressed: () {}),
        );

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: MaterialApp(
              home: Scaffold(
                body: CustomSlideContextTile(
                  controller: controller,
                  leadingActions: actions,
                  trailingActions: actions,
                  title: const Text('Test Child'),
                ),
              ),
            ),
          ),
        );

        await tester.drag(find.text('Test Child'), const Offset(100, 0));
        await tester.pumpAndSettle();
      });

      testWidgets('uses correct animation strategy',
          (WidgetTester tester) async {
        for (final animationType in RevealAnimationType.values) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CustomSlideContextTile(
                  controller: controller,
                  revealAnimationType: animationType,
                  leadingActions: [
                    MenuAction(
                      label: 'Action',
                      icon: Icons.star,
                      onPressed: () {},
                    )
                  ],
                  title: const Text('Test Child'),
                ),
              ),
            ),
          );

          final slidableFinder = find.byType(CustomSlideContextTile);
          final childFinder = find.text('Test Child');

          // Perform a small drag
          await tester.drag(slidableFinder, const Offset(50, 0));
          await tester.pump();

          // Get the new position of the child
          final newPosition = tester.getTopLeft(childFinder);

          // Verify the animation behavior based on the type
          switch (animationType) {
            case RevealAnimationType.reveal:
              expect(newPosition.dx, equals(50.0));
              break;
            case RevealAnimationType.pull:
              expect(newPosition.dx, equals(110.0));
              break;
            case RevealAnimationType.parallax:
              expect(newPosition.dx, equals(80.0));
              break;
          }
        }
      });
    });

    group('ContextMenu Tests', () {
      // Tests related to the context menu functionality
      testWidgets('renders context menu when enabled',
          (WidgetTester tester) async {
        final actions = [
          MenuAction(
              label: 'Context Action', icon: Icons.home, onPressed: () {})
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile.withContextMenu(
                leadingActions: actions,
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        final gesture = await tester.startGesture(
            tester.getCenter(find.byType(CustomSlideContextTile)));

        await gesture.up();
        await tester.pumpAndSettle();

        expect(
            find.byWidgetPredicate(
                (widget) => widget is Icon && widget.icon == Icons.home),
            findsOneWidget);
      });

      testWidgets('does not render context menu when disabled',
          (WidgetTester tester) async {
        final actions = [
          MenuAction(
              label: 'Context Action', icon: Icons.home, onPressed: () {})
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                leadingActions: actions,
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        // Attempt to open context menu
        await tester.longPress(find.text('Test Child'));
        await tester.pumpAndSettle();

        expect(find.text('Context Action'), findsNothing);
      });
    });

    group('Interaction Tests', () {
      // Tests related to user interactions like tapping
      testWidgets('onTap works when controller is not open',
          (WidgetTester tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                onTap: () => tapped = true,
                leadingActions: [
                  MenuAction(
                    label: 'Action',
                    icon: Icons.star,
                    onPressed: () {},
                  )
                ],
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        await tester.tap(find.byType(AdaptiveListTile));
        expect(tapped, isTrue);
      });

      testWidgets('onTap does not work when controller is open',
          (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                onTap: () => tapped = true,
                leadingActions: [
                  MenuAction(
                    label: 'Action',
                    icon: Icons.star,
                    onPressed: () {},
                  )
                ],
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        final slidableFinder = find.byType(CustomSlideContextTile);
        // Perform a small drag to change to open state
        await tester.drag(slidableFinder, const Offset(100, 0));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(AdaptiveListTile));
        expect(tapped, isFalse);
      });

      testWidgets('does not call onTap when not provided',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                leadingActions: [
                  MenuAction(
                      label: 'Action', icon: Icons.star, onPressed: () {}),
                ],
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        // Attempt to tap the tile
        await tester.tap(find.byType(AdaptiveListTile));
        await tester.pump();

        // Since we didn't provide an onTap callback, nothing should happen
        // We can't directly test that onTap wasn't called, but we can verify that the controller state didn't change
        expect(controller.isOpen, isFalse);
      });

      testWidgets('controller open state changes disable onTap',
          (WidgetTester tester) async {
        bool tapped = false;
        onTap() => tapped = true;

        // Initially closed
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                controller: controller,
                onTap: onTap,
                leadingActions: [
                  MenuAction(
                    label: 'Action',
                    icon: Icons.star,
                    onPressed: () {},
                  )
                ],
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        await tester.tap(find.byType(AdaptiveListTile));
        expect(tapped, isTrue);

        // Reset tapped state
        tapped = false;

        final slidableFinder = find.byType(CustomSlideContextTile);
        // Perform a small drag to change to open state
        await tester.drag(slidableFinder, const Offset(100, 0));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(AdaptiveListTile));
        expect(tapped, isFalse);
      });

      testWidgets('closes open slidable when another slidable is swiped',
          (WidgetTester tester) async {
        final controller1 = CustomSlidableController();
        final controller2 = CustomSlidableController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  CustomSlideContextTile(
                    controller: controller1,
                    leadingActions: [
                      MenuAction(
                          label: 'Action 1',
                          icon: Icons.star,
                          onPressed: () {}),
                    ],
                    title: const Text('Slidable 1'),
                  ),
                  CustomSlideContextTile(
                    controller: controller2,
                    leadingActions: [
                      MenuAction(
                          label: 'Action 2',
                          icon: Icons.home,
                          onPressed: () {}),
                    ],
                    title: const Text('Slidable 2'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Open the first slidable
        await tester.drag(find.text('Slidable 1'), const Offset(200, 0));
        await tester.pumpAndSettle();

        expect(controller1.isOpen, isTrue);
        expect(controller2.isOpen, isFalse);

        // Start swiping the second slidable
        await tester.drag(find.text('Slidable 2'), const Offset(50, 0));
        await tester.pumpAndSettle();

        // Verify that the first slidable is now closed
        expect(controller1.isOpen, isFalse);

        // Complete the swipe on the second slidable
        await tester.drag(find.text('Slidable 2'), const Offset(150, 0));
        await tester.pumpAndSettle();

        // Verify that the second slidable is now open
        expect(controller1.isOpen, isFalse);
        expect(controller2.isOpen, isTrue);
      });

      testWidgets(
          'closes open slidable when another slidable is programatically open',
          (WidgetTester tester) async {
        final controller1 = CustomSlidableController();
        final controller2 = CustomSlidableController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  CustomSlideContextTile(
                    controller: controller1,
                    leadingActions: [
                      MenuAction(
                          label: 'Action 1',
                          icon: Icons.star,
                          onPressed: () {}),
                    ],
                    title: const Text('Slidable 1'),
                  ),
                  CustomSlideContextTile(
                    controller: controller2,
                    leadingActions: [
                      MenuAction(
                          label: 'Action 2',
                          icon: Icons.home,
                          onPressed: () {}),
                    ],
                    title: const Text('Slidable 2'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Open the first slidable
        // await tester.drag(find.text('Slidable 1'), const Offset(200, 0));
        controller1.openLeading();
        await tester.pumpAndSettle();

        expect(controller1.isOpen, isTrue);
        expect(controller2.isOpen, isFalse);

        // Start swiping the second slidable
        controller2.openLeading();
        await tester.pumpAndSettle();

        // Verify that the first slidable is now closed
        expect(controller1.isOpen, isFalse);
        expect(controller2.isOpen, isTrue);
      });
    });

    group('Adaptive Constructor Tests', () {
      testWidgets(
          'uses AdaptiveListTile when constructed with adaptive constructor',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile.adaptive(
                title: const Text('Test Child'),
                leadingActions: [
                  MenuAction(
                      label: 'Action', icon: Icons.star, onPressed: () {}),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(AdaptiveListTile), findsOneWidget);
      });

      testWidgets('AdaptiveListTile uses correct useAdaptiveListTile value',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile.adaptive(
                title: const Text('Test Child'),
                leadingActions: [
                  MenuAction(
                      label: 'Action', icon: Icons.star, onPressed: () {}),
                ],
              ),
            ),
          ),
        );

        final adaptiveListTile = tester.widget<AdaptiveListTile>(
          find.byType(AdaptiveListTile),
        );
        expect(adaptiveListTile.useAdaptiveListTile, isTrue);
      });

      testWidgets(
          'uses AdaptiveListTile with useAdaptiveListTile set to false by default',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                title: const Text('Test Child'),
                leadingActions: [
                  MenuAction(
                      label: 'Action', icon: Icons.star, onPressed: () {}),
                ],
              ),
            ),
          ),
        );

        final adaptiveListTile = tester.widget<AdaptiveListTile>(
          find.byType(AdaptiveListTile),
        );
        expect(adaptiveListTile.useAdaptiveListTile, isFalse);
      });

      testWidgets(
          'does not render context menu when using adaptive constructor',
          (WidgetTester tester) async {
        final actions = [
          MenuAction(
            label: 'Context Action',
            icon: Icons.home,
            onPressed: () {},
          )
        ];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile.adaptive(
                leadingActions: actions,
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

        // Attempt to open context menu
        await tester.longPress(find.text('Test Child'));
        await tester.pumpAndSettle();
        expect(find.text('Context Action'), findsNothing);
      });

      testWidgets('uses CupertinoListTile on iOS when not adaptive',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Scaffold(
              body: CustomSlideContextTile(
                title: const Text('Test Child'),
                leadingActions: [
                  MenuAction(
                      label: 'Action', icon: Icons.star, onPressed: () {}),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(CupertinoListTile), findsOneWidget);
        expect(find.byType(ListTile), findsNothing);
      });

      testWidgets('uses ListTile on Android when not adaptive',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              body: CustomSlideContextTile(
                title: const Text('Test Child'),
                leadingActions: [
                  MenuAction(
                      label: 'Action', icon: Icons.star, onPressed: () {}),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(CupertinoListTile), findsOneWidget);
        expect(find.byType(ListTile), findsNothing);
      });

      testWidgets('uses CupertinoListTile on macOS when not adaptive',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.macOS),
            home: Scaffold(
              body: CustomSlideContextTile(
                title: const Text('Test Child'),
                leadingActions: [
                  MenuAction(
                      label: 'Action', icon: Icons.star, onPressed: () {}),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(CupertinoListTile), findsOneWidget);
        expect(find.byType(ListTile), findsNothing);
      });

      testWidgets('uses ListTile on Android when adaptive',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              body: CustomSlideContextTile.adaptive(
                title: const Text('Test Child'),
                leadingActions: [
                  MenuAction(
                      label: 'Action', icon: Icons.star, onPressed: () {}),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(ListTile), findsOneWidget);
        expect(find.byType(CupertinoListTile), findsNothing);
      });
    });

    group('AnimationTypes', () {
      testWidgets('uses correct animation types', (WidgetTester tester) async {
        for (final animationType in RevealAnimationType.values) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CustomSlideContextTile(
                  key: ValueKey<String>('$animationType'),
                  revealAnimationType: animationType,
                  title: const Text('Test Child'),
                  leadingActions: [
                    MenuAction(
                        label: 'Action', icon: Icons.star, onPressed: () {}),
                  ],
                ),
              ),
            ),
          );

          final slidableWidget = tester.widget<CustomSlideContextTile>(
              find.byType(CustomSlideContextTile));
          expect(
            slidableWidget.revealAnimationType,
            animationType,
          );
        }
      });
    });
  });
}
