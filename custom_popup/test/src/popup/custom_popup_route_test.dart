import 'package:custom_popup/src/extensions/navigator_extensions.dart';
import 'package:custom_popup/src/popup/custom_popup.dart';
import 'package:custom_popup/src/popup/custom_popup_content.dart';
import 'package:custom_popup/src/popup/custom_popup_route.dart';
import 'package:custom_popup/src/popup/size_change_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildTestWidget({required Widget child}) {
  return MaterialApp(
    home: child,
  );
}

BuildContext getTestContext(WidgetTester tester) {
  final state = tester.state(find.byType(MaterialApp)) as State<MaterialApp>;
  return state.context;
}

CustomPopupRoute createTestRoute(
  BuildContext context, {
  required Widget child,
  Rect targetRect = Rect.zero,
  bool showArrow = true,
  EdgeInsets contentPadding = EdgeInsets.zero,
  double contentRadius = 0.0,
  Color backgroundColor = Colors.transparent,
  Color? barrierColor,
  Color? arrowColor,
  BoxDecoration? contentDecoration,
}) {
  return CustomPopupRoute(
    context,
    child: child,
    targetRect: targetRect,
    showArrow: showArrow,
    arrowColor: arrowColor,
    barrierColor: barrierColor,
    backgroundColor: backgroundColor,
    contentPadding: contentPadding,
    contentRadius: contentRadius,
    contentDecoration: contentDecoration,
  );
}

