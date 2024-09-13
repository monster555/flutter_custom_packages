import 'package:custom_slide_context_tile/src/controller/custom_slidable_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomSlidableController', () {
    late CustomSlidableController controller;

    setUp(() {
      controller = CustomSlidableController();
    });

    test('initial state is closed', () {
      expect(controller.isOpen, isFalse);
    });

    test('openLeading calls the openLeadingCallback', () {
      bool callbackCalled = false;
      controller.openLeadingCallback = () => callbackCalled = true;

      controller.openLeading();

      expect(callbackCalled, isTrue);
    });

    test('openTrailing calls the openTrailingCallback', () {
      bool callbackCalled = false;
      controller.openTrailingCallback = () => callbackCalled = true;

      controller.openTrailing();

      expect(callbackCalled, isTrue);
    });

    test('close calls the closeCallback', () {
      bool callbackCalled = false;
      controller.closeCallback = () => callbackCalled = true;

      controller.close();

      expect(callbackCalled, isTrue);
    });

    test('updateOffset updates isOpen state correctly', () {
      controller.updateOffset(0.0);
      expect(controller.isOpen, isFalse);

      controller.updateOffset(10.0);
      expect(controller.isOpen, isTrue);

      controller.updateOffset(-5.0);
      expect(controller.isOpen, isTrue);

      controller.updateOffset(0.0);
      expect(controller.isOpen, isFalse);
    });

    test('updateState updates isOpen state correctly', () {
      controller.updateState(true);
      expect(controller.isOpen, isTrue);

      controller.updateState(false);
      expect(controller.isOpen, isFalse);
    });

    test('callbacks are optional and do not throw when null', () {
      expect(() => controller.openLeading(), returnsNormally);
      expect(() => controller.openTrailing(), returnsNormally);
      expect(() => controller.close(), returnsNormally);
    });
  });
}
