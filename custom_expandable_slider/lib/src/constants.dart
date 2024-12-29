import 'package:flutter/material.dart';

class ExpandableSliderConstants {
  static const thumbWidth = 24.0;
  static const thumbHeight = 36.0;
  static const thumbPadding = EdgeInsets.symmetric(
    horizontal: 8.0,
    vertical: 4.0,
  );
  static const thumbOpacityDuration = Duration(milliseconds: 150);

  static const backgroundKey = Key('expandable_slider_background');
  static const progressKey = Key('expandable_slider_progress');
  static const thumbKey = Key('expandable_slider_thumb');
}
