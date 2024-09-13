import 'package:custom_popup/src/hover_indicator/hover_listener.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HoverListener', () {
    testWidgets('builder receives correct state', (tester) async {
      bool isHoveredCalled = false;

      hoveredBuilder(bool isHovered) {
        isHoveredCalled = true;
        return SizedBox.square(
          dimension: 200,
          child: Center(
            child: Text('Hovered: $isHovered'),
          ),
        );
      }

      await tester.pumpWidget(
        MaterialApp(
          home: HoverListener(builder: hoveredBuilder),
        ),
      );

      // Verify that the hoveredBuilder function is called
      expect(isHoveredCalled, true);

      // Verify that the initial hover state is false
      expect(find.text('Hovered: false'), findsOneWidget);

      // Create a mouse gesture for simulating pointer events
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);

      // Add a pointer at the location (0, 0)
      await gesture.addPointer(location: Offset.zero);

      // Ensure the pointer is removed after the test
      addTearDown(gesture.removePointer);
      await tester.pump();

      // Move the pointer to the center of the Text widget
      await gesture.moveTo(tester.getCenter(find.byType(Text)));
      await tester.pumpAndSettle();

      // Verify that the hover state is true when the pointer is over the widget
      expect(find.text('Hovered: true'), findsOneWidget);

      // Remove the pointer
      await gesture.removePointer(); // Removes the pointer
      await tester.pumpAndSettle();

      // Verify that the hover state is false when the pointer is removed
      expect(find.text('Hovered: false'), findsOneWidget);
    });

    testWidgets('performance test', (tester) async {
      // Define the expected maximum hover time in microseconds
      const expectedMaxHoverTime = 20000;

      // Define the number of hover iterations
      const hoverIterations = 5;

      hoveredBuilder(bool isHovered) => Text('Hovered: $isHovered');

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: HoverListener(builder: hoveredBuilder),
          ),
        ),
      );

      // Perform the hover test for the specified number of iterations
      for (int i = 0; i < hoverIterations; i++) {
        // Create a mouse gesture for simulating pointer events
        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );

        // Add a pointer at the location (0, 0)
        await gesture.addPointer(location: Offset.zero);

        // Ensure the pointer is removed after the test
        addTearDown(gesture.removePointer);
        await tester.pump();

        // Record the start time
        final startTime = DateTime.now().microsecondsSinceEpoch;

        // Move the pointer to the center of the Text widget
        await gesture.moveTo(tester.getCenter(find.byType(Text)));
        await tester.pumpAndSettle();

        // Record the end time
        final endTime = DateTime.now().microsecondsSinceEpoch;

        // Calculate the hover time
        final hoverTime = endTime - startTime;

        // Verify that the hover time does not exceed the expected maximum
        expect(hoverTime, lessThanOrEqualTo(expectedMaxHoverTime));

        // Remove the pointer
        await gesture.removePointer();
        await tester.pumpAndSettle();
      }
    });
  });
}
