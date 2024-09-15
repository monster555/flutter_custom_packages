import 'dart:math';

import 'package:flutter/material.dart';

/// Represents the sizes of leading and trailing actions in a slidable widget.
///
/// This class holds the total widths of leading and trailing action sets,
/// providing a convenient way to store and access these dimensions.
class ActionSizes {
  /// The total width of all leading actions.
  final double leadingWidth;

  /// The total width of all trailing actions.
  final double trailingWidth;

  /// Creates an [ActionSizes] instance with the specified widths.
  ///
  /// [leadingWidth] is the total width of all leading actions.
  /// [trailingWidth] is the total width of all trailing actions.
  ActionSizes(this.leadingWidth, this.trailingWidth);

  @override
  String toString() =>
      'leadingWidth: $leadingWidth, trailingWidth: $trailingWidth';
}

/// Calculates the total sizes of leading and trailing actions.
///
/// This function computes the total widths of leading and trailing actions
/// based on the provided `GlobalKeys` of the action widgets.
///
/// [leadingKeys] is a list of `GlobalKeys` for the leading action widgets.
/// [trailingKeys] is a list of `GlobalKeys` for the trailing action widgets.
///
/// Returns an [ActionSizes] instance containing the calculated total widths.
ActionSizes calculateActionSizes(
    List<GlobalKey> leadingKeys, List<GlobalKey> trailingKeys) {
  final totalLeadingWidth = calculateTotalWidth(leadingKeys);
  final totalTrailingWidth = calculateTotalWidth(trailingKeys);

  return ActionSizes(totalLeadingWidth, totalTrailingWidth);
}

/// Calculates the total width of a set of action widgets.
///
/// This function computes the total width by finding the maximum width among
/// the provided widgets and multiplying it by the number of widgets. This
/// approach assumes all actions in a set (leading or trailing) have the same width.
///
/// [keys] is a list of `GlobalKeys` for the action widgets whose total width
/// needs to be calculated.
///
/// Returns the total calculated width as a double.
///
/// Note: This function relies on the widgets being rendered and accessible
/// via their `GlobalKeys`. If a widget is not yet rendered, its width will be
/// considered as 0.0.
double calculateTotalWidth(List<GlobalKey> keys) {
  double maxActionWidth = 0.0;

  for (final key in keys) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;

    maxActionWidth = max(maxActionWidth, renderBox?.size.width ?? 0.0);
  }
  return maxActionWidth * keys.length;
}
