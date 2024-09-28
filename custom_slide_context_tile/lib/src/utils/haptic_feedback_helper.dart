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

/// A wrapper class for the HapticFeedback methods.
///
/// This class provides methods to trigger different strengths of haptic feedback.
/// It is used to facilitate testing by allowing the haptic feedback methods to be
/// mocked.
class HapticFeedbackWrapper {
  const HapticFeedbackWrapper();

  /// Triggers a light haptic feedback.
  ///
  /// This method calls [HapticFeedback.lightImpact] to generate a light impact
  /// feedback. It is typically used for subtle feedback on user interactions.
  void lightImpact() => HapticFeedback.lightImpact();

  /// Triggers a medium haptic feedback.
  ///
  /// This method calls [HapticFeedback.mediumImpact] to generate a medium impact
  /// feedback. It is typically used for standard feedback on user interactions.
  void mediumImpact() => HapticFeedback.mediumImpact();

  /// Triggers a heavy haptic feedback.
  ///
  /// This method calls [HapticFeedback.heavyImpact] to generate a heavy impact
  /// feedback. It is typically used for strong feedback on user interactions.
  void heavyImpact() => HapticFeedback.heavyImpact();
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
/// // Trigger heavy haptic feedback
/// triggerHapticFeedback(HapticFeedbackStrength.heavy);
/// ```
///
/// Note: This function has no effect on non-iOS platforms. If you need to
/// support haptic feedback on other platforms, you should extend this function
/// or use a more platform-agnostic approach.
void triggerHapticFeedback(
    [HapticFeedbackStrength strength = HapticFeedbackStrength.medium,
    HapticFeedbackWrapper hapticFeedback = const HapticFeedbackWrapper()]) {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    switch (strength) {
      case HapticFeedbackStrength.light:
        hapticFeedback.lightImpact();
        break;
      case HapticFeedbackStrength.medium:
        hapticFeedback.mediumImpact();
        break;
      case HapticFeedbackStrength.heavy:
        hapticFeedback.heavyImpact();
        break;
    }
  }
}
