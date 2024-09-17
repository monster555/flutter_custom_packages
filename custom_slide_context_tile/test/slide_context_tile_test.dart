import 'package:custom_slide_context_tile/custom_slide_context_tile.dart';
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

    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CustomSlideContextTile(
            manager: mockManager,
            child: const Text('Test Child'),
          ),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);
    });

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
              child: const Text('Test Child'),
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
              child: const Text('Test Child'),
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
              child: const Text('Test Child'),
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
              child: const Text('Test Child'),
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
              child: const Text('Test Child'),
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

    testWidgets('renders context menu when enabled',
        (WidgetTester tester) async {
      final actions = [
        MenuAction(label: 'Context Action', icon: Icons.home, onPressed: () {})
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomSlideContextTile.withContextMenu(
              manager: mockManager,
              leadingActions: actions,
              child: const Text('Test Child'),
            ),
          ),
        ),
      );

      final gesture = await tester
          .startGesture(tester.getCenter(find.byType(CustomSlideContextTile)));

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
        MenuAction(label: 'Context Action', icon: Icons.home, onPressed: () {})
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomSlideContextTile(
              manager: mockManager,
              leadingActions: actions,
              child: const Text('Test Child'),
            ),
          ),
        ),
      );

      // Attempt to open context menu
      await tester.longPress(find.text('Test Child'));
      await tester.pumpAndSettle();

      expect(find.text('Context Action'), findsNothing);
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
              child: const Text('Test Child'),
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

    testWidgets('handles no actions gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomSlideContextTile(
              manager: mockManager,
              controller: controller,
              child: const Text('Test Child'),
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
              child: const Text('Test Child'),
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
              child: const Text('Test Child'),
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
              MediaQuery.of(tester.element(slidableFinder)).size.width * 0.9));
    });

    testWidgets('uses correct animation strategy', (WidgetTester tester) async {
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
                child: const Text('Test Child'),
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
            expect(newPosition.dx, equals(30.0));
            break;
          case RevealAnimationType.pull:
            expect(newPosition.dx, equals(90.0));
            break;
          case RevealAnimationType.parallax:
            expect(newPosition.dx, equals(60.0));
            break;
        }
      }
    });
  });
}
