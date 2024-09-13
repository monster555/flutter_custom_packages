import 'dart:math';

import 'package:flutter/material.dart';

class ActionSizes {
  final double leadingWidth;
  final double trailingWidth;

  ActionSizes(this.leadingWidth, this.trailingWidth);

  @override
  String toString() =>
      'leadingWidth: $leadingWidth, trailingWidth: $trailingWidth';
}

ActionSizes calculateActionSizes(
    List<GlobalKey> leadingKeys, List<GlobalKey> trailingKeys) {
  final totalLeadingWidth = calculateTotalWidth(leadingKeys);
  final totalTrailingWidth = calculateTotalWidth(trailingKeys);

  return ActionSizes(totalLeadingWidth, totalTrailingWidth);
}

double calculateTotalWidth(List<GlobalKey> keys) {
  double maxActionWidth = 0.0;

  for (final key in keys) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;

    maxActionWidth = max(maxActionWidth, renderBox?.size.width ?? 0.0);
  }
  return maxActionWidth * keys.length;
}
