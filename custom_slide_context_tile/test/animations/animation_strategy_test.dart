import 'package:custom_slide_context_tile/src/animations/animation_strategy.dart';
import 'package:custom_slide_context_tile/src/controller/custom_slidable_controller.dart';
import 'package:custom_slide_context_tile/src/utils/menu_action_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAnimationStrategy extends AnimationStrategy {
  List<Map<String, dynamic>> buildActionsCalls = [];

  @override
  Widget buildActions(
    List<Widget> actions,
    List<GlobalKey> keys,
    double offset,
    double maxOffset,
    bool showLabels,
    bool shouldExpandDefaultAction,
    bool isLeading,
    CustomSlidableController? slidableController,
  ) {
    buildActionsCalls.add({
      'actions': actions,
      'keys': keys,
      'offset': offset,
      'maxOffset': maxOffset,
      'showLabels': showLabels,
      'shouldExpandDefaultAction': shouldExpandDefaultAction,
      'isLeading': isLeading,
      'slidableController': slidableController,
    });
    return MenuActionScope(
      showLabels: showLabels,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: shouldExpandDefaultAction ? 1 : 0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        builder: (context, animationValue, child) {
          return Container();
        },
      ),
    );
  }

  @override
  double? calculateTranslation(
    int index,
    int actionCount,
    double offset,
    double totalWidth,
    bool isLeading,
  ) {
    return 0.0;
  }
}

