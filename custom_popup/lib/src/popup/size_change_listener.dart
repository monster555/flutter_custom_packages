import 'package:flutter/material.dart';

/// A widget that listens for size changes of its child widget and notifies a
/// callback function when a change is detected.
///
/// This widget is useful for monitoring the size of a widget and triggering
/// actions or animations based on the size change.
///
/// The [onSizeChanged] callback is called whenever the size of the child widget
/// changes. The [child] is the widget whose size is being monitored.
class SizeChangeListener extends StatefulWidget {
  /// Creates a [SizeChangeListener] widget.
  ///
  /// The [onSizeChanged] and [child] parameters are required.
  const SizeChangeListener({
    super.key,
    required this.onSizeChanged,
    required this.child,
  });

  /// A callback function that is called whenever the size of the child widget
  /// changes.
  final ValueChanged<Size> onSizeChanged;

  /// The widget whose size changes are being monitored.
  final Widget child;

  @override
  State<SizeChangeListener> createState() => _SizeChangeListenerState();
}

class _SizeChangeListenerState extends State<SizeChangeListener> {
  /// The previous size of the child widget. Used to compare with the current
  /// size to detect changes.
  Size? _previousSize;

  @override
  Widget build(BuildContext context) {
    // Obtain the current size of the widget using MediaQuery.
    final size = MediaQuery.sizeOf(context);

    // Initialize _previousSize if it is null.
    _previousSize ??= size;

    // Check if the current size is different from the previous size.
    if (size != _previousSize) {
      // Notify the onSizeChanged callback with the new size.
      widget.onSizeChanged(size);

      // Update the _previousSize to the new size.
      _previousSize = size;
    }

    // Return the child widget to be displayed.
    return widget.child;
  }
}
