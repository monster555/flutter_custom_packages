import 'package:custom_slide_context_tile/src/widgets/adaptive_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdaptiveListTile Tests', () {
    group('Platform-soecific rendering', () {
      for (final platform in TargetPlatform.values) {
        testWidgets(
          'uses CupertinoListTile when not adaptive on $platform',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              MaterialApp(
                theme: ThemeData(platform: platform),
                home: const AdaptiveListTile(
                  title: Text('Test'),
                  useAdaptiveListTile: false,
                ),
              ),
            );
            expect(find.byType(CupertinoListTile), findsOneWidget);
            expect(find.byType(ListTile), findsNothing);
          },
        );
      }

      for (final platform in TargetPlatform.values) {
        testWidgets(
            'uses the proper list tile widget when useAdaptiveListTile is true on $platform',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(platform: platform),
              home: const AdaptiveListTile(
                title: Text('Test'),
                useAdaptiveListTile: true,
              ),
            ),
          );
          if (platform == TargetPlatform.iOS ||
              platform == TargetPlatform.macOS) {
            expect(find.byType(CupertinoListTile), findsOneWidget);
            expect(find.byType(ListTile), findsNothing);
          } else {
            expect(find.byType(ListTile), findsOneWidget);
            expect(find.byType(CupertinoListTile), findsNothing);
          }
        });
      }

      for (final platform in TargetPlatform.values) {
        testWidgets('uses correct background color on $platform',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(
                platform: platform,
                scaffoldBackgroundColor: Colors.grey[200],
              ),
              home: const AdaptiveListTile(
                title: Text('Test'),
                useAdaptiveListTile: true,
              ),
            ),
          );

          if (platform == TargetPlatform.iOS ||
              platform == TargetPlatform.macOS) {
            final CupertinoListTile listTile =
                tester.widget(find.byType(CupertinoListTile));
            expect(listTile.backgroundColor, CupertinoColors.systemBackground);
          } else {
            final ColoredBox coloredBox =
                tester.widget(find.byType(ColoredBox));
            expect(coloredBox.color, Colors.grey[200]);
          }
        });
      }

      for (final platform in TargetPlatform.values
          .where((p) => p != TargetPlatform.iOS && p != TargetPlatform.macOS)) {
        testWidgets('uses CupertinoListTile when not adaptive on $platform',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(platform: platform),
              home: const AdaptiveListTile(
                title: Text('Test'),
                useAdaptiveListTile: false,
              ),
            ),
          );
          expect(find.byType(CupertinoListTile), findsOneWidget);
          expect(find.byType(ListTile), findsNothing);
        });
      }
    });

    group('Content rendering', () {
      testWidgets('renders title and subtitle correctly',
          (WidgetTester tester) async {
        const titleText = 'Test Title';
        const subtitleText = 'Test Subtitle';
        await tester.pumpWidget(
          const MaterialApp(
            home: AdaptiveListTile(
              title: Text(titleText),
              subtitle: Text(subtitleText),
            ),
          ),
        );
        expect(find.text(titleText), findsOneWidget);
        expect(find.text(subtitleText), findsOneWidget);
      });

      testWidgets('does not render subtitle when not provided',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: AdaptiveListTile(
              title: Text('Test Title'),
            ),
          ),
        );
        expect(find.text('Test Title'), findsOneWidget);
        // Only title should be present
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('renders leading and trailing widgets',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: AdaptiveListTile(
              title: Text('Test'),
              leading: Icon(Icons.star),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
        );
        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      });

      testWidgets('wraps to multiple lines for long text',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: SizedBox(
              width: 200,
              child: AdaptiveListTile(
                title: Text(
                    'This is a very long title that should wrap to multiple lines',
                    maxLines: 2),
              ),
            ),
          ),
        );

        final RenderBox box = tester.renderObject(find.byType(Text));
        expect(box.size.height, greaterThan(24));
      });
    });

    group('Interaction', () {
      testWidgets('calls onTap when tapped', (WidgetTester tester) async {
        bool wasTapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: AdaptiveListTile(
              title: const Text('Test'),
              onTap: () => wasTapped = true,
            ),
          ),
        );
        await tester.tap(find.byType(AdaptiveListTile));
        expect(wasTapped, isTrue);
      });

      testWidgets('does not call onTap when not provided',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: AdaptiveListTile(
              title: Text('Test'),
            ),
          ),
        );
        await tester.tap(find.byType(AdaptiveListTile));
        // If no exception is thrown, the test passes
      });
    });

    group('Layout and Styling', () {
      testWidgets('has minimum height constraint', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: AdaptiveListTile(title: Text('Test')),
          ),
        );
        final RenderBox box =
            tester.renderObject(find.byType(AdaptiveListTile));
        expect(box.size.height, greaterThanOrEqualTo(48));
      });

      testWidgets('uses default padding when not specified',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: AdaptiveListTile(
              title: Text('Test'),
            ),
          ),
        );

        final listTile =
            tester.widget<CupertinoListTile>(find.byType(CupertinoListTile));
        expect(listTile.padding, null);
      });

      for (final platform in TargetPlatform.values) {
        testWidgets('respects custom padding in $platform',
            (WidgetTester tester) async {
          final isApplePlatform = platform == TargetPlatform.iOS ||
              platform == TargetPlatform.macOS;

          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(platform: platform),
              home: const AdaptiveListTile(
                title: Text('Test'),
                padding: EdgeInsets.all(10),
                useAdaptiveListTile: true,
              ),
            ),
          );

          if (isApplePlatform) {
            final CupertinoListTile listTile =
                tester.widget(find.byType(CupertinoListTile));
            expect(listTile.padding, const EdgeInsets.all(10));
          } else {
            final ListTile listTile = tester.widget(find.byType(ListTile));
            expect(listTile.contentPadding, const EdgeInsets.all(10));
          }
        });
      }
    });
  });
}
