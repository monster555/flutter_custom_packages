import 'package:custom_expandable_slider/src/constants.dart';
import 'package:custom_expandable_slider/src/widgets/slider_thumb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A customizable expandable slider widget.
///
/// This widget provides a slider that expands when interacted with,
/// allowing for precise value selection.
class CustomExpandableSlider extends StatefulWidget {
  static const BorderRadius _defaultBorderRadius =
      BorderRadius.all(Radius.circular(8.0));

  /// Callback function that is called when the progress changes.
  /// The function receives the new progress value as a parameter.
  final Function(double) onProgressChanged;

  /// The width of the slider.
  final double width;

  /// The height of the slider.
  final double height;

  /// The initial value of the slider.
  final double initialValue;

  /// The color of the slider.
  final Color color;

  /// The background color of the slider.
  final Color backgroundColor;

  /// The border of the slider. This is optional.
  final BoxBorder? border;

  /// The border radius of the slider.
  final BorderRadius borderRadius;

  /// Whether haptics are enabled for the slider.
  final bool enableHaptics;

  /// Whether to show the thumb or not
  final bool showThumb;

  /// Creates an [CustomExpandableSlider] widget.
  ///
  /// The [CustomExpandableSlider] is a customizable slider widget that can expand and contract
  /// based on user interaction. It is useful for scenarios where you need a slider
  /// with additional visual customization and haptic feedback.
  ///
  /// The [width], [height], and [onProgressChanged] parameters are required and must not be null.
  ///
  /// The [initialValue] parameter must be between 0.0 and 1.0, inclusive, and defaults to 0.0.
  ///
  /// The [color] parameter specifies the color of the slider and defaults to `Colors.blue`.
  ///
  /// The [backgroundColor] parameter specifies the background color of the slider and defaults to `Colors.grey`.
  ///
  /// The [border] parameter allows you to specify a border for the slider.
  ///
  /// The [borderRadius] parameter specifies the border radius of the slider and defaults to `BorderRadius.all(Radius.circular(8.0))`.
  ///
  /// The [enableHaptics] parameter specifies whether haptic feedback is enabled and defaults to true.
  ///
  /// The [showThumb] parameter specifies whether to show the thumb or not and defaults to true.
  ///
  /// Example usage:
  /// ```dart
  /// ExpandableSlider(
  ///   width: 200.0,
  ///   height: 50.0,
  ///   initialValue: 0.5,
  ///   onProgressChanged: (value) {
  ///     print('Progress changed: $value');
  ///   },
  /// )
  /// ```
  const CustomExpandableSlider({
    required this.width,
    required this.height,
    required this.onProgressChanged,
    this.initialValue = 0.0,
    this.color = Colors.red,
    this.backgroundColor = Colors.grey,
    this.border,
    this.borderRadius = _defaultBorderRadius,
    this.enableHaptics = true,
    this.showThumb = true,
    super.key,
  })  : assert(width > 0),
        assert(height > 0),
        assert(initialValue >= 0 && initialValue <= 1);

  /// Creates an [CustomExpandableSlider] with thumb enabled by default.
  ///
  /// The [CustomExpandableSlider] is a customizable slider widget that can expand and contract
  /// based on user interaction. It is useful for scenarios where you need a slider
  /// with additional visual customization and haptic feedback.
  ///
  /// The [width], [height], and [onProgressChanged] parameters are required and must not be null.
  ///
  /// The [initialValue] parameter must be between 0.0 and 1.0, inclusive, and defaults to 0.0.
  ///
  /// This constructor sets [showThumb] to true by default, making the thumb visible during
  /// interaction without needing to explicitly set the parameter.
  static CustomExpandableSlider withThumb({
    required double width,
    required double height,
    required Function(double) onProgressChanged,
    double initialValue = 0.0,
    Color color = Colors.green,
    Color backgroundColor = Colors.grey,
    BoxBorder? border,
    BorderRadius borderRadius = _defaultBorderRadius,
    bool enableHaptics = true,
  }) {
    return CustomExpandableSlider(
      width: width,
      height: height,
      onProgressChanged: onProgressChanged,
      initialValue: initialValue,
      color: color,
      backgroundColor: backgroundColor,
      border: border,
      borderRadius: borderRadius,
      enableHaptics: enableHaptics,
      showThumb: true,
    );
  }

  @override
  State<CustomExpandableSlider> createState() => _CustomExpandableSliderState();
}

