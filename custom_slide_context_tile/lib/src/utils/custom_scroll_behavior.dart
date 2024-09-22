import 'package:custom_slide_context_tile/src/controller/custom_slidable_controller.dart';
import 'package:flutter/material.dart';

/// A widget that manages scroll behavior in relation to a [CustomSlidableController].
///
/// This widget is designed to work in conjunction with slidable widgets, providing
/// the ability to automatically close open slidables when scrolling occurs within
/// the same scroll view.
///
/// Key features:
/// - Automatically closes slidables on scroll (optional)
/// - Works with a [CustomSlidableController] to manage slidable state
/// - Can be toggled on/off without rebuilding the widget tree
class CustomScrollBehavior extends StatefulWidget {
  /// Creates a [CustomScrollBehavior] widget.
  ///
  /// [controller] is the [CustomSlidableController] that manages the slidable state.
  /// [child] is the widget below this widget in the tree.
  /// [shouldCloseOnScroll] determines whether slidables should close when scrolling occurs.
  const CustomScrollBehavior({
    required this.controller,
    required this.child,
    this.shouldCloseOnScroll = true,
    super.key,
  });

  /// The controller that manages the state of associated slidable widgets.
  final CustomSlidableController controller;

  /// Determines whether slidables should automatically close when scrolling occurs.
  ///
  /// If true, any open slidables will be closed as soon as scrolling is detected.
  /// If false, slidables will remain open during scrolling.
  final bool shouldCloseOnScroll;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<CustomScrollBehavior> createState() => _CustomScrollBehaviorState();
}

class _CustomScrollBehaviorState extends State<CustomScrollBehavior> {
  /// The current scroll position being listened to.
  ScrollPosition? scrollPosition;

  /// The controller for the currently open Slidable.
  /// This ensures that only one Slidable can be open at a time.
  static CustomSlidableController? _currentlyOpen;

  // Getter to check if this controller is currently open
  bool get _isCurrentlyOpen => _currentlyOpen == widget.controller;

  // Getter to check if another Slidable is currently open
  bool get _isAnotherCurrentlyOpen =>
      _currentlyOpen != null && _currentlyOpen != widget.controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateScrollListener();
  }

  @override
  void didUpdateWidget(covariant CustomScrollBehavior oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shouldCloseOnScroll != widget.shouldCloseOnScroll) {
      _updateScrollListener();
    }
  }

  @override
  void initState() {
    super.initState();

    // Set up callbacks to track opening and closing of Slidable
    widget.controller.onOpen = () {
      setState(() {
        // Close any currently open Slidable when a new one is opened
        if (_isAnotherCurrentlyOpen) {
          _currentlyOpen!.close(); // Close the previously open Slidable
        }
        // Set this as currently open
        _currentlyOpen = widget.controller;
      });
    };

    widget.controller.onClose = () {
      setState(() {
        if (_isCurrentlyOpen) {
          // Reset if this was currently open
          _currentlyOpen = null;
        }
      });
    };
  }

  @override
  void dispose() {
    // If this Slidable is currently open, reset the tracker
    if (_isCurrentlyOpen) {
      _currentlyOpen = null;
    }
    _removeScrollListener();
    super.dispose();
  }

  /// Updates the scroll listener based on the current widget configuration.
  ///
  /// This method is called when the widget is first built and when its
  /// configuration changes.
  void _updateScrollListener() {
    _removeScrollListener();
    _addScrollListener();
  }

  /// Adds a scroll listener if `shouldCloseOnScroll` is true.
  ///
  /// This method attempts to find a [Scrollable] ancestor and attach
  /// a listener to its scroll position.
  void _addScrollListener() {
    if (widget.shouldCloseOnScroll) {
      scrollPosition = Scrollable.maybeOf(context)?.position;
      if (scrollPosition != null) {
        scrollPosition!.isScrollingNotifier.addListener(_handleScrollChange);
      }
    }
  }

  /// Removes the current scroll listener, if one exists.
  ///
  /// This method is called when the widget is disposed or when the
  /// scroll listener needs to be updated.
  void _removeScrollListener() {
    scrollPosition?.isScrollingNotifier.removeListener(_handleScrollChange);
  }

  /// Handles changes in the scroll state.
  ///
  /// If scrolling is detected and `shouldCloseOnScroll` is `true`,
  /// this method calls `close` on the [CustomSlidableController].
  void _handleScrollChange() {
    if (widget.shouldCloseOnScroll &&
        scrollPosition != null &&
        scrollPosition!.isScrollingNotifier.value) {
      widget.controller.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        // Close any currently open Slidable when a new one is touched
        if (_isAnotherCurrentlyOpen) {
          _currentlyOpen!.close(); // Close the previously open Slidable
        }
        // Set this as the currently open Slidable
        _currentlyOpen = widget.controller;
      },
      child: widget.child,
    );
  }
}
