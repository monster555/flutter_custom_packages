import 'package:custom_slide_context_tile/custom_slide_context_tile.dart';
import 'package:custom_slide_context_tile/src/animations/parallax_animation.dart';
import 'package:custom_slide_context_tile/src/utils/menu_action_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ParallaxAnimation', () {
    late ParallaxAnimation animation;
    late CustomSlidableController mockController;

    setUp(() {
      animation = ParallaxAnimation();

      mockController = CustomSlidableController();
    });

    testWidgets('buildLeadingActions creates correct number of widgets',
        (WidgetTester tester) async {
      final actions =
          List.generate(3, (index) => Container(key: ValueKey('action$index')));
      final keys = List.generate(3, (index) => GlobalKey());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: animation.buildLeadingActions(
                actions, keys, 100, 200, true, false, mockController),
          ),
        ),
      );

      expect(find.byType(Container), findsNWidgets(3));
    });

    testWidgets('buildTrailingActions creates correct number of widgets',
        (WidgetTester tester) async {
      final actions = List.generate(
        3,
        (index) => MenuAction(
          key: ValueKey('action$index'),
          icon: Icons.home,
          onPressed: () {},
        ),
      );

      final keys = List.generate(3, (index) => GlobalKey());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: animation.buildTrailingActions(
                actions, keys, -100, 200, true, false, mockController),
          ),
        ),
      );

      expect(find.byType(MenuAction), findsNWidgets(3));
    });

    testWidgets('buildLeadingActions applies translation',
        (WidgetTester tester) async {
      final actions = List.generate(
        5,
        (index) => MenuAction(
          key: ValueKey('action$index'),
          icon: Icons.home,
          onPressed: () {},
        ),
      );

      final keys = List.generate(5, (index) => GlobalKey());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: animation.buildLeadingActions(
                actions, keys, 100, 200, true, false, mockController),
          ),
        ),
      );

      final menuActions =
          tester.widgetList<MenuAction>(find.byType(MenuAction));
      expect(menuActions.length, 5);

      final transforms =
          tester.widgetList<Transform>(find.byType(Transform)).toList();

      // Check that translations are applied
      bool allZero = true;
      bool allSame = true;
      double? previousTranslation;

      for (var transform in transforms) {
        final currentTranslation = transform.transform.getTranslation().x;
        if (currentTranslation != 0) {
          allZero = false;
        }
        if (previousTranslation != null &&
            currentTranslation != previousTranslation) {
          allSame = false;
        }
        previousTranslation = currentTranslation;
      }

      // Ensure that not all translations are zero and that they're not all the same
      expect(allZero, isFalse,
          reason: 'At least one translation should be non-zero');
      expect(allSame, isFalse,
          reason: 'Not all translations should be the same');
    });

    testWidgets('buildTrailingActions applies translation',
        (WidgetTester tester) async {
      final actions = List.generate(
        5,
        (index) => MenuAction(
          key: ValueKey('action$index'),
          icon: Icons.home,
          onPressed: () {},
        ),
      );

      final keys = List.generate(5, (index) => GlobalKey());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: animation.buildTrailingActions(
                actions, keys, -100, 200, true, false, mockController),
          ),
        ),
      );

      final menuActions =
          tester.widgetList<MenuAction>(find.byType(MenuAction));
      expect(menuActions.length, 5);

      final transforms = tester.widgetList<Transform>(find.byType(Transform));

      // Check that translations are applied and decrease for each action
      double previousTranslation =
          (transforms.first.transform.getTranslation().x);
      for (var transform in transforms.skip(1)) {
        final currentTranslation = transform.transform.getTranslation().x;
        expect(currentTranslation, lessThanOrEqualTo(previousTranslation));
        previousTranslation = currentTranslation;
      }
    });

    testWidgets('applies default constraints', (WidgetTester tester) async {
      final actions = [
        MenuAction(
          key: const ValueKey('action'),
          icon: Icons.home,
          onPressed: () {},
        )
      ];
      final keys = [GlobalKey()];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: animation.buildLeadingActions(
                actions, keys, 100, 200, true, false, mockController),
          ),
        ),
      );

      final constrainedBox =
          tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox)).last;

      expect(constrainedBox.constraints.minWidth, 64);
      expect(constrainedBox.constraints.minHeight, 48);
    });

    testWidgets('respects showLabels parameter', (WidgetTester tester) async {
      final actions = [Container(key: const ValueKey('action'))];
      final keys = [GlobalKey()];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: animation.buildLeadingActions(
                actions, keys, 100, 200, true, false, mockController),
          ),
        ),
      );

      final menuActionScope =
          tester.widget<MenuActionScope>(find.byType(MenuActionScope));
      expect(menuActionScope.showLabels, isTrue);
    });
  });
}
