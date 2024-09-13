import 'package:flutter/material.dart';

abstract class AnimationStrategy {
  Widget buildLeadingActions(
    List<Widget> actions,
    List<GlobalKey> keys,
    double offset,
    double maxOffset,
    bool showLabels,
    bool shouldExpand,
  );

  Widget buildTrailingActions(
    List<Widget> actions,
    List<GlobalKey> keys,
    double offset,
    double maxOffset,
    bool showLabels,
    bool shouldExpand,
  );
}