main() {
  group('CustomPopupRoute', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Container(),
        ),
      );

      // Get the test context from the tester
      final context = getTestContext(tester);

      // Create the popup route with specified properties
      final route = createTestRoute(
        context,
        child: const Text('Popup Content'),
        targetRect: Rect.zero,
        showArrow: true,
        contentPadding: EdgeInsets.zero,
      );

      // Create an animation controller for the route transitions
      final animationController = AnimationController(vsync: tester);

      // Build the widget transitions for the route
      final widget = route.buildTransitions(
        context,
        animationController,
        animationController,
        const Text('Popup Content'),
      );

      // Verify that the widget is a Stack
      expect(widget, isA<SizeChangeListener>());

      // Cast the widget to Stack and verify its first child is a Positioned widget
      final sizeChangeListener = widget as SizeChangeListener;
      expect(sizeChangeListener.child, isA<Stack>());

      final stack = sizeChangeListener.child as Stack;
      expect(stack.children.first, isA<Positioned>());

      // Cast the first child to Positioned and verify its child is a ConstrainedBox
      final positioned = stack.children.first as Positioned;
      expect(positioned.child, isA<ConstrainedBox>());

      // Cast the child to ConstrainedBox and verify its child is a Material widget
      final constrainedBox = positioned.child as ConstrainedBox;
      expect(constrainedBox.child, isA<Material>());

      // Cast the child to Material and verify its child is a SingleChildScrollView
      final material = constrainedBox.child as Material;
      expect(material.child, isA<SingleChildScrollView>());

      // Verify the Material widget's color is transparent
      expect(material.color, Colors.transparent);

      // Verify the initial value of the animation controller is 0.0
      expect(animationController.value, 0.0);
    });

    testWidgets('initial state', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        child: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                context.pushRoute(
                  createTestRoute(
                    context,
                    child:
                        Container(color: Colors.red, width: 100, height: 100),
                  ),
                );
              },
              child: const Text('Show Popup'),
            );
          },
        ),
      ));

      // Verify that the 'Show Popup' button is present
      expect(find.text('Show Popup'), findsOneWidget);

      // Simulate a tap on the 'Show Popup' button
      await tester.tap(find.text('Show Popup'));
      await tester.pumpAndSettle();

      // Verify that the CustomPopupContent widget is displayed
      expect(find.byType(CustomPopupContent), findsOneWidget);
    });

    testWidgets('verifies content properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  // Push the popup route with specified properties
                  context.pushRoute(
                    createTestRoute(
                      context,
                      targetRect: const Rect.fromLTWH(50, 100, 100, 50),
                      showArrow: true,
                      contentPadding: const EdgeInsets.all(8.0),
                      contentRadius: 4.0,
                      backgroundColor: Colors.green,
                      child: Container(
                        color: Colors.red,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  );
                },
                child: const Text('Show Popup'),
              );
            },
          ),
        ),
      );

      // Simulate a tap on the 'Show Popup' button
      await tester.tap(find.text('Show Popup'));
      await tester.pumpAndSettle();

      // Find the CustomPopupContent widget
      final popup = tester.firstWidget(find.byType(CustomPopupContent))
          as CustomPopupContent;

      // Verify the arrow visibility
      expect(popup.showArrow, true);

      // Verify the content padding
      expect(popup.contentPadding, const EdgeInsets.all(8.0));

      // Verify the content radius
      expect(popup.contentRadius, 4.0);

      // Verify the background color
      expect(popup.backgroundColor, Colors.green);

      // Verify the arrow color is null since it was not passed
      expect(popup.arrowColor, isNull);
    });

    testWidgets('verifies arrow and decoration properties',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        child: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                // Push the popup route with specified properties
                context.pushRoute(
                  createTestRoute(
                    context,
                    targetRect: const Rect.fromLTWH(50, 100, 100, 50),
                    showArrow: true,
                    contentPadding: const EdgeInsets.all(8.0),
                    contentRadius: 4.0,
                    backgroundColor: Colors.green,
                    arrowColor: Colors.blue,
                    contentDecoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                    ),
                    child: Container(
                      color: Colors.red,
                      width: 100,
                      height: 100,
                    ),
                  ),
                );
              },
              child: const Text('Show Popup'),
            );
          },
        ),
      ));

      // Simulate a tap on the 'Show Popup' button
      await tester.tap(find.text('Show Popup'));
      await tester.pumpAndSettle();

      // Find the CustomPopupContent widget
      final popup = tester.firstWidget(find.byType(CustomPopupContent))
          as CustomPopupContent;

      // Verify the arrow color
      expect(popup.arrowColor, Colors.blue);

      // Verify the content decoration border is not null
      expect(popup.contentDecoration?.border, isNotNull);

      // Verify the content decoration border color
      expect(
        popup.contentDecoration?.border,
        equals(Border.all(color: Colors.red)),
      );
    });

    testWidgets('arrow visibility', (WidgetTester tester) async {
      // A list of records in the form of (targetRect, expectedVisibility).
      final testCasesRecord = [
        // Test case 1:
        // - targetRect: Positioned at (50, 10) with size 50x50.
        // - expectedVisibility: `true` (Visible).
        (const Rect.fromLTWH(50, 10, 50, 50), true), // Visible

        // Test case 2:
        // - targetRect: Positioned at (150, 250) with size 50x50.
        // - expectedVisibility: `false` (Not visible).
        (const Rect.fromLTWH(150, 250, 50, 50), false), // Not visible

        // Test case 3:
        // - targetRect: Positioned at (100, 10) with size 50x50.
        // - expectedVisibility: `true` (Visible, top position).
        (const Rect.fromLTWH(100, 10, 50, 50), true), // Top position

        // Test case 4:
        // - targetRect: Positioned at (100, 300) with size 50x50.
        // - expectedVisibility: `false` (Not visible, bottom position).
        (const Rect.fromLTWH(100, 300, 50, 50), false), // Bottom position

        // Test case 5:
        // - targetRect: Positioned at (150, 200) with size 50x50.
        // - expectedVisibility: `true` (Visible, center position).
        (const Rect.fromLTWH(150, 200, 50, 50), true), // Center position

        // Test case 6:
        // - targetRect: Positioned at (5, 100) with size 50x50.
        // - expectedVisibility: `false` (Not visible, left edge).
        (const Rect.fromLTWH(5, 100, 50, 50), false), // Left edge

        // Test case 7:
        // - targetRect: Positioned at (250, 100) with size 50x50.
        // - expectedVisibility: `true` (Visible, right edge).
        (const Rect.fromLTWH(250, 100, 50, 50), true), // Right edge

        // Test case 8:
        // - targetRect: Positioned at (100, 5) with size 50x50.
        // - expectedVisibility: `false` (Not visible, top edge).
        (const Rect.fromLTWH(100, 5, 50, 50), false), // Top edge

        // Test case 9:
        // - targetRect: Positioned at (100, 350) with size 50x50.
        // - expectedVisibility: `true` (Visible, bottom edge).
        (const Rect.fromLTWH(100, 350, 50, 50), true), // Bottom edge
      ];

      // Iterate over each test case
      for (final testCase in testCasesRecord) {
        // Destructure the test case into targetRect and expectedArrowVisible
        final (targetRect, expectedArrowVisible) = testCase;
        await tester.pumpWidget(
          buildTestWidget(
            child: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    // Push the popup route with the specified targetRect and arrow visibility
                    context.pushRoute(
                      createTestRoute(
                        context,
                        targetRect: targetRect,
                        showArrow: true, // Ensure arrow is enabled
                        child: Container(
                          color: Colors.red,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    );
                  },
                  child: const Text('Show Popup'),
                );
              },
            ),
          ),
        );

        // Simulate a tap on the 'Show Popup' button
        await tester.tap(find.text('Show Popup'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Find the arrow widget by its key
        final arrowFinder = find.byKey(const ValueKey('popupArrow'));

        // Verify the visibility of the arrow based on the expected result
        if (expectedArrowVisible) {
          expect(arrowFinder, findsOneWidget);
        } else {
          expect(arrowFinder, findsNothing);
        }
      }
    });

    testWidgets('basic functionality', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(child: Container()));

      final context = getTestContext(tester);

      final route = createTestRoute(
        context,
        child: const Text('Popup Content'),
      );

      // Verify that the barrier color is black12
      expect(route.barrierColor, Colors.black12);

      // Verify that the barrier is dismissible
      expect(route.barrierDismissible, true);
    });

    testWidgets('barrier color', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(child: Container()));

      final context = getTestContext(tester);

      final route = createTestRoute(context,
          child: const Text('Popup Content'), barrierColor: Colors.green);

      // Verify that the barrier color is not black with 0.1 opacity, which is the default
      expect(route.barrierColor, isNot(Colors.black12));

      // Verify that the barrier color is green
      expect(route.barrierColor, Colors.green);

      // Verify that the barrier is dismissible
      expect(route.barrierDismissible, true);
    });

    testWidgets('interaction with close button', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  context.pushRoute(
                    createTestRoute(
                      context,
                      child: Container(
                        color: Colors.red,
                        width: 100,
                        height: 100,
                        child: ElevatedButton(
                          onPressed: context.pop,
                          child: const Text('Close'),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Show Popup'),
              );
            },
          ),
        ),
      );

      // Find the Show Popup button and tap it
      await tester.tap(find.text('Show Popup'));
      await tester.pumpAndSettle();

      // Verify that the popup is open
      expect(find.byType(CustomPopupContent), findsOneWidget);

      // Find the Close button and tap it
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Verify that the popup is closed
      expect(find.byType(CustomPopupContent), findsNothing);
    });

    testWidgets('positions correctly at viewport edges',
        (WidgetTester tester) async {
      // Top edge test
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: CustomPopup(
                showArrow: false,
                content:
                    const SizedBox(height: 600, child: Text('Tall Content')),
                child: Container(height: 50, color: Colors.blue),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Container).first);
      await tester.pumpAndSettle();

      // Bottom edge test
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: CustomPopup(
                showArrow: false,
                content:
                    const SizedBox(height: 700, child: Text('Tall Content')),
                child: Container(height: 50, color: Colors.blue),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Container).first);
      await tester.pumpAndSettle();
    });

    testWidgets('handles size changes correctly', (WidgetTester tester) async {
      Size currentSize = const Size(300, 300);

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return MediaQuery(
                data: MediaQueryData(size: currentSize),
                child: Column(
                  children: [
                    CustomPopup(
                      content: const Text('Popup Content'),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.blue,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      child: const Text('Change Size'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(Container));
      await tester.pumpAndSettle();

      expect(find.text('Popup Content'), findsOneWidget);

      final buttonFinder = find.byType(ElevatedButton);

      currentSize = const Size(200, 200);

      // Simulate a size change by pressing the button
      await tester.tap(buttonFinder);

      await tester.pumpAndSettle();

      // Verify that the popup is closed after resize
      expect(find.text('Popup Content'), findsNothing);
    });

    testWidgets('Popup handles content size changes',
        (WidgetTester tester) async {
      late StateSetter setState;
      bool isExpanded = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateInner) {
              setState = setStateInner;
              return Scaffold(
                body: Center(
                  child: CustomPopup(
                    content: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: isExpanded ? 200 : 100,
                      child: const Text('Resizable Content'),
                    ),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.blue,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(Container));
      await tester.pumpAndSettle();

      expect(find.text('Resizable Content'), findsOneWidget);

      // Change content size
      setState(() {
        isExpanded = true;
      });
      await tester.pumpAndSettle();

      // Verify that the popup is still open after content resize
      expect(find.text('Resizable Content'), findsOneWidget);
    });
  });
}
