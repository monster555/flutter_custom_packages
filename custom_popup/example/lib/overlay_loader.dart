import 'package:flutter/material.dart';

/// A class that manages an overlay loader with fade animation.
class OverlayLoader {
  /// The overlay entry for the loader.
  OverlayEntry? _overlayEntry;

  /// The animation controller for the fade effect.
  AnimationController? _animationController;

  /// Shows the overlay loader.
  ///
  /// [context] is used to access the overlay and theme.
  void show(BuildContext context) {
    if (_overlayEntry != null) return; // Prevent multiple shows

    final OverlayState overlay = Overlay.of(context);

    _animationController = AnimationController(
      vsync: overlay,
      duration: const Duration(milliseconds: 150),
    )..forward();

    final Widget loader = _buildLoader(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildOverlay(loader),
    );

    overlay.insert(_overlayEntry!);
  }

  /// Closes the overlay loader.
  Future<void> close() async {
    if (_overlayEntry == null) return; // Nothing to close

    await _animationController?.reverse();
    _animationController?.dispose();
    _overlayEntry?.remove();

    _overlayEntry = null;
    _animationController = null;
  }

  /// Builds the loader widget.
  Widget _buildLoader(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }

  /// Builds the overlay with fade transition.
  Widget _buildOverlay(Widget loader) {
    return FadeTransition(
      opacity: _animationController!,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: close,
              child: const ColoredBox(color: Colors.black54),
            ),
          ),
          loader,
        ],
      ),
    );
  }
}
