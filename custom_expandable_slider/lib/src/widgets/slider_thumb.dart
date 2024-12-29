import 'package:custom_expandable_slider/src/constants.dart';
import 'package:flutter/material.dart';

class SliderThumb extends StatelessWidget {
  const SliderThumb({
    super.key,
    required this.progress,
    required this.isDragging,
    required this.color,
    required this.borderRadius,
    required this.textColor,
  });

  final double progress;
  final bool isDragging;
  final Color color;
  final BorderRadius borderRadius;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final progressValue = (progress * 100).round().toStringAsFixed(0);

    return MergeSemantics(
      child: AnimatedOpacity(
        duration: ExpandableSliderConstants.thumbOpacityDuration,
        opacity: isDragging ? 1.0 : 0.0,
        child: DecoratedBox(
          key: ExpandableSliderConstants.thumbKey,
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
          child: Padding(
            padding: ExpandableSliderConstants.thumbPadding,
            child: Text(
              '$progressValue%',
              style: TextStyle(color: textColor),
              semanticsLabel: 'Progress: $progressValue%',
            ),
          ),
        ),
      ),
    );
  }
}
