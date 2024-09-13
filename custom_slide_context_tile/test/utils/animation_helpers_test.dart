import 'package:custom_slide_context_tile/src/utils/animation_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('determineTargetOffset', () {
    const maxLeadingOffset = 100.0;
    const maxTrailingOffset = 80.0;
    const actionExecutionThreshold = 20.0;

    test('returns 0 when offset is 0', () {
      expect(
        determineTargetOffset(0, 0, maxLeadingOffset, maxTrailingOffset,
            actionExecutionThreshold, null, null, false),
        0,
      );
    });

    group('leading direction (positive offset)', () {
      test(
          'returns maxLeadingOffset when offset is greater than half maxLeadingOffset',
          () {
        expect(
          determineTargetOffset(60, 0, maxLeadingOffset, maxTrailingOffset,
              actionExecutionThreshold, null, null, false),
          maxLeadingOffset,
        );
      });

      test('returns maxLeadingOffset when velocity is greater than 100', () {
        expect(
          determineTargetOffset(40, 101, maxLeadingOffset, maxTrailingOffset,
              actionExecutionThreshold, null, null, false),
          maxLeadingOffset,
        );
      });

      test(
          'returns 0 when offset is less than half maxLeadingOffset and velocity is less than 100',
          () {
        expect(
          determineTargetOffset(40, 99, maxLeadingOffset, maxTrailingOffset,
              actionExecutionThreshold, null, null, false),
          0,
        );
      });

      test('calls onLeadingAction and returns 0 when offset exceeds threshold',
          () {
        bool actionCalled = false;
        final result = determineTargetOffset(
          maxLeadingOffset + actionExecutionThreshold + 1,
          0,
          maxLeadingOffset,
          maxTrailingOffset,
          actionExecutionThreshold,
          () => actionCalled = true,
          null,
          false,
        );
        expect(result, 0);
        expect(actionCalled, true);
      });
    });

    group('trailing direction (negative offset)', () {
      test(
          'returns -maxTrailingOffset when offset is less than negative half maxTrailingOffset',
          () {
        expect(
          determineTargetOffset(-50, 0, maxLeadingOffset, maxTrailingOffset,
              actionExecutionThreshold, null, null, false),
          -maxTrailingOffset,
        );
      });

      test('returns -maxTrailingOffset when velocity is less than -100', () {
        expect(
          determineTargetOffset(-30, -101, maxLeadingOffset, maxTrailingOffset,
              actionExecutionThreshold, null, null, false),
          -maxTrailingOffset,
        );
      });

      test(
          'returns 0 when offset is greater than negative half maxTrailingOffset and velocity is greater than -100',
          () {
        expect(
          determineTargetOffset(-30, -99, maxLeadingOffset, maxTrailingOffset,
              actionExecutionThreshold, null, null, false),
          0,
        );
      });

      test(
          'calls onTrailingAction and returns 0 when offset exceeds negative threshold',
          () {
        bool actionCalled = false;
        final result = determineTargetOffset(
          -(maxTrailingOffset + actionExecutionThreshold + 1),
          0,
          maxLeadingOffset,
          maxTrailingOffset,
          actionExecutionThreshold,
          null,
          () => actionCalled = true,
          false,
        );
        expect(result, 0);
        expect(actionCalled, true);
      });
    });

    test('does not call action when already executed', () {
      bool actionCalled = false;
      determineTargetOffset(
        maxLeadingOffset + actionExecutionThreshold + 1,
        0,
        maxLeadingOffset,
        maxTrailingOffset,
        actionExecutionThreshold,
        () => actionCalled = true,
        null,
        true,
      );
      expect(actionCalled, false);
    });
  });
}
