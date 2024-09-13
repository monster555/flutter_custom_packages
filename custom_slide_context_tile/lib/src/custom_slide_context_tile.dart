import 'package:custom_slide_context_tile/custom_slide_context_tile.dart';
import 'package:custom_slide_context_tile/src/animations/animation_strategy.dart';
import 'package:custom_slide_context_tile/src/animations/parallax_animation.dart';
import 'package:custom_slide_context_tile/src/animations/pull_animation.dart';
import 'package:custom_slide_context_tile/src/animations/reveal_animation.dart';
import 'package:custom_slide_context_tile/src/utils/action_size_calculator.dart';
import 'package:custom_slide_context_tile/src/utils/animation_helpers.dart';
import 'package:custom_slide_context_tile/src/utils/haptic_feedback_helper.dart';
import 'package:custom_slide_context_tile/src/widgets/context_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSlideContextTile extends StatefulWidget {
  final Widget child;
  final List<MenuAction> leadingActions;
  final List<MenuAction> trailingActions;
  final double actionExecutionThreshold;
  final RevealAnimationType revealAnimationType;
  final CustomSlidableController? controller;
  final SlidableManager manager;
  final bool enableContextMenu;

  const CustomSlideContextTile({
    super.key,
    required this.child,
    required this.manager,
    this.leadingActions = const [],
    this.trailingActions = const [],
    this.actionExecutionThreshold = 100.0,
    this.revealAnimationType = RevealAnimationType.reveal,
    this.controller,
  }) : enableContextMenu = false;

  const CustomSlideContextTile.withContextMenu({
    super.key,
    required this.child,
    required this.manager,
    this.leadingActions = const [],
    this.trailingActions = const [],
    this.actionExecutionThreshold = 100.0,
    this.revealAnimationType = RevealAnimationType.reveal,
    this.controller,
  }) : enableContextMenu = true;

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
      );

  Widget get trailingActions => _animationStrategy.buildTrailingActions(
        widget.trailingActions,
        _trailingActionKeys,
        _offset,
        maxTrailingOffset,
        _shouldDisplayLabels,
        _shouldExpandDefaultAction,
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
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        double newOffset = _animation.value;

        if (newOffset != _offset) {
          setState(() {
            _offset = newOffset;
          });

          widget.controller?.updateState(_offset != 0.0);
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

  void _initializeController(CustomSlidableController controller) {
    controller.openLeadingCallback = _openLeading;
    controller.openTrailingCallback = _openTrailing;
    controller.closeCallback = _close;
  }

  void _openLeading() {
    widget.manager.open(widget.controller!);
    animateToOffset(maxLeadingOffset);
  }

  void _openTrailing() {
    widget.manager.open(widget.controller!);
    animateToOffset(-maxTrailingOffset);
  }

  void _close() => animateToOffset(0.0);

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

  void _closeSlidable() => animateToOffset(0.0);

  void animateToOffset(double targetOffset) {
    _animation = Tween<double>(begin: _offset, end: targetOffset).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Stack(
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
