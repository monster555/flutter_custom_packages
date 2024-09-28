import 'package:custom_slide_context_tile/custom_slide_context_tile.dart';
import 'package:custom_slide_context_tile/src/animations/animation_strategy.dart';
import 'package:custom_slide_context_tile/src/animations/parallax_animation.dart';
import 'package:custom_slide_context_tile/src/animations/pull_animation.dart';
import 'package:custom_slide_context_tile/src/animations/reveal_animation.dart';
import 'package:custom_slide_context_tile/src/utils/action_size_calculator.dart';
import 'package:custom_slide_context_tile/src/utils/animation_helpers.dart';
import 'package:custom_slide_context_tile/src/utils/custom_scroll_behavior.dart';
import 'package:custom_slide_context_tile/src/utils/haptic_feedback_helper.dart';
import 'package:custom_slide_context_tile/src/widgets/context_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSlideContextTile extends StatefulWidget {
  /// Creates a [CustomSlideContextTile] without a context menu.
  ///
  /// Use this constructor when you only need sliding actions without
  /// a long-press context menu. This is useful for scenarios where
  /// you want to maintain a simpler interaction model.
  ///
  /// [title] is the primary content of the tile, typically a text widget.
  /// [subtitle] is optional additional content displayed below the title.
  /// [leading] and [trailing] define the leading and trailing widgets.
  /// [leadingActions] and [trailingActions] define the sliding actions.
  /// [actionExecutionThreshold] sets the sensitivity for executing actions.
  /// [revealAnimationType] determines how actions are animated into view.
  /// [controller] can be provided for external state management.
  /// [shouldCloseOnScroll] determines if the tile should close when scrolling.
  /// [onTap] is called when the tile is tapped (when not sliding).
  const CustomSlideContextTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.leadingActions = const [],
    this.trailingActions = const [],
    this.actionExecutionThreshold = 100.0,
    this.revealAnimationType = RevealAnimationType.reveal,
    this.controller,
    this.shouldCloseOnScroll = true,
    this.onTap,
  }) : enableContextMenu = false;

  /// Creates a [CustomSlideContextTile] with a context menu.
  ///
  /// Use this constructor when you want both sliding actions and
  /// a long-press context menu. This provides a richer interaction
  /// model, allowing users to access actions through both sliding
  /// and long-pressing.
  ///
  /// The parameters are the same as the default constructor, but
  /// [enableContextMenu] is set to true.
  const CustomSlideContextTile.withContextMenu({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.leadingActions = const [],
    this.trailingActions = const [],
    this.actionExecutionThreshold = 100.0,
    this.revealAnimationType = RevealAnimationType.reveal,
    this.controller,
    this.shouldCloseOnScroll = true,
    this.onTap,
  }) : enableContextMenu = true;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget. This field is required and cannot be null.
  /// It's displayed as the main content of the tile, similar to a CupertinoListTile's title.
  final Widget title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget. This field is optional and can be null.
  /// When provided, it adds a second line of text below the [title],
  /// offering additional context or information about the list item.
  final Widget? subtitle;

  /// An optional leading widget displayed on the left side of the tile. This is
  /// typically an [Icon] or [Image] widget.
  final Widget? leading;

  /// An optional trailing widget displayed on the right side of the tile. This is
  /// usually a right chevron icon (e.g. CupertinoListTileChevron), or an Icon.
  final Widget? trailing;

  /// Actions to be displayed on the leading (left) side when sliding.
  /// These actions are revealed when the user slides the tile to the right.
  final List<MenuAction> leadingActions;

  /// Actions to be displayed on the trailing (right) side when sliding.
  /// These actions are revealed when the user slides the tile to the left.
  final List<MenuAction> trailingActions;

  /// The threshold beyond which an action is considered for execution.
  /// This value determines how far the user needs to slide beyond the
  /// full reveal of actions to trigger the default action.
  final double actionExecutionThreshold;

  /// The type of animation to use when revealing actions.
  /// This affects how the actions appear and move as the tile is slid.
  final RevealAnimationType revealAnimationType;

  /// An optional controller to manage the slidable state externally.
  /// If provided, this allows for programmatic control of the slidable.
  final CustomSlidableController? controller;

  /// Determines whether the context menu is enabled for this tile.
  /// When true, a long press on the tile will reveal a context menu.
  final bool enableContextMenu;

  /// Determines whether the tile should close when the user scrolls.
  /// Defaults to true.
  final bool shouldCloseOnScroll;

  /// Called when the user taps the tile.
  ///
  /// This callback is not invoked if the tile is currently sliding or if
  /// actions are revealed. It's only active when the tile is in its default,
  /// closed state. Use this to handle navigation or to trigger actions that
  /// should occur when the entire tile is tapped.
  final VoidCallback? onTap;

  @override
  State<CustomSlideContextTile> createState() => _CustomSlideContextTileState();
}