void main() {
  group('AnimationStrategy', () {
    late AnimationStrategy strategy;
    late CustomSlidableController mockController;

    setUp(() {
      strategy = MockAnimationStrategy();
      mockController = CustomSlidableController();
    });

    group('calculateOverscroll', () {
      test('returns correct value for leading actions', () {
        expect(strategy.calculateOverscroll(100, 80, true), 20);
        expect(strategy.calculateOverscroll(70, 80, true), 0);
      });

      test('returns correct value for trailing actions', () {
        expect(strategy.calculateOverscroll(-100, 80, false), 20);
        expect(strategy.calculateOverscroll(-70, 80, false), 0);
      });

      test('returns 0 when offset is less than maxOffset for leading actions',
          () {
        expect(strategy.calculateOverscroll(50, 80, true), 0);
      });

      test(
          'returns 0 when offset is greater than -maxOffset for trailing actions',
          () {
        expect(strategy.calculateOverscroll(-50, 80, false), 0);
      });
    });

    group('calculateWidth', () {
      test('returns correct value', () {
        expect(strategy.calculateWidth(100, 4, 100), 25);
        expect(strategy.calculateWidth(100, 4, 0), null);
      });

      test('returns null when maxOffset is 0 or negative', () {
        expect(strategy.calculateWidth(100, 4, 0), null);
        expect(strategy.calculateWidth(100, 4, -10), null);
      });

      test('handles edge cases', () {
        expect(strategy.calculateWidth(0, 4, 100), 0);
        expect(strategy.calculateWidth(100, 1, 100), 100);
      });
    });

    group('calculateExpandedWidth', () {
      test('returns correct value for leading actions', () {
        expect(
          strategy.calculateExpandedWidth(0, 3, 100, 20, 0.5, true),
          closeTo(80, 0.01),
        );
        expect(
          strategy.calculateExpandedWidth(1, 3, 100, 20, 0.5, true),
          closeTo(10, 0.01),
        );
      });

      test('returns correct value for trailing actions', () {
        expect(
          strategy.calculateExpandedWidth(2, 3, 100, 20, 0.5, false),
          closeTo(80, 0.01),
        );
        expect(
          strategy.calculateExpandedWidth(1, 3, 100, 20, 0.5, false),
          closeTo(10, 0.01),
        );
      });

      test('handles edge cases', () {
        expect(strategy.calculateExpandedWidth(0, 1, 100, 20, 0, true), 100);
        expect(strategy.calculateExpandedWidth(0, 1, 100, 20, 1, true), 100);
      });
    });

    group('buildActions', () {
      testWidgets('creates correct widget structure',
          (WidgetTester tester) async {
        final strategy = MockAnimationStrategy();
        final actions = [Container(), Container()];
        final keys = [GlobalKey(), GlobalKey()];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: strategy.buildActions(
                  actions, keys, 10, 100, true, true, true, mockController),
            ),
          ),
        );

        expect(find.byType(MenuActionScope), findsOneWidget);
        expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
      });

      testWidgets('creates TweenAnimationBuilder with correct properties',
          (WidgetTester tester) async {
        final actions = [Container(), Container()];
        final keys = [GlobalKey(), GlobalKey()];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: strategy.buildActions(
                  actions, keys, 10, 100, true, true, true, mockController),
            ),
          ),
        );

        final tweenAnimationBuilder =
            tester.widget<TweenAnimationBuilder<double>>(
          find.byType(TweenAnimationBuilder<double>),
        );

        expect(tweenAnimationBuilder.tween.begin, 0);
        expect(tweenAnimationBuilder.tween.end, 1);
        expect(
            tweenAnimationBuilder.duration, const Duration(milliseconds: 300));
        expect(tweenAnimationBuilder.curve, Curves.fastOutSlowIn);
      });
    });

    group('buildLeadingActions and buildTrailingActions', () {
      testWidgets('call buildActions with correct parameters',
          (WidgetTester tester) async {
        final actions = [Container(), Container()];
        final keys = [GlobalKey(), GlobalKey()];

        strategy.buildLeadingActions(
            actions, keys, 10, 100, true, true, mockController);
        strategy.buildTrailingActions(
            actions, keys, 10, 100, true, true, mockController);

        expect((strategy as MockAnimationStrategy).buildActionsCalls.length, 2);

        expect((strategy as MockAnimationStrategy).buildActionsCalls[0], {
          'actions': actions,
          'keys': keys,
          'offset': 10.0,
          'maxOffset': 100.0,
          'showLabels': true,
          'shouldExpandDefaultAction': true,
          'isLeading': true,
          'slidableController': mockController,
        });

        expect((strategy as MockAnimationStrategy).buildActionsCalls[1], {
          'actions': actions,
          'keys': keys,
          'offset': 10.0,
          'maxOffset': 100.0,
          'showLabels': true,
          'shouldExpandDefaultAction': true,
          'isLeading': false,
          'slidableController': mockController,
        });
      });
    });

    group('buildActionItems', () {
      testWidgets('creates correct number of widgets with correct properties',
          (WidgetTester tester) async {
        final actions = [Container(), Container()];
        final keys = [GlobalKey(), GlobalKey()];

        final items =
            strategy.buildActionItems(actions, keys, 100, 20, 0.5, true, 10);

        expect(items.length, 2);
        expect(items[0].runtimeType, Transform);
        expect(items[1].runtimeType, Transform);
      });

      testWidgets('creates Transform widgets with correct translation',
          (WidgetTester tester) async {
        final actions = [Container(), Container()];
        final keys = [GlobalKey(), GlobalKey()];

        final items =
            strategy.buildActionItems(actions, keys, 100, 20, 0.5, true, 10);

        for (var item in items) {
          expect(item, isA<Transform>());
          final transform = item as Transform;
          expect(transform.transform.getTranslation().x,
              0.0); // Because mock returns 0.0
        }
      });

      testWidgets('creates widgets with correct structure and properties',
          (WidgetTester tester) async {
        final actions = [Container(), Container()];
        final keys = [GlobalKey(), GlobalKey()];

        final items =
            strategy.buildActionItems(actions, keys, 100, 20, 0.5, true, 10);

        expect(items.length, 2);

        for (var i = 0; i < items.length; i++) {
          expect(items[i], isA<Transform>());
          final transform = items[i] as Transform;

          expect(transform.child, isA<SizedBox>());
          final sizedBox = transform.child as SizedBox;

          expect(sizedBox.key, keys[i]);
          expect(sizedBox.width, isNotNull);

          expect(sizedBox.child, isA<ConstrainedBox>());
          final constrainedBox = sizedBox.child as ConstrainedBox;

          expect(
              constrainedBox.constraints, equals(strategy.defaultConstraints));
          expect(constrainedBox.child, equals(actions[i]));
        }
      });
    });

    group('calculateTranslation', () {
      test('returns 0.0 in mock implementation', () {
        expect(strategy.calculateTranslation(0, 2, 10, 100, true), 0.0);
      });
    });
  });
}