class _CustomExpandableSliderState extends State<CustomExpandableSlider>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final ValueNotifier<double> _progressNotifier;

  List<BoxShadow> _getActiveShadow() => [
        BoxShadow(
          color: widget.color.withValues(alpha: 0.25),
          blurRadius: 16.0,
          spreadRadius: 2.0,
        )
      ];

  double _startDrag = 0.0;

  bool _isDragging = false;

  late Color _thumbTextColor;

  @override
  void initState() {
    super.initState();
    _progressNotifier = ValueNotifier(widget.initialValue);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    _thumbTextColor = _computeThumbTextColor();
  }

  @override
  void dispose() {
    _controller.dispose();
    _progressNotifier.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomExpandableSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.color != oldWidget.color) {
      _thumbTextColor = _computeThumbTextColor();
    }

    if (widget.initialValue != oldWidget.initialValue) {
      _progressNotifier.value = widget.initialValue;
    }
  }

  /// Updates the dragging state and triggers a rebuild if needed.
  void _handleDragState(bool isDragging) {
    if (_isDragging == isDragging) return;
    setState(() => _isDragging = isDragging);
  }

  /// Triggers haptic feedback if enabled.
  ///
  /// Used when the slider reaches bounds (0.0 or 1.0).
  void _tryHapticFeedback() {
    if (!widget.enableHaptics) return;

    HapticFeedback.mediumImpact();
  }

  List<BoxShadow>? get shadow => _isDragging ? _getActiveShadow() : null;

  /// Computes the appropriate text color for the thumb based on the slider's color.
  ///
  /// This method estimates the brightness of the provided slider color and returns
  /// a contrasting color for the thumb text to ensure readability.
  ///
  /// Returns:
  /// - [Colors.white] if the estimated brightness of the slider color is dark.
  /// - [Colors.black] if the estimated brightness of the slider color is light.
  Color _computeThumbTextColor() {
    final brightness = ThemeData.estimateBrightnessForColor(widget.color);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => _forward(),
          onTapUp: (_) => _reverse(),
          onHorizontalDragStart: _onHorizontalDragStart,
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: AnimatedBuilder(
              animation: _progressNotifier,
              builder: (context, child) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Transform(
                      transform: Matrix4.identity()
                        ..scale(
                          1.0 + (_animation.value * 0.1),
                          1.0 + (_animation.value * 0.5),
                        ),
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          _buildBackground(),
                          _buildProgressIndicator(),
                        ],
                      ),
                    ),
                    if (widget.showThumb) _buildThumb(),
                  ],
                );
              }),
        );
      },
    );
  }

  Widget _buildBackground() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: DecoratedBox(
        key: ExpandableSliderConstants.backgroundKey,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: widget.borderRadius,
          border: widget.border,
          boxShadow: shadow,
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [widget.color, widget.backgroundColor],
        stops: [_progressNotifier.value, _progressNotifier.value],
      ).createShader(bounds),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: DecoratedBox(
          key: ExpandableSliderConstants.progressKey,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: widget.borderRadius,
          ),
        ),
      ),
    );
  }

  Widget _buildThumb() {
    final progress = _progressNotifier.value;
    return Positioned(
      left: (widget.width * progress - ExpandableSliderConstants.thumbWidth)
          .clamp(0, widget.width - ExpandableSliderConstants.thumbWidth * 2),
      top: -ExpandableSliderConstants.thumbHeight,
      child: SliderThumb(
        isDragging: _isDragging,
        color: widget.color,
        borderRadius: widget.borderRadius,
        textColor: _thumbTextColor,
        progress: progress,
      ),
    );
  }

  void _updateProgress(double progress) {
    final newProgress = progress.clamp(0.0, 1.0);
    if (_progressNotifier.value == newProgress) return;

    _progressNotifier.value = newProgress;

    widget.onProgressChanged(newProgress);

    if (newProgress == 0.0 || newProgress == 1.0) {
      _tryHapticFeedback();
    }
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _startDrag = details.localPosition.dx;

    _handleDragState(true);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isDragging) _reverse();

    _handleDragState(false);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final delta = (details.localPosition.dx - _startDrag) / widget.width;
    _startDrag = details.localPosition.dx;
    _updateProgress(_progressNotifier.value + delta);
  }

  void _forward() {
    _controller.forward();
    _tryHapticFeedback();
    _handleDragState(true);
  }

  void _reverse() {
    _controller.reverse();
    _tryHapticFeedback();
    _handleDragState(false);
  }
}
