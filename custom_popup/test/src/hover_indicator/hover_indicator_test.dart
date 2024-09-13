import 'package:custom_popup/src/hover_indicator/hover_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Helper function to create a HoverIndicator and pump the widget
  Widget buildHoverIndicator({
    required bool isHovered,
    required bool isDestructive,
    required ThemeData theme,
  }) {
    return MaterialApp(
      theme: theme,
      home: HoverIndicator(
        isHovered: isHovered,
        isDestructive: isDestructive,
        child: Container(),
      ),
    );
  }

  group('HoverIndicator', () {
    testWidgets('color changes correctly', (WidgetTester tester) async {
      final theme = ThemeData(
        colorScheme: const ColorScheme.light(),
      );
      // Test not hovered
      await tester.pumpWidget(
        buildHoverIndicator(
          isHovered: false,
          isDestructive: false,
          theme: theme,
        ),
      );

      expect(
        find.byType(AnimatedContainer),
        findsOneWidget,
      );

      expect(
        (tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)))
            .decoration,
        equals(
          BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );

      // Test hovered, not destructive
      await tester.pumpWidget(
        buildHoverIndicator(
          isHovered: true,
          isDestructive: false,
          theme: ThemeData(
            colorScheme: const ColorScheme.light(),
          ),
        ),
      );

      expect(
        (tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)))
            .decoration,
        equals(
          BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );

      // Test hovered, destructive
      await tester.pumpWidget(
        buildHoverIndicator(
          isHovered: true,
          isDestructive: true,
          theme: ThemeData(
            colorScheme: const ColorScheme.light(),
          ),
        ),
      );
      expect(
        (tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)))
            .decoration,
        equals(
          BoxDecoration(
            color: theme.colorScheme.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );
    });
  });
}
