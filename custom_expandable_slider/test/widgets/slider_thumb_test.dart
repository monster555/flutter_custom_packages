import 'package:custom_expandable_slider/src/constants.dart';
import 'package:custom_expandable_slider/src/widgets/slider_thumb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SliderThumb', () {
    group('Rendering Tests', () {
      testWidgets('renders correctly with given properties', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SliderThumb(
                  isDragging: true,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                  textColor: Colors.white,
                  progress: 0.5,
                ),
              ),
            ),
          ),
        );

        expect(find.byType(SliderThumb), findsOneWidget);
        expect(find.text('50%'), findsOneWidget);
      });

      testWidgets('applies correct border radius', (tester) async {
        const testRadius = BorderRadius.all(Radius.circular(16.0));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SliderThumb(
                isDragging: true,
                color: Colors.blue,
                borderRadius: testRadius,
                textColor: Colors.white,
                progress: 0.5,
              ),
            ),
          ),
        );

        final decoratedBox = tester.widget<DecoratedBox>(
            find.byKey(ExpandableSliderConstants.thumbKey));
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.borderRadius, equals(testRadius));
      });
    });

    group('AnimationTests', () {
      testWidgets('updates opacity based on isDragging', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SliderThumb(
                  isDragging: false,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                  textColor: Colors.white,
                  progress: 0.5,
                ),
              ),
            ),
          ),
        );

        final AnimatedOpacity opacity =
            tester.widget(find.byType(AnimatedOpacity));
        expect(opacity.opacity, 0.0);
      });

      testWidgets('uses correct animation duration', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SliderThumb(
                isDragging: true,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
                textColor: Colors.white,
                progress: 0.5,
              ),
            ),
          ),
        );

        final opacity =
            tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
        expect(opacity.duration,
            equals(ExpandableSliderConstants.thumbOpacityDuration));
      });
    });

    group('Text Display Tests', () {
      testWidgets('formats progress text correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SliderThumb(
                isDragging: true,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
                textColor: Colors.white,
                progress: 0.567,
              ),
            ),
          ),
        );

        expect(find.text('57%'), findsOneWidget);
      });

      testWidgets('shows correct text at boundaries', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  SliderThumb(
                    isDragging: true,
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                    textColor: Colors.white,
                    progress: 0.0,
                  ),
                  SliderThumb(
                    isDragging: true,
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                    textColor: Colors.white,
                    progress: 1.0,
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.text('0%'), findsOneWidget);
        expect(find.text('100%'), findsOneWidget);
      });
    });

    group('Colors and Styling Tests', () {
      testWidgets('applies correct padding', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SliderThumb(
                isDragging: true,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
                textColor: Colors.white,
                progress: 0.5,
              ),
            ),
          ),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, equals(ExpandableSliderConstants.thumbPadding));
      });
    });

    group('Semantics Tests', () {
      testWidgets('provides correct semantic label', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SliderThumb(
                isDragging: true,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
                textColor: Colors.white,
                progress: 0.42,
              ),
            ),
          ),
        );

        expect(
          tester.getSemantics(find.byType(Text)),
          matchesSemantics(label: 'Progress: 42%'),
        );
      });
    });
  });
}
