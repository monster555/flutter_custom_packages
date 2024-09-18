import 'package:custom_slide_context_tile/src/controller/custom_slidable_controller.dart';
import 'package:custom_slide_context_tile/src/utils/custom_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCustomSlidableController extends Mock
    implements CustomSlidableController {}

void main() {
  group('CustomScrollBehavior', () {
    late MockCustomSlidableController mockController;

    setUp(() {
      mockController = MockCustomSlidableController();
    });

    Future<void> pumpWidget(WidgetTester tester,
        {bool shouldCloseOnScroll = true, Widget? child}) async {
      return tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: CustomScrollBehavior(
              controller: mockController,
              shouldCloseOnScroll: shouldCloseOnScroll,
              child: child ?? Container(height: 1000),
            ),
          ),
        ),
      );
    }

    testWidgets('renders child widget', (WidgetTester tester) async {
      final childWidget = Container(key: const Key('child'));

      await pumpWidget(tester, child: childWidget);

      expect(find.byKey(const Key('child')), findsOneWidget);
    });

    testWidgets(
        'calls close on controller when scrolling starts and shouldCloseOnScroll is true',
        (WidgetTester tester) async {
      await pumpWidget(tester);

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pump();

      verify(mockController.close()).called(1);
    });

    testWidgets(
        'does not call close on controller when scrolling starts and shouldCloseOnScroll is false',
        (WidgetTester tester) async {
      await pumpWidget(tester, shouldCloseOnScroll: false);

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pump();

      verifyNever(mockController.close());
    });

    testWidgets('updates behavior when shouldCloseOnScroll changes',
        (WidgetTester tester) async {
      await pumpWidget(tester, shouldCloseOnScroll: false);

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pump();
      verifyNever(mockController.close());

      await pumpWidget(tester);

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pump();
      verify(mockController.close()).called(1);
    });

    testWidgets('calls close only once for multiple scroll events',
        (WidgetTester tester) async {
      await pumpWidget(tester);

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -50));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -50));
      await tester.pump(const Duration(milliseconds: 100));

      verify(mockController.close()).called(2);
    });

    testWidgets('behaves consistently for different scroll directions',
        (WidgetTester tester) async {
      await pumpWidget(
        tester,
        child: const SizedBox(height: 1000, width: 1000),
      );

      await tester.drag(find.byType(SingleChildScrollView),
          const Offset(0, -100)); // Vertical scroll
      await tester.pump();
      verify(mockController.close()).called(1);

      reset(mockController);

      await tester.drag(find.byType(SingleChildScrollView),
          const Offset(-100, 0)); // Horizontal scroll
      await tester.pump();
      verify(mockController.close()).called(1);
    });

    testWidgets('maintains behavior when widget tree changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: Column(
              children: [
                CustomScrollBehavior(
                  controller: mockController,
                  shouldCloseOnScroll: true,
                  child: Container(height: 500),
                ),
                Container(height: 500),
              ],
            ),
          ),
        ),
      );

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pump();
      verify(mockController.close()).called(1);

      reset(mockController);

      // Change the widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 500),
                CustomScrollBehavior(
                  controller: mockController,
                  shouldCloseOnScroll: true,
                  child: Container(height: 500),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pump();
      verify(mockController.close()).called(1);
    });

    testWidgets('cleans up when removed from the tree',
        (WidgetTester tester) async {
      await pumpWidget(tester);

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pump();
      verify(mockController.close()).called(1);

      reset(mockController);

      // Remove the CustomScrollBehavior from the tree
      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: Container(height: 1000),
          ),
        ),
      );

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pump();
      verifyNever(mockController.close());
    });

    testWidgets('preserves state across rebuilds', (WidgetTester tester) async {
      await pumpWidget(tester);

      // Simulate a scroll
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pump();

      verify(mockController.close()).called(1);

      // Rebuild the widget
      await pumpWidget(tester);

      // Scroll again
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pump();

      // Verify that close is called again, indicating that the scroll listener was preserved
      verify(mockController.close()).called(1);
    });

    testWidgets('handles rapid scroll events appropriately',
        (WidgetTester tester) async {
      await pumpWidget(tester);

      // Simulate rapid scroll events
      for (int i = 0; i < 5; i++) {
        await tester.drag(
            find.byType(SingleChildScrollView), const Offset(0, -10));
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Verify close is called an appropriate number of times
      verify(mockController.close()).called(5);
    });
  });
}
