import 'package:custom_popup/src/enums/arrow_direction.dart';
import 'package:custom_popup/src/popup/arrow_painter.dart';
import 'package:custom_popup/src/popup/custom_popup_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildTestWidget({
  required Widget child,
  bool showArrow = true,
  Color backgroundColor = Colors.blue,
  double contentRadius = 16.0,
  EdgeInsets contentPadding = const EdgeInsets.all(20.0),
  double arrowHorizontal = 8.0,
  ArrowDirection arrowDirection = ArrowDirection.top,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: CustomPopupContent(
          childKey: GlobalKey(),
          arrowKey: GlobalKey(),
          arrowHorizontal: arrowHorizontal,
          showArrow: showArrow,
          arrowDirection: arrowDirection,
          backgroundColor: backgroundColor,
          contentRadius: contentRadius,
          contentPadding: contentPadding,
          child: child,
        ),
      ),
    ),
  );
}

main() {
  group('CustomPopupContent', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: buildTestWidget(
                child: const Text('Basic functionality content'),
              ),
            ),
          ),
        ),
      );

      // Verify that the CustomPopupContent widget is present
      expect(find.byType(CustomPopupContent), findsOneWidget);

      // Verify that the Text widget is present
      expect(find.byType(Text), findsOneWidget);

      // Verify that the Text widget contains the correct content
      expect(find.text('Basic functionality content'), findsOneWidget);

      // Verify that the arrow widget is present
      expect(find.byKey(const ValueKey('popupArrow')), findsOneWidget);

      // Find the CustomPopupContent widget
      final popup =
          tester.widget<CustomPopupContent>(find.byType(CustomPopupContent));

      // Verify the content padding
      expect(popup.contentPadding, const EdgeInsets.all(20.0));

      // Verify the arrow visibility
      expect(popup.showArrow, true);

      // Verify the background color
      expect(popup.backgroundColor, Colors.blue);

      // Verify the content radius
      expect(popup.contentRadius, 16.0);

      // Verify the horizontal position of the arrow
      expect(popup.arrowHorizontal, 8.0);

      // Verify the arrow direction
      expect(popup.arrowDirection, ArrowDirection.top);

      // Find the CustomPaint widget
      final arrow = tester.firstWidget(find.byKey(const ValueKey('popupArrow')))
          as CustomPaint;

      // Verify the arrow painter is an ArrowPainter
      expect(arrow.painter, isA<ArrowPainter>());

      // Verify the arrow size
      expect(arrow.size, const Size(20.0, 8.0));
    });

    testWidgets('arrow direction', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: buildTestWidget(
                arrowDirection: ArrowDirection.bottom,
                child: const Text('Arrow direction content'),
              ),
            ),
          ),
        ),
      );

      // Find the CustomPopupContent widget
      final popup = tester.firstWidget(find.byType(CustomPopupContent))
          as CustomPopupContent;

      // Verify the arrow visibility
      expect(popup.showArrow, true);

      // Verify that the arrow widget is present
      expect(find.byKey(const ValueKey('popupArrow')), findsOneWidget);

      // Verify the arrow direction
      expect(popup.arrowDirection, ArrowDirection.bottom);
    });

    testWidgets('arrow is not rendered when showArrow is false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: buildTestWidget(
                arrowDirection: ArrowDirection.bottom,
                showArrow: false,
                child: const Text('Arrow direction content'),
              ),
            ),
          ),
        ),
      );

      // Find the CustomPopupContent widget
      final popup = tester.firstWidget(find.byType(CustomPopupContent))
          as CustomPopupContent;

      // Verify the arrow visibility
      expect(popup.showArrow, false);

      // Verify that the arrow widget is not present
      expect(find.byKey(const ValueKey('popupArrow')), findsNothing);
    });

    testWidgets('content padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: buildTestWidget(
                contentPadding: const EdgeInsets.all(36.0),
                child: const Text('Content padding content'),
              ),
            ),
          ),
        ),
      );

      // Verify that the CustomPopupContent widget is present
      expect(find.byType(CustomPopupContent), findsOneWidget);

      // Verify that the Text widget is present
      expect(find.byType(Text), findsOneWidget);

      // Verify that the Text widget contains the correct content
      expect(find.text('Content padding content'), findsOneWidget);

      // Find the CustomPopupContent widget
      final popup = tester.firstWidget(find.byType(CustomPopupContent))
          as CustomPopupContent;

      // Verify the content padding
      expect(popup.contentPadding, const EdgeInsets.all(36.0));
    });

    testWidgets('background color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: buildTestWidget(
                backgroundColor: Colors.red,
                child: const Text('Background color content'),
              ),
            ),
          ),
        ),
      );

      // Verify that the CustomPopupContent widget is present
      expect(find.byType(CustomPopupContent), findsOneWidget);

      // Verify that the Text widget is present
      expect(find.byType(Text), findsOneWidget);

      // Verify that the Text widget contains the correct content
      expect(find.text('Background color content'), findsOneWidget);

      // Find the CustomPopupContent widget
      final popup = tester.firstWidget(find.byType(CustomPopupContent))
          as CustomPopupContent;

      // Verify the background color
      expect(popup.backgroundColor, Colors.red);
    });

    testWidgets('content radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: buildTestWidget(
                contentRadius: 24.0,
                child: const Text('Content radius content'),
              ),
            ),
          ),
        ),
      );

      // Verify that the CustomPopupContent widget is present
      expect(find.byType(CustomPopupContent), findsOneWidget);

      // Verify that the Text widget is present
      expect(find.byType(Text), findsOneWidget);

      // Verify that the Text widget contains the correct content
      expect(find.text('Content radius content'), findsOneWidget);

      // Find the CustomPopupContent widget
      final popup = tester.firstWidget(find.byType(CustomPopupContent))
          as CustomPopupContent;

      // Verify the content radius
      expect(popup.contentRadius, 24.0);
    });

    testWidgets('arrow horizontal', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: buildTestWidget(
                arrowHorizontal: 16.0,
                child: const Text('Arrow horizontal content'),
              ),
            ),
          ),
        ),
      );

      // Verify that the CustomPopupContent widget is present
      expect(find.byType(CustomPopupContent), findsOneWidget);

      // Verify that the Text widget is present
      expect(find.byType(Text), findsOneWidget);

      // Verify that the Text widget contains the correct content
      expect(find.text('Arrow horizontal content'), findsOneWidget);

      // Find the CustomPopupContent widget
      final popup = tester.firstWidget(find.byType(CustomPopupContent))
          as CustomPopupContent;

      // Verify the horizontal position of the arrow
      expect(popup.arrowHorizontal, 16.0);
    });
  });
}
