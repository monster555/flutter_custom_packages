import 'package:flutter/material.dart';

/// A controller class for managing the state and actions of a `CustomSlideContextTile`.
///
/// [CustomSlidableController] provides methods to open, close, and update the state
/// of a slidable widget. It allows for programmatic control over the slidable's
/// behavior and keeps track of its open/closed state.
///
/// This controller is designed to be used in conjunction with a custom slidable
/// widget implementation, providing a way to interact with the slidable from
/// external code.
class CustomSlidableController {
  /// Callback function to open the leading actions of the slidable.
  VoidCallback? openLeadingCallback;

  /// Callback function to open the trailing actions of the slidable.
  VoidCallback? openTrailingCallback;

  /// Callback function to close the slidable.
  VoidCallback? closeCallback;

  /// Callback functions that are triggered when the slidable is opened or closed.
  ///
  /// - [onOpen] is called when the slidable is opened, allowing external components
  /// to respond to the open state.
  /// - [onClose] is called when the slidable is closed, allowing external components t
  /// o respond to the close state.
  VoidCallback? onOpen;
  VoidCallback? onClose;

  /// Internal flag to track whether the slidable is open.
  bool _isOpen = false;

  /// Opens the leading actions of the slidable.
  ///
  /// This method invokes the [openLeadingCallback] if it's set.
  /// It should be called when you want to programmatically open the leading actions.
  void openLeading() {
    openLeadingCallback?.call();
    onOpen?.call(); // Notify that it's opened
    _isOpen = true;
  }

  /// Opens the trailing actions of the slidable.
  ///
  /// This method invokes the [openTrailingCallback] if it's set.
  /// It should be called when you want to programmatically open the trailing actions.
  void openTrailing() {
    openTrailingCallback?.call();
    onOpen?.call(); // Notify that it's opened
    _isOpen = true;
  }

  /// Closes the slidable.
  ///
  /// This method invokes the [closeCallback] if it's set.
  /// It should be called when you want to programmatically close the slidable.
  void close() {
    closeCallback?.call();
    onClose?.call(); // Notify that it's closed
    _isOpen = false;
  }

  /// Updates the internal state based on the current offset of the slidable.
  ///
  /// [offset] is the current offset of the slidable content.
  /// The slidable is considered open if the offset is not zero.
  ///
  /// This method should be called whenever the slidable's offset changes to
  /// keep the controller's state in sync with the actual widget state.
  void updateOffset(double offset) => _isOpen = offset != 0.0;

  /// Directly updates the open/closed state of the slidable.
  ///
  /// [isOpen] is a boolean indicating whether the slidable is open (true) or closed (false).
  ///
  /// This method can be used to forcibly set the state of the slidable,
  /// which can be useful in scenarios where the state needs to be updated
  /// without an actual slide action.
  void updateState(bool isOpen) {
    _isOpen = isOpen;
    if (isOpen) {
      onOpen?.call(); // Notify if opened
    } else {
      onClose?.call(); // Notify if closed
    }
  }

  /// Returns whether the slidable is currently open.
  ///
  /// This getter provides a way to check the current state of the slidable.
  /// Returns true if the slidable is open, false otherwise.
  bool get isOpen => _isOpen;
}
