import 'package:custom_slide_context_tile/custom_slide_context_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomSlideContextTile', () {
    late SlidableManager mockManager;
    late CustomSlidableController controller;

    setUp(() {
      mockManager = SlidableManager();
      controller = CustomSlidableController();
    });

    group('Rendering Tests', () {
      // Tests related to rendering of the widget
      testWidgets('renders child widget', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CustomSlideContextTile(
              manager: mockManager,
              title: const Text('Test Child'),
            ),
          ),
        );

        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('renders title correctly', (WidgetTester tester) async {
        const titleText = 'Test Title';
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                manager: mockManager,
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

      testWidgets('renders subtitle when provided',
          (WidgetTester tester) async {
        const titleText = 'Test Title';
        const subtitleText = 'Test Subtitle';
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                manager: mockManager,
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
      });

      testWidgets('does not render subtitle when not provided',
          (WidgetTester tester) async {
        const titleText = 'Test Title';
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                manager: mockManager,
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
        expect(
            find.byType(Text), findsOneWidget); // Only title should be present
      });

      testWidgets('has minimum height constraint', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                manager: mockManager,
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

      testWidgets('uses correct background color', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                manager: mockManager,
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
        final listTile =
            tester.widget<CupertinoListTile>(find.byType(CupertinoListTile));
        expect(listTile.backgroundColor, isNotNull);
        expect(listTile.backgroundColor,
            Theme.of(tester.element(slidableFinder)).scaffoldBackgroundColor);
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
                manager: mockManager,
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
                manager: mockManager,
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
                manager: mockManager,
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
                manager: mockManager,
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
                manager: mockManager,
                controller: controller,
                leadingActions: leadingActions,
                actionExecutionThreshold: 100.0,
                title: const Text('Test Child'),
              ),
            ),
          ),
        );

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
                manager: SlidableManager(),
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
                manager: SlidableManager(),
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
                manager: mockManager,
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
                manager: mockManager,
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

      testWidgets('uses correct animation strategy',
          (WidgetTester tester) async {
        for (final animationType in RevealAnimationType.values) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CustomSlideContextTile(
                  manager: mockManager,
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
                manager: mockManager,
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
                manager: mockManager,
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
                manager: mockManager,
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

        await tester.tap(find.byType(CupertinoListTile));
        expect(tapped, isTrue);
      });

      testWidgets('onTap does not work when controller is open',
          (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomSlideContextTile(
                manager: mockManager,
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

        await tester.tap(find.byType(CupertinoListTile));
        expect(tapped, isFalse);
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
                manager: mockManager,
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

        await tester.tap(find.byType(CupertinoListTile));
        expect(tapped, isTrue);

        // Reset tapped state
        tapped = false;

        final slidableFinder = find.byType(CustomSlideContextTile);
        // Perform a small drag to change to open state
        await tester.drag(slidableFinder, const Offset(100, 0));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(CupertinoListTile));
        expect(tapped, isFalse);
      });
    });
  });
}
