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
  /// [child] is the main content of the tile.
  /// [manager] is required to coordinate with other slidables.
  /// [leadingActions] and [trailingActions] define the sliding actions.
  /// [actionExecutionThreshold] sets the sensitivity for executing actions.
  /// [revealAnimationType] determines how actions are animated into view.
  /// [controller] can be provided for external state management.
  /// [shouldCloseOnScroll] determines if the tile should close when scrolling.
  const CustomSlideContextTile({
    super.key,
    required this.child,
    required this.manager,
    this.leadingActions = const [],
    this.trailingActions = const [],
    this.actionExecutionThreshold = 100.0,
    this.revealAnimationType = RevealAnimationType.reveal,
    this.controller,
    this.shouldCloseOnScroll = true,
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
    required this.child,
    required this.manager,
    this.leadingActions = const [],
    this.trailingActions = const [],
    this.actionExecutionThreshold = 100.0,
    this.revealAnimationType = RevealAnimationType.reveal,
    this.controller,
    this.shouldCloseOnScroll = true,
  }) : enableContextMenu = true;

  /// The main content of the tile that remains visible when not sliding.
  final Widget child;

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

  /// The manager responsible for coordinating multiple slidable widgets.
  /// This ensures that only one slidable is open at a time across the app.
  final SlidableManager manager;

  /// Determines whether the context menu is enabled for this tile.
  /// When true, a long press on the tile will reveal a context menu.
  final bool enableContextMenu;

  /// Determines whether the tile should close when the user scrolls.
  /// Defaults to true.
  final bool shouldCloseOnScroll;

  @override
  State<CustomSlideContextTile> createState() => _CustomSlideContextTileState();
}

class _CustomSlideContextTileState extends State<CustomSlideContextTile>
    with TickerProviderStateMixin {
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

  late final bool _shouldDisplayLabels = widget.leadingActions.isNotEmpty &&
      widget.trailingActions.isNotEmpty &&
      widget.leadingActions.every((action) => action.label != null) &&
      widget.trailingActions.every((action) => action.label != null);

  Widget get leadingActions => _animationStrategy.buildLeadingActions(
        widget.leadingActions,
        _leadingActionKeys,
        _offset,
        maxLeadingOffset,
        _shouldDisplayLabels,
        _shouldExpandDefaultAction,
        _internalController,
      );

  Widget get trailingActions => _animationStrategy.buildTrailingActions(
        widget.trailingActions,
        _trailingActionKeys,
        _offset,
        maxTrailingOffset,
        _shouldDisplayLabels,
        _shouldExpandDefaultAction,
        _internalController,
      );

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

  bool get canDragLeft => widget.trailingActions.isNotEmpty || _offset > 0;
  bool get canDragRight => widget.leadingActions.isNotEmpty || _offset < 0;

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

          _internalController.updateState(_offset != 0.0);
        }

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

  /// Opens the leading (right) actions.
  ///
  /// This method is called when the slidable needs to reveal its leading actions,
  /// either programmatically or in response to a user interaction.
  void _openLeading() {
    widget.manager.open(widget.controller!);
    animateToOffset(maxLeadingOffset);
  }

  /// Opens the trailing (left) actions.
  ///
  /// This method is called when the slidable needs to reveal its trailing actions,
  /// either programmatically or in response to a user interaction.
  void _openTrailing() {
    widget.manager.open(widget.controller!);
    animateToOffset(-maxTrailingOffset);
  }

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
        _offset += delta;

        // Determine the maximum offset based on drag direction
        double maxOffset = _offset > 0 ? maxLeadingOffset : maxTrailingOffset;

        // Check if we've fully revealed the actions and are starting to overscroll
        if (_offset.abs() > maxOffset) {
          // Calculate how much we've overscrolled
          double overscroll = _offset.abs() - maxOffset;

          // Determine if we should expand
          bool shouldExpandDefaultAction =
              overscroll > widget.actionExecutionThreshold;

          // Trigger haptic feedback if we're transitioning into the expanded state
          if (shouldExpandDefaultAction && !_shouldExpandDefaultAction) {
            triggerHapticFeedback();
          }

          _shouldExpandDefaultAction = shouldExpandDefaultAction;
        } else {
          triggerHapticFeedback();
          _shouldExpandDefaultAction = false;
        }

        // Clamp the offset to 90% of the screen width to prevent excessive
        // overscroll
        final maxWidth = MediaQuery.sizeOf(context).width * 0.9;
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
      widget.actionExecutionThreshold,
      defaultLeadingAction?.onPressed,
      defaultTrailingAction?.onPressed,
      _actionExecuted,
    );

    // Notify the manager if the slidable is opened
    if (targetOffset != 0.0) {
      widget.manager.open(_internalController);
    }

    animateToOffset(targetOffset);
  }

  /// Closes the slidable when tapped.
  ///
  /// This method is called when the user taps on the main content of the slidable,
  /// causing it to close if it's currently open.
  void _closeSlidable() => animateToOffset(0.0);

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
        Positioned.fill(
          child: GestureDetector(
            key: const ValueKey<String>('gesture-detector'),
            onTap: _closeSlidable,
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
                        child: widget.child,
                      )
                    : widget.child,
              ),
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
