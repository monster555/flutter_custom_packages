import 'package:custom_slide_context_tile/src/utils/haptic_feedback_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Determines the target offset for a slidable widget based on current state and user interaction.
///
/// This function calculates where the slidable should settle after a user interaction,
/// taking into account the current offset, velocity of the gesture, maximum allowed
/// offsets, and whether an action should be triggered.
///
/// - [offset] is the current offset of the slidable. Positive for leading actions,
///   negative for trailing.
/// - [velocity] is the velocity of the user's gesture. Positive for rightward,
///   negative for leftward gestures.
/// - [maxLeadingOffset] is the maximum offset allowed for leading actions.
/// - [maxTrailingOffset] is the maximum offset allowed for trailing actions.
/// - [actionExecutionThreshold] is the additional offset beyond max offset required
///   to trigger an action.
/// - [onLeadingAction] is a callback function to execute when a leading action is
///   triggered.
/// - [onTrailingAction] is a callback function to execute when a trailing action is
///   triggered.
/// - [actionExecuted] is a boolean flag indicating if an action has already been
///   executed.
///
/// Returns:
/// The target offset where the slidable should settle. 0.0 means closed state.
///
/// Behavior:
/// 1. For leading actions (positive offset):
///    - If offset exceeds max + threshold, trigger action and close.
///    - Otherwise, open fully if past halfway or fast swipe, else close.
/// 2. For trailing actions (negative offset):
///    - If offset exceeds max + threshold, trigger action and close.
///    - Otherwise, open fully if past halfway or fast swipe, else close.
/// 3. Haptic feedback is triggered when an action is executed.
///
/// Note: This function assumes that triggering an action should always result
/// in closing the slidable (returning to 0.0 offset).

double determineTargetOffset(
  double offset,
  double velocity,
  double maxLeadingOffset,
  double maxTrailingOffset,
  double actionExecutionThreshold,
  VoidCallback? onLeadingAction,
  VoidCallback? onTrailingAction,
  bool actionExecuted,
) {
  double targetOffset;

  if (offset > 0) {
    if (offset > maxLeadingOffset + actionExecutionThreshold) {
      // Trigger action and close if beyond threshold
      if (!actionExecuted) {
        triggerHapticFeedback();
        onLeadingAction?.call();
      }

      targetOffset = 0.0;
    } else {
      // Determine whether to open fully or close based on position and velocity
      targetOffset = (offset > maxLeadingOffset / 2 || velocity > 100)
          ? maxLeadingOffset
          : 0.0;
    }
  } else {
    if (offset < -(maxTrailingOffset + actionExecutionThreshold)) {
      // Trigger action and close if beyond threshold
      if (!actionExecuted) {
        triggerHapticFeedback();
        onTrailingAction?.call();
      }

      targetOffset = 0.0;
    } else {
      // Determine whether to open fully or close based on position and velocity
      targetOffset = (offset < -maxTrailingOffset / 2 || velocity < -100)
          ? -maxTrailingOffset
          : 0.0;
    }
  }
  return targetOffset;
}
