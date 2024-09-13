import 'package:custom_slide_context_tile/src/utils/action_size_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActionSizes', () {
    test('toString returns correct string representation', () {
      final sizes = ActionSizes(100.0, 200.0);
      expect(sizes.toString(), 'leadingWidth: 100.0, trailingWidth: 200.0');
    });
  });

  group('calculateActionSizes', () {
    testWidgets('calculates correct sizes for leading and trailing actions',
        (WidgetTester tester) async {
      final leadingKeys = List.generate(3, (_) => GlobalKey());
      final trailingKeys = List.generate(2, (_) => GlobalKey());

      await tester.pumpWidget(
        MaterialApp(
          home: Row(
            children: [
              ...leadingKeys
                  .map((key) => SizedBox(key: key, width: 50, height: 50)),
              ...trailingKeys
                  .map((key) => SizedBox(key: key, width: 75, height: 50)),
            ],
          ),
        ),
      );

      final sizes = calculateActionSizes(leadingKeys, trailingKeys);

      expect(sizes.leadingWidth, 150.0); // 3 * 50
      expect(sizes.trailingWidth, 150.0); // 2 * 75
    });

    testWidgets('handles empty key lists', (WidgetTester tester) async {
      final sizes = calculateActionSizes([], []);

      expect(sizes.leadingWidth, 0.0);
      expect(sizes.trailingWidth, 0.0);
    });

    testWidgets('calculates correct sizes for varying widths',
        (WidgetTester tester) async {
      final leadingKeys = List.generate(2, (_) => GlobalKey());
      final trailingKeys = List.generate(2, (_) => GlobalKey());

      await tester.pumpWidget(
        MaterialApp(
          home: Row(
            children: [
              SizedBox(key: leadingKeys[0], width: 50, height: 50),
              SizedBox(key: leadingKeys[1], width: 100, height: 50),
              SizedBox(key: trailingKeys[0], width: 75, height: 50),
              SizedBox(key: trailingKeys[1], width: 25, height: 50),
            ],
          ),
        ),
      );

      final sizes = calculateActionSizes(leadingKeys, trailingKeys);

      expect(sizes.leadingWidth, 200.0); // 2 * 100 (max width)
      expect(sizes.trailingWidth, 150.0); // 2 * 75 (max width)
    });
  });

  group('calculateTotalWidth', () {
    testWidgets('calculates correct total width', (WidgetTester tester) async {
      final keys = List.generate(3, (_) => GlobalKey());

      await tester.pumpWidget(
        MaterialApp(
          home: Row(
            children: [
              SizedBox(key: keys[0], width: 50, height: 50),
              SizedBox(key: keys[1], width: 75, height: 50),
              SizedBox(key: keys[2], width: 100, height: 50),
            ],
          ),
        ),
      );

      final totalWidth = calculateTotalWidth(keys);

      expect(totalWidth, 300.0); // 3 * 100 (max width)
    });

    testWidgets('handles empty key list', (WidgetTester tester) async {
      final totalWidth = calculateTotalWidth([]);

      expect(totalWidth, 0.0);
    });
  });
}
