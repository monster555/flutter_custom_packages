import 'package:custom_slide_context_tile/src/utils/haptic_feedback_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
      if (!actionExecuted) {
        triggerHapticFeedback();
        onLeadingAction?.call();
      }

      targetOffset = 0.0;
    } else {
      targetOffset = (offset > maxLeadingOffset / 2 || velocity > 100)
          ? maxLeadingOffset
          : 0.0;
    }
  } else {
    if (offset < -(maxTrailingOffset + actionExecutionThreshold)) {
      if (!actionExecuted) {
        triggerHapticFeedback();
        onTrailingAction?.call();
      }

      targetOffset = 0.0;
    } else {
      targetOffset = (offset < -maxTrailingOffset / 2 || velocity < -100)
          ? -maxTrailingOffset
          : 0.0;
    }
  }
  return targetOffset;
}
