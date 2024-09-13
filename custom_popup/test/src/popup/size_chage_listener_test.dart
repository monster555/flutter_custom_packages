import 'package:custom_popup/src/popup/size_change_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late Size? changedSize;
  late int callCount;

  setUp(() {
    changedSize = null;
    callCount = 0;
  });

  group('SizeChangeListener', () {
    testWidgets('SizeChangeListener is created', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SizeChangeListener(
            onSizeChanged: (_) {},
            child: Container(),
          ),
        ),
      );

      expect(find.byType(SizeChangeListener), findsOneWidget);
    });

    testWidgets('Child widget is rendered correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SizeChangeListener(
            onSizeChanged: (_) {},
            child: const Text('Hello, World!'),
          ),
        ),
      );

      expect(find.text('Hello, World!'), findsOneWidget);
    });

    testWidgets('onSizeChanged is called when size changes',
        (WidgetTester tester) async {
      // Initial MediaQuery size
      MediaQueryData mediaQueryData =
          const MediaQueryData(size: Size(100, 100));

      // Create a StatefulWidget to manage MediaQuery size
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return MediaQuery(
                data: mediaQueryData,
                child: SizeChangeListener(
                  onSizeChanged: (size) {
                    callCount++;
                    changedSize = size;
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      // Update MediaQuery size when button is pressed
                      setState(() {
                        // Change the size to trigger onSizeChanged
                        mediaQueryData =
                            const MediaQueryData(size: Size(200, 200));
                      });
                    },
                    child: const Text('Change Size'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(callCount, 0);

      // Simulate a size change by pressing the button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(changedSize, equals(const Size(200, 200)));
      expect(callCount, 1);
    });

    testWidgets('onSizeChanged is called multiple times with different sizes',
        (WidgetTester tester) async {
      // Initial MediaQuery size
      MediaQueryData mediaQueryData =
          const MediaQueryData(size: Size(100, 100));

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return MediaQuery(
                data: mediaQueryData,
                child: SizeChangeListener(
                  onSizeChanged: (size) {
                    callCount++;
                    changedSize = size;
                  },
                  child: ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Change Size'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(callCount, 0);
      final buttonFinder = find.byType(ElevatedButton);

      mediaQueryData = const MediaQueryData(size: Size(200, 200));

      // Simulate a size change by pressing the button
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(changedSize, equals(const Size(200, 200)));
      expect(callCount, 1);

      mediaQueryData = const MediaQueryData(size: Size(300, 300));

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(changedSize, equals(const Size(300, 300)));
      expect(callCount, 2);

      mediaQueryData = const MediaQueryData(size: Size(400, 400));

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(changedSize, equals(const Size(400, 400)));
      expect(callCount, 3);
    });

    testWidgets('onSizeChanged is called with extreme sizes',
        (WidgetTester tester) async {
      // Initial MediaQuery size
      MediaQueryData mediaQueryData =
          const MediaQueryData(size: Size(100, 100));

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return MediaQuery(
                data: mediaQueryData,
                child: SizeChangeListener(
                  onSizeChanged: (size) {
                    callCount++;
                    changedSize = size;
                  },
                  child: ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Change Size'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(callCount, 0);
      final buttonFinder = find.byType(ElevatedButton);

      mediaQueryData = const MediaQueryData(size: Size.zero);

      // Simulate a size change by pressing the button
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(changedSize, equals(Size.zero));
      expect(callCount, 1);

      mediaQueryData = const MediaQueryData(size: Size(10000, 10000));

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(changedSize, equals(const Size(10000, 10000)));
      expect(callCount, 2);
    });

    testWidgets('onSizeChanged is not called when size does not change',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SizeChangeListener(
            onSizeChanged: (_) {
              callCount++;
            },
            child: Container(),
          ),
        ),
      );

      expect(callCount, equals(0));
    });
  });
}