class _CustomSlideContextTileState extends State<CustomSlideContextTile>
    with TickerProviderStateMixin {
  static const double _screenWidthThresholdFactor = 0.4;
  static const double _maxWidthFactor = 0.9;

  double _offset = 0.0;
  double maxLeadingOffset = 0.0;
  double maxTrailingOffset = 0.0;

  bool _shouldExpandDefaultAction = false;

  final List<GlobalKey> _leadingActionKeys = [];
  final List<GlobalKey> _trailingActionKeys = [];
  final bool _actionExecuted = false;

  late AnimationController _controller;
  late Animation<double> _animation;
  late CustomSlidableController _internalController;

  late final AnimationStrategy _animationStrategy =
      _getAnimationStrategy(widget.revealAnimationType);

  // Helper method to merge actions
  late List<MenuAction> mergedActions = [
    ...widget.leadingActions,
    ...widget.trailingActions,
  ];

  double get actionExecutionThreshold {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxOffset = _offset > 0 ? maxLeadingOffset : maxTrailingOffset;

    // Calculate threshold based on maxOffset and screenWidth
    return maxOffset > screenWidth * _screenWidthThresholdFactor
        ? widget.actionExecutionThreshold
        : screenWidth * _screenWidthThresholdFactor;
  }

  late final bool _shouldDisplayLabels = widget.leadingActions.isNotEmpty &&
      widget.trailingActions.isNotEmpty &&
      widget.leadingActions.every((action) => action.label != null) &&
      widget.trailingActions.every((action) => action.label != null);

  Widget get leadingActions =>
      _wrapWithDragGesture(_animationStrategy.buildLeadingActions(
        widget.leadingActions,
        _leadingActionKeys,
        _offset,
        maxLeadingOffset,
        _shouldDisplayLabels,
        _shouldExpandDefaultAction,
        _internalController,
      ));

  Widget get trailingActions =>
      _wrapWithDragGesture(_animationStrategy.buildTrailingActions(
        widget.trailingActions,
        _trailingActionKeys,
        _offset,
        maxTrailingOffset,
        _shouldDisplayLabels,
        _shouldExpandDefaultAction,
        _internalController,
      ));

  /// Wrap the actions with GestureDetector to allow drag gestures
  Widget _wrapWithDragGesture(Widget actionWidget) {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior
            .translucent, // Ensures the drag gesture is recognized even if a tap happens.
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: actionWidget,
      ),
    );
  }

  MenuAction? get defaultLeadingAction {
    if (widget.leadingActions.isEmpty) {
      return null;
    }
    return widget.leadingActions.last;
  }

  MenuAction? get defaultTrailingAction {
    if (widget.trailingActions.isEmpty) {
      return null;
    }
    return widget.trailingActions.last;
  }

  /// Builds the child widget, which is a CupertinoListTile with the given title and subtitle.
  ///
  /// This getter creates a constrained CupertinoListTile that mimics the appearance
  /// of a standard list tile while integrating with the sliding functionality.
  Widget get child => ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 48,
        ),
        child: CupertinoListTile(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: widget.title,
          subtitle: widget.subtitle,
          leading: widget.leading,
          trailing: widget.trailing,
          onTap: _internalController.isOpen ? null : widget.onTap,
        ),
      );

  /// Determines if the tile can be dragged to the left.
  ///
  /// Returns true if there are trailing actions or if the tile is already offset to the right.
  bool get canDragLeft => widget.trailingActions.isNotEmpty || _offset > 0;

  /// Determines if the tile can be dragged to the right.
  ///
  /// Returns true if there are leading actions or if the tile is already offset to the left.
  bool get canDragRight => widget.leadingActions.isNotEmpty || _offset < 0;

  /// Determines if the context menu should be enabled.
  ///
  /// Returns true if context menu is enabled, the tile is not offset, and there are actions available.
  bool get isContextMenuEnabled =>
      widget.enableContextMenu && _offset == 0.0 && mergedActions.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _leadingActionKeys
        .addAll(widget.leadingActions.map((_) => GlobalKey()).toList());
    _trailingActionKeys
        .addAll(widget.trailingActions.map((_) => GlobalKey()).toList());

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..addListener(() {
        double newOffset = _animation.value;

        if (newOffset != _offset) {
          setState(() {
            _offset = newOffset;
          });
        }

        _internalController.updateOffset(_offset);

        if (_offset == 0) {
          _shouldExpandDefaultAction = false;
        }
      });

    _animation = Tween<double>(begin: 0.0, end: 0.0).animate(_controller);

    // Use the provided controller or create a new one
    _internalController = widget.controller ?? CustomSlidableController();
    _initializeController(_internalController);
  }

  /// Initializes the internal or provided slidable controller.
  ///
  /// This method sets up the callbacks for opening and closing the slidable,
  /// ensuring that the controller can properly manage the slidable's state.
  void _initializeController(CustomSlidableController controller) {
    controller.openLeadingCallback = _openLeading;
    controller.openTrailingCallback = _openTrailing;
    controller.closeCallback = _close;
  }

  /// Opens the leading (left) actions.
  ///
  /// This method is called when the slidable needs to reveal its leading actions,
  /// either programmatically or in response to a user interaction.
  void _openLeading() => animateToOffset(maxLeadingOffset);

  /// Opens the trailing (right) actions.
  ///
  /// This method is called when the slidable needs to reveal its trailing actions,
  /// either programmatically or in response to a user interaction.
  void _openTrailing() => animateToOffset(-maxTrailingOffset);

  /// Closes the slidable, returning it to its initial state.
  ///
  /// This method animates the slidable back to its closed position, hiding all actions.
  void _close() => animateToOffset(0.0);

  /// Selects the appropriate animation strategy based on the reveal type.
  ///
  /// This method returns an [AnimationStrategy] instance that corresponds to the
  /// [RevealAnimationType] specified in the widget's properties.
  AnimationStrategy _getAnimationStrategy(RevealAnimationType type) {
    switch (type) {
      case RevealAnimationType.parallax:
        return ParallaxAnimation();

      case RevealAnimationType.pull:
        return PullAnimation();

      case RevealAnimationType.reveal:
      default:
        return RevealAnimation();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sizes = calculateActionSizes(
        _leadingActionKeys,
        _trailingActionKeys,
      );

      setState(() {
        maxLeadingOffset = sizes.leadingWidth;
        maxTrailingOffset = sizes.trailingWidth;
      });
    });
  }

  /// Handles the horizontal drag update to reveal actions.
  ///
  /// This method updates the offset of the slidable based on the user's drag,
  /// reveals actions, and manages overscroll behavior and haptic feedback.
  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final double delta = details.primaryDelta ?? 0;

    setState(() {
      if ((delta > 0 && canDragRight) || (delta < 0 && canDragLeft)) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        _offset += delta;

        // Determine the maximum offset based on drag direction
        double maxOffset = _offset > 0 ? maxLeadingOffset : maxTrailingOffset;

        // Check if we've fully revealed the actions and are starting to overscroll
        if (_offset.abs() > maxOffset) {
          // Calculate how much we've overscrolled
          double overscroll = _offset.abs() - maxOffset;

          // Determine if we should expand
          bool shouldExpandDefaultAction =
              overscroll > actionExecutionThreshold;

          // Trigger haptic feedback if we're transitioning into the expanded state
          if (shouldExpandDefaultAction && !_shouldExpandDefaultAction) {
            triggerHapticFeedback();
          } else if (!shouldExpandDefaultAction && _shouldExpandDefaultAction) {
            triggerHapticFeedback();
            _shouldExpandDefaultAction = false;
          }

          _shouldExpandDefaultAction = shouldExpandDefaultAction;
        }

        // Clamp the offset to 90% of the screen width to prevent excessive
        // overscroll
        final maxWidth = screenWidth * _maxWidthFactor;
        _offset = _offset.clamp(-maxWidth, maxWidth);
      }
    });
  }

  /// Handles the end of a horizontal drag, determining the final position.
  ///
  /// This method calculates the target offset based on the drag velocity and current position,
  /// and animates the slidable to its final state (open or closed).
  void _onHorizontalDragEnd(DragEndDetails details) {
    double velocity = details.velocity.pixelsPerSecond.dx;
    double targetOffset = determineTargetOffset(
      _offset,
      velocity,
      maxLeadingOffset,
      maxTrailingOffset,
      actionExecutionThreshold,
      defaultLeadingAction?.onPressed,
      defaultTrailingAction?.onPressed,
      _actionExecuted,
    );

    animateToOffset(targetOffset);
  }

  /// Closes the slidable when tapped.
  ///
  /// This method is called when the user taps on the main content of the slidable,
  /// causing it to close if it's currently open.
  void _onTap() => animateToOffset(0.0);

  /// Animates the slidable to a target offset.
  ///
  /// This method sets up and starts the animation to smoothly transition the slidable
  /// to the specified offset, updating the UI as the animation progresses.
  void animateToOffset(double targetOffset) {
    _animation = Tween<double>(begin: _offset, end: targetOffset).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_offset < 0) ...[
          leadingActions,
          trailingActions,
        ] else ...[
          trailingActions,
          leadingActions,
        ],
        GestureDetector(
          key: const ValueKey<String>('gesture-detector'),
          behavior: HitTestBehavior.deferToChild,
          onTap: _onTap,
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: CustomScrollBehavior(
            controller: _internalController,
            shouldCloseOnScroll: widget.shouldCloseOnScroll,
            child: Transform.translate(
              offset: Offset(_offset, 0),
              child: isContextMenuEnabled
                  ? ContextMenu(
                      actions: mergedActions,
                      child: child,
                    )
                  : child,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
