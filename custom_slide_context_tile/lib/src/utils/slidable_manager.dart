import 'package:custom_slide_context_tile/src/controller/custom_slidable_controller.dart';

/// Manages the state of slidable widgets across an application.
///
/// [SlidableManager] is responsible for tracking which slidable widget is
/// currently open and ensuring that only one slidable is open at a time.
/// This class helps maintain consistency in the UI by automatically closing
/// previously opened slidables when a new one is opened.
class SlidableManager {
  /// The controller of the currently open slidable widget.
  ///
  /// This is null if no slidable is currently open.
  CustomSlidableController? _openController;

  /// Indicates whether any slidable widget is currently open.
  ///
  /// Returns true if a slidable is open, false otherwise.
  bool get isOpen => _openController != null;

  /// Opens a slidable widget and manages the state of previously opened slidables.
  ///
  /// This method performs the following actions:
  /// 1. If another slidable is already open, it closes that slidable.
  /// 2. Sets the provided [controller] as the currently open slidable.
  ///
  /// [controller] is the [CustomSlidableController] of the slidable to be opened.
  ///
  /// Usage:
  /// ```dart
  /// slidableManager.open(mySlidableController);
  /// ```
  void open(CustomSlidableController controller) {
    // Close the currently open slidable
    if (_openController != null && _openController != controller) {
      _openController?.close();
    }
    // Open the new slidable
    _openController = controller;
  }

  /// Closes the currently open slidable widget, if any.
  ///
  /// This method:
  /// 1. Calls the close method on the currently open slidable controller.
  /// 2. Resets the _openController to null, indicating no slidable is open.
  ///
  /// Usage:
  /// ```dart
  /// slidableManager.close();
  /// ```
  void close() {
    _openController?.close();
    _openController = null;
  }
}
