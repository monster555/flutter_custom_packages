import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum HapticFeedbackStrength {
  light,
  medium,
  heavy,
}

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
