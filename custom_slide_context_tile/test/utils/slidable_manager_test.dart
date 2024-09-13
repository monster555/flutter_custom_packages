import 'package:custom_slide_context_tile/src/controller/custom_slidable_controller.dart';
import 'package:custom_slide_context_tile/src/utils/slidable_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SlidableManager', () {
    late SlidableManager manager;
    late CustomSlidableController controller1;
    late CustomSlidableController controller2;

    setUp(() {
      manager = SlidableManager();
      controller1 = CustomSlidableController();
      controller2 = CustomSlidableController();
    });

    test('initially has no open controller', () {
      expect(manager.isOpen, isFalse);
    });

    test('opens a controller', () {
      manager.open(controller1);
      expect(manager.isOpen, isTrue);
    });

    test('closes the open controller', () {
      manager.open(controller1);
      manager.close();
      expect(manager.isOpen, isFalse);
    });

    test('opens a new controller and closes the previous one', () {
      bool controller1Closed = false;
      controller1.closeCallback = () => controller1Closed = true;

      manager.open(controller1);
      manager.open(controller2);

      expect(manager.isOpen, isTrue);
      expect(controller1Closed, isTrue);
    });

    test(
        'does not close the current controller when opening the same controller',
        () {
      bool controller1Closed = false;
      controller1.closeCallback = () => controller1Closed = true;

      manager.open(controller1);
      manager.open(controller1);

      expect(manager.isOpen, isTrue);
      expect(controller1Closed, isFalse);
    });

    test('close() does nothing when no controller is open', () {
      manager.close();
      expect(manager.isOpen, isFalse);
    });
  });
}
