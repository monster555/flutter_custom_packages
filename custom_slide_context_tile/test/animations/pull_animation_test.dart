import 'package:custom_slide_context_tile/src/animations/pull_animation.dart';
import 'package:custom_slide_context_tile/src/controller/custom_slidable_controller.dart';
import 'package:custom_slide_context_tile/src/utils/menu_action_scope.dart';
import 'package:custom_slide_context_tile/src/widgets/menu_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PullAnimation', () {
    late PullAnimation animation;
    late CustomSlidableController mockController;

    setUp(() {
      animation = PullAnimation();
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

    testWidgets('buildLeadingActions applies same translation to all actions',
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

      final transforms =
          tester.widgetList<Transform>(find.byType(Transform)).toList();

      // Only check the transforms for our actual actions
      for (var i = 0; i < actions.length; i++) {
        final transform = transforms[i];
        expect(transform.transform.getTranslation().x, equals(-100),
            reason: 'Transform at index $i should have x translation of -100');
      }
    });

    testWidgets('buildTrailingActions applies same translation to all actions',
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

      final transforms =
          tester.widgetList<Transform>(find.byType(Transform)).toList();

      // Only check the transforms for our actual actions
      for (var i = 0; i < actions.length; i++) {
        final transform = transforms[i];
        expect(transform.transform.getTranslation().x, equals(100),
            reason: 'Transform at index $i should have x translation of -100');
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
