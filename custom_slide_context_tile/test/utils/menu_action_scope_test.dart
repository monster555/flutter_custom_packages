import 'package:custom_slide_context_tile/src/utils/menu_action_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MenuActionScope', () {
    testWidgets('provides showLabels value to descendants',
        (WidgetTester tester) async {
      bool? capturedShowLabels;

      await tester.pumpWidget(
        MenuActionScope(
          showLabels: true,
          child: Builder(
            builder: (BuildContext context) {
              capturedShowLabels = MenuActionScope.of(context).showLabels;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedShowLabels, isTrue);
    });

    testWidgets('updates descendants when showLabels changes',
        (WidgetTester tester) async {
      bool? capturedShowLabels;

      await tester.pumpWidget(
        MenuActionScope(
          showLabels: true,
          child: Builder(
            builder: (BuildContext context) {
              capturedShowLabels = MenuActionScope.of(context).showLabels;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedShowLabels, isTrue);

      await tester.pumpWidget(
        MenuActionScope(
          showLabels: false,
          child: Builder(
            builder: (BuildContext context) {
              capturedShowLabels = MenuActionScope.of(context).showLabels;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedShowLabels, isFalse);
    });

    testWidgets('throws assertion error when not found in context',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            return const SizedBox();
          },
        ),
      );

      expect(() => MenuActionScope.of(tester.element(find.byType(SizedBox))),
          throwsAssertionError);
    });

    test('updateShouldNotify returns true when showLabels changes', () {
      final oldWidget = MenuActionScope(showLabels: true, child: Container());
      final newWidget = MenuActionScope(showLabels: false, child: Container());

      expect(newWidget.updateShouldNotify(oldWidget), isTrue);
    });

    test('updateShouldNotify returns false when showLabels does not change',
        () {
      final oldWidget = MenuActionScope(showLabels: true, child: Container());
      final newWidget = MenuActionScope(showLabels: true, child: Container());

      expect(newWidget.updateShouldNotify(oldWidget), isFalse);
    });
  });
}
