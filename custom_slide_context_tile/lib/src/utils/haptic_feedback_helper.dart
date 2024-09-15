import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Defines the strength levels for haptic feedback.
///
/// This enum represents different intensities of haptic feedback that can be
/// triggered on supported devices. The levels correspond to the impact feedback
/// generators available on iOS devices.
enum HapticFeedbackStrength {
  /// Light haptic feedback, suitable for subtle interactions.
  light,

  /// Medium haptic feedback, suitable for standard interactions.
  medium,

  /// Heavy haptic feedback, suitable for more significant interactions.
  heavy,
}

/// Triggers haptic feedback with the specified strength on iOS devices.
///
/// This function provides a way to generate tactile feedback for user interactions.
/// The haptic feedback is only triggered on iOS devices, as the implementation
/// uses iOS-specific impact feedback generators.
///
/// - [strength] is the desired strength of the haptic feedback. Defaults to
///   [HapticFeedbackStrength.medium] if not specified.
///
/// Usage:
/// ```dart
/// // Trigger default (medium) haptic feedback
/// triggerHapticFeedback();
///
/// // Trigger light haptic feedback
/// triggerHapticFeedback(HapticFeedbackStrength.light);
/// ```
///
/// Note: This function has no effect on non-iOS platforms. If you need to
/// support haptic feedback on other platforms, you should extend this function
/// or use a more platform-agnostic approach.
void triggerHapticFeedback(
    [HapticFeedbackStrength strength = HapticFeedbackStrength.medium]) {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    switch (strength) {
      case HapticFeedbackStrength.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackStrength.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackStrength.heavy:
        HapticFeedback.heavyImpact();
        break;
    }
  }
}
