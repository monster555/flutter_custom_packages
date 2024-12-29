import 'package:custom_expandable_slider/custom_expandable_slider.dart';
import 'package:custom_expandable_slider/src/constants.dart';
import 'package:custom_expandable_slider/src/widgets/slider_thumb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpandableSlider', () {
    group('Rendering Tests', () {
      testWidgets('renders correctly with initial values', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomExpandableSlider(
                  width: 200,
                  height: 40,
                  onProgressChanged: (value) {},
                  initialValue: 0.5,
                  showThumb: true,
                ),
              ),
            ),
          ),
        );

        expect(find.byType(CustomExpandableSlider), findsOneWidget);
        expect(find.byType(SliderThumb), findsOneWidget);
      });

      testWidgets('shows/hides thumb based on showThumb property',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomExpandableSlider(
                  width: 200,
                  height: 40,
                  onProgressChanged: (_) {},
                  showThumb: false,
                ),
              ),
            ),
          ),
        );

        expect(find.byType(SliderThumb), findsNothing);
      });

      testWidgets('applies correct visual properties', (tester) async {
        const testColor = Colors.red;
        const testBorderRadius = BorderRadius.all(Radius.circular(16.0));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomExpandableSlider(
                  width: 200,
                  height: 40,
                  onProgressChanged: (_) {},
                  color: testColor,
                  borderRadius: testBorderRadius,
                ),
              ),
            ),
          ),
        );

        final decoration = tester
            .widget<DecoratedBox>(
              find.byKey(ExpandableSliderConstants.backgroundKey),
            )
            .decoration as BoxDecoration;

        expect(decoration.borderRadius, equals(testBorderRadius));
      });

      testWidgets('progress indicator shows correct color', (tester) async {
        const testColor = Colors.blue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomExpandableSlider(
                  width: 200,
                  height: 40,
                  onProgressChanged: (_) {},
                  color: testColor,
                ),
              ),
            ),
          ),
        );

        final decoration = tester
            .widget<DecoratedBox>(
              find.byKey(ExpandableSliderConstants.progressKey),
            )
            .decoration as BoxDecoration;

        expect(decoration.color, equals(Colors.white));
      });
    });

    group('Interactions Tests', () {
      testWidgets('updates progress on drag', (tester) async {
        double progress = 0.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomExpandableSlider(
                  width: 200,
                  height: 40,
                  onProgressChanged: (value) => progress = value,
                  showThumb: true,
                ),
              ),
            ),
          ),
        );

        await tester.drag(
            find.byType(CustomExpandableSlider), const Offset(100, 0));
        await tester.pumpAndSettle();

        expect(progress, greaterThan(0));
      });

      testWidgets('expands on tap down and contracts on tap up',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomExpandableSlider(
                  width: 200,
                  height: 40,
                  onProgressChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        final gesture = await tester.createGesture();
        await gesture
            .down(tester.getCenter(find.byType(CustomExpandableSlider)));
        await tester.pumpAndSettle();

        // Check expanded state
        final expandedTransform = tester.widget<Transform>(
          find.descendant(
            of: find.byType(CustomExpandableSlider),
            matching: find.byType(Transform),
          ),
        );
        expect(
            expandedTransform.transform.getMaxScaleOnAxis(), greaterThan(1.0));

        await gesture.up();
        await tester.pumpAndSettle();

        // Check contracted state
        final contractedTransform = tester.widget<Transform>(
          find.descendant(
            of: find.byType(CustomExpandableSlider),
            matching: find.byType(Transform),
          ),
        );
        expect(contractedTransform.transform.getMaxScaleOnAxis(), equals(1.0));
      });

      testWidgets('calls onProgressChanged with correct values',
          (tester) async {
        final values = <double>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomExpandableSlider(
                  width: 200,
                  height: 40,
                  onProgressChanged: values.add,
                ),
              ),
            ),
          ),
        );

        await tester.drag(
            find.byType(CustomExpandableSlider), const Offset(50, 0));
        await tester.pumpAndSettle();

        expect(values, isNotEmpty);
        expect(values.every((v) => v >= 0 && v <= 1), true);
      });
    });

    group('HapticFeedback Tests', () {
      testWidgets('triggers haptic feedback at boundaries', (tester) async {
        bool hapticTriggered = false;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (message) async {
            if (message.method == 'HapticFeedback.vibrate') {
              hapticTriggered = true;
            }
            return null;
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomExpandableSlider(
                  width: 200,
                  height: 40,
                  onProgressChanged: (_) {},
                  enableHaptics: true,
                ),
              ),
            ),
          ),
        );

        await tester.drag(
            find.byType(CustomExpandableSlider), const Offset(250, 0));
        await tester.pumpAndSettle();

        expect(hapticTriggered, isTrue);
      });

      testWidgets('triggers haptic feedback when start and end dragging',
          (tester) async {
        int vibrateCount = 0;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (message) async {
            if (message.method == 'HapticFeedback.vibrate') {
              vibrateCount++;
            }
            return null;
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomExpandableSlider(
                  width: 200,
                  height: 40,
                  onProgressChanged: (_) {},
                  enableHaptics: true,
                ),
              ),
            ),
          ),
        );

        final gesture = await tester.startGesture(
            tester.getCenter(find.byType(CustomExpandableSlider)));
        await gesture.moveBy(const Offset(10, 0));
        await gesture.up();
        await tester.pumpAndSettle();

        expect(vibrateCount, equals(2),
            reason: 'Should trigger on drag start and end');
      });

      testWidgets('does not trigger haptic feedback when disabled',
          (tester) async {
        int hapticFeedbackCount = 0;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (message) async {
            if (message.method == 'HapticFeedback.vibrate') {
              hapticFeedbackCount++;
            }
            return null;
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomExpandableSlider(
                  width: 200,
                  height: 40,
                  onProgressChanged: (_) {},
                  enableHaptics: false,
                ),
              ),
            ),
          ),
        );

        final gesture = await tester.startGesture(
            tester.getCenter(find.byType(CustomExpandableSlider)));
        await gesture.moveBy(const Offset(10, 0));
        await gesture.up();
        await tester.pumpAndSettle();

        expect(hapticFeedbackCount, equals(0));
      });
    });

    group('Constructors Tests', () {
      testWidgets('withThumb constructor creates slider with visible thumb',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomExpandableSlider.withThumb(
                  width: 200,
                  height: 40,
                  onProgressChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.byType(SliderThumb), findsOneWidget);
      });
    });

    group('Widget Updates Tests', () {
      testWidgets('updates progress when initialValue changes', (tester) async {
        final widget = MaterialApp(
          home: Scaffold(
            body: Center(
              child: CustomExpandableSlider(
                width: 200,
                height: 40,
                onProgressChanged: (_) {},
                initialValue: 0.3,
              ),
            ),
          ),
        );

        await tester.pumpWidget(widget);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomExpandableSlider(
                  width: 200,
                  height: 40,
                  onProgressChanged: (_) {},
                  initialValue: 0.7,
                ),
              ),
            ),
          ),
        );

        await tester.pump();

        // Verify progress through thumb text if thumb is visible
        expect(find.text('70%'), findsOneWidget);
      });

      testWidgets('updates colors when color property changes', (tester) async {
        const initialColor = Colors.blue;
        const updatedColor = Colors.red;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomExpandableSlider(
                  width: 200,
                  height: 40,
                  onProgressChanged: (_) {},
                  color: initialColor,
                  showThumb: true,
                ),
              ),
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomExpandableSlider(
                  width: 200,
                  height: 40,
                  onProgressChanged: (_) {},
                  color: updatedColor,
                  showThumb: true,
                ),
              ),
            ),
          ),
        );

        await tester.pump();

        final progressIndicator = tester.widget<DecoratedBox>(
          find.byKey(ExpandableSliderConstants.progressKey),
        );
        final thumb = tester.widget<SliderThumb>(find.byType(SliderThumb));

        // Verify color updates in both components
        expect((progressIndicator.decoration as BoxDecoration).color,
            Colors.white);
        expect(thumb.color, equals(updatedColor));
      });
    });
  });
}
