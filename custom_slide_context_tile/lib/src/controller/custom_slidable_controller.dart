import 'package:flutter/material.dart';

class CustomSlidableController {
  VoidCallback? openLeadingCallback;
  VoidCallback? openTrailingCallback;
  VoidCallback? closeCallback;
  bool _isOpen = false;

  void openLeading() => openLeadingCallback?.call();

  void openTrailing() => openTrailingCallback?.call();

  void close() => closeCallback?.call();

  // Method to update the state based on the offset
  void updateOffset(double offset) => _isOpen = offset != 0.0;

  // Method to update the state based on the offset
  void updateState(bool isOpen) => _isOpen = isOpen;

  bool get isOpen => _isOpen;
}
