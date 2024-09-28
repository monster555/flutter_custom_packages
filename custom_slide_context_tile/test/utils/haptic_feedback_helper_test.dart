import 'package:custom_slide_context_tile/src/utils/haptic_feedback_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockHapticFeedbackWrapper extends Mock implements HapticFeedbackWrapper {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('HapticFeedbackWrapper', () {
    late HapticFeedbackWrapper wrapper;

    setUp(() {
      wrapper = const HapticFeedbackWrapper();
    });

    test('lightImpact sends correct platform message', () async {
      bool methodCalled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform,
              (MethodCall methodCall) async {
        if (methodCall.method == 'HapticFeedback.vibrate' &&
            methodCall.arguments == 'HapticFeedbackType.lightImpact') {
          methodCalled = true;
        }
        return null;
      });

      wrapper.lightImpact();
      expect(methodCalled, isTrue);
    });

    test('mediumImpact sends correct platform message', () async {
      bool methodCalled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform,
              (MethodCall methodCall) async {
        if (methodCall.method == 'HapticFeedback.vibrate' &&
            methodCall.arguments == 'HapticFeedbackType.mediumImpact') {
          methodCalled = true;
        }
        return null;
      });

      wrapper.mediumImpact();
      expect(methodCalled, isTrue);
    });

    test('heavyImpact sends correct platform message', () async {
      bool methodCalled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform,
              (MethodCall methodCall) async {
        if (methodCall.method == 'HapticFeedback.vibrate' &&
            methodCall.arguments == 'HapticFeedbackType.heavyImpact') {
          methodCalled = true;
        }
        return null;
      });

      wrapper.heavyImpact();
      expect(methodCalled, isTrue);
    });
  });
  group('triggerHapticFeedback', () {
    final mockHapticFeedbackWrapper = MockHapticFeedbackWrapper();

    setUp(() {
      // Reset the mock before each test
      reset(mockHapticFeedbackWrapper);
    });

    test('triggers light impact on iOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      triggerHapticFeedback(
          HapticFeedbackStrength.light, mockHapticFeedbackWrapper);

      verify(mockHapticFeedbackWrapper.lightImpact()).called(1);
    });
    test('triggers medium impact on iOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      triggerHapticFeedback(
          HapticFeedbackStrength.medium, mockHapticFeedbackWrapper);

      verify(mockHapticFeedbackWrapper.mediumImpact()).called(1);
    });

    test('triggers heavy impact on iOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      triggerHapticFeedback(
          HapticFeedbackStrength.heavy, mockHapticFeedbackWrapper);

      verify(mockHapticFeedbackWrapper.heavyImpact()).called(1);
    });

    test('does not trigger haptic feedback on non-iOS platforms', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      triggerHapticFeedback(
          HapticFeedbackStrength.light, mockHapticFeedbackWrapper);
      triggerHapticFeedback(
          HapticFeedbackStrength.medium, mockHapticFeedbackWrapper);
      triggerHapticFeedback(
          HapticFeedbackStrength.heavy, mockHapticFeedbackWrapper);

      verifyNever(mockHapticFeedbackWrapper.lightImpact());
      verifyNever(mockHapticFeedbackWrapper.mediumImpact());
      verifyNever(mockHapticFeedbackWrapper.heavyImpact());
    });

    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
