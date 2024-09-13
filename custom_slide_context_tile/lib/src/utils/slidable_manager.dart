import 'package:custom_slide_context_tile/src/controller/custom_slidable_controller.dart';

class SlidableManager {
  CustomSlidableController? _openController;

  bool get isOpen => _openController != null;

  void open(CustomSlidableController controller) {
    // Close the currently open slidable
    if (_openController != null && _openController != controller) {
      _openController?.close();
    }
    // Open the new slidable
    _openController = controller;
  }

  void close() {
    _openController?.close();
    _openController = null;
  }
}
