import 'package:flutter/material.dart';

/// A widget that listens to mouse hover events and rebuilds its child based on
/// the hover state.
///
/// `HoverListener` is designed to provide a mechanism for widgets to react to
/// mouse hover events. It uses a `MouseRegion` to detect when the cursor enters
/// or exits the widget's area and updates its internal state accordingly. The widget
/// then rebuilds its child based on whether the mouse is currently hovering over it.
class HoverListener extends StatefulWidget {
  /// Creates a [HoverListener] widget.
  ///
  /// The [builder] parameter is a function that returns a widget based on the hover state.
  /// The widget is rebuilt every time the hover state changes.
  const HoverListener({super.key, required this.builder});

  /// A function that defines the child widget based on the hover state.
  final Widget Function(bool isHovered) builder;

  @override
  State<HoverListener> createState() => _HoverListenerState();
}

class _HoverListenerState extends State<HoverListener> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isHovered,
        builder: (context, isHovered, child) => widget.builder(isHovered),
      ),
    );
  }
}
