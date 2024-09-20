import 'package:custom_slide_context_tile/src/controller/custom_slidable_controller.dart';
import 'package:custom_slide_context_tile/src/utils/menu_action_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MenuActionScope', () {
    group('Property Updates', () {
      testWidgets('provides and updates showLabels value to descendants',
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

      testWidgets('provides and updates isLeading value to descendants',
          (WidgetTester tester) async {
        bool? capturedIsLeading;

        await tester.pumpWidget(
          MenuActionScope(
            showLabels: true,
            isLeading: false,
            child: Builder(
              builder: (BuildContext context) {
                capturedIsLeading = MenuActionScope.of(context).isLeading;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(capturedIsLeading, isFalse);

        await tester.pumpWidget(
          MenuActionScope(
            showLabels: true,
            isLeading: true,
            child: Builder(
              builder: (BuildContext context) {
                capturedIsLeading = MenuActionScope.of(context).isLeading;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(capturedIsLeading, isTrue);
      });

      testWidgets(
          'provides and updates shouldExpandDefaultAction value to descendants',
          (WidgetTester tester) async {
        bool? capturedShouldExpandDefaultAction;

        await tester.pumpWidget(
          MenuActionScope(
            showLabels: true,
            shouldExpandDefaultAction: false,
            child: Builder(
              builder: (BuildContext context) {
                capturedShouldExpandDefaultAction =
                    MenuActionScope.of(context).shouldExpandDefaultAction;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(capturedShouldExpandDefaultAction, isFalse);

        await tester.pumpWidget(
          MenuActionScope(
            showLabels: true,
            shouldExpandDefaultAction: true,
            child: Builder(
              builder: (BuildContext context) {
                capturedShouldExpandDefaultAction =
                    MenuActionScope.of(context).shouldExpandDefaultAction;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(capturedShouldExpandDefaultAction, isTrue);
      });
    });

    group('Controller', () {
      testWidgets('provides controller to descendants',
          (WidgetTester tester) async {
        final controller = CustomSlidableController();
        CustomSlidableController? capturedController;

        await tester.pumpWidget(
          MenuActionScope(
            showLabels: true,
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                capturedController = MenuActionScope.of(context).controller;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(capturedController, equals(controller));
      });
    });

    group('Error Handling', () {
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
    });

    group('updateShouldNotify', () {
      test('updateShouldNotify returns correct value for all property changes',
          () {
        final controller1 = CustomSlidableController();
        final controller2 = CustomSlidableController();
        final baseWidget = MenuActionScope(
          showLabels: true,
          isLeading: true,
          shouldExpandDefaultAction: true,
          controller: controller1,
          child: Container(),
        );

        // Test showLabels change
        expect(
            baseWidget.updateShouldNotify(MenuActionScope(
              showLabels: false,
              isLeading: true,
              shouldExpandDefaultAction: true,
              controller: controller1,
              child: Container(),
            )),
            isTrue);

        // Test isLeading change
        expect(
            baseWidget.updateShouldNotify(MenuActionScope(
              showLabels: true,
              isLeading: false,
              shouldExpandDefaultAction: true,
              controller: controller1,
              child: Container(),
            )),
            isTrue);

        // Test shouldExpandDefaultAction change
        expect(
            baseWidget.updateShouldNotify(MenuActionScope(
              showLabels: true,
              isLeading: true,
              shouldExpandDefaultAction: false,
              controller: controller1,
              child: Container(),
            )),
            isTrue);

        // Test controller change
        expect(
            baseWidget.updateShouldNotify(MenuActionScope(
              showLabels: true,
              isLeading: true,
              shouldExpandDefaultAction: true,
              controller: controller2,
              child: Container(),
            )),
            isTrue);

        // Test no change
        expect(
            baseWidget.updateShouldNotify(MenuActionScope(
              showLabels: true,
              isLeading: true,
              shouldExpandDefaultAction: true,
              controller: controller1,
              child: Container(),
            )),
            isFalse);
      });
    });
  });
}
