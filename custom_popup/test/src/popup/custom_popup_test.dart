import 'package:custom_popup/src/menu/menu_content.dart';
import 'package:custom_popup/src/menu/menu_item.dart';
import 'package:custom_popup/src/popup/custom_popup.dart';
import 'package:custom_popup/src/popup/custom_popup_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('CustomPopup', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      final anchorKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CustomPopup(
                key: anchorKey,
                content: const Text('Popup Content'),
                contentPadding: const EdgeInsets.all(20.0),
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      // Simulate a tap on the CustomPopup widget (not the child)
      await tester.tap(find.byKey(anchorKey));
      await tester.pumpAndSettle();

      // Verify popup content
      expect(find.text('Popup Content'), findsOneWidget);

      // Verify that the CustomPopupContent widget is present
      expect(find.byType(CustomPopupContent), findsOneWidget);
    });

    group('CustomPopup.menu', () {
      testWidgets('creates CustomPopup with correct properties',
          (WidgetTester tester) async {
        final anchorKey = GlobalKey();
        final child =
            ElevatedButton(onPressed: () {}, child: const Text('Button'));
        final actions = [
          MenuItem(
            label: 'Action 1',
            icon: Icons.star,
            onPressed: () {},
          ),
          MenuItem(
            label: 'Action 2',
            icon: Icons.settings,
            onPressed: () {},
          ),
        ];

        final customPopup = CustomPopup.menu(
          anchorKey: anchorKey,
          showArrow: false,
          contentRadius: 8.0,
          actions: actions,
          child: child,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: customPopup,
            ),
          ),
        );

        expect(customPopup.anchorKey, anchorKey);
        expect(customPopup.child, child);
        expect(customPopup.showArrow, isFalse);
        expect(customPopup.contentRadius, 8.0);

        final menuContent = customPopup.content as MenuContent;
        expect(menuContent.actions, actions);
      });

      testWidgets('renders MenuContent with actions',
          (WidgetTester tester) async {
        final customPopup = CustomPopup.menu(
          actions: [
            MenuItem(
              label: 'Action 1',
              icon: Icons.star,
              onPressed: () {},
            ),
            MenuItem(
              label: 'Action 2',
              icon: Icons.settings,
              onPressed: () {},
            ),
          ],
          child: const Icon(Icons.add),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: customPopup,
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        final menuContent =
            tester.widget<MenuContent>(find.byType(MenuContent));
        expect(menuContent.actions, hasLength(2));
        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });
    });

    testWidgets('closes when window is resised', (WidgetTester tester) async {
      // Initial MediaQuery size
      MediaQueryData mediaQueryData =
          const MediaQueryData(size: Size(300, 300));

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(builder: (context, setState) {
            return MediaQuery(
              data: mediaQueryData,
              child: Column(
                children: [
                  CustomPopup(
                    content: const Text('Popup Content'),
                    contentPadding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.blue,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Change Size'),
                  ),
                ],
              ),
            );
          }),
        ),
      );
      // Verify popup is not present
      expect(find.text('Popup Content'), findsNothing);

      // Simulate a tap on the CustomPopup widget (not the child)
      await tester.tap(find.byType(Container));
      await tester.pumpAndSettle();

      // Verify popup content is open by finding it's content
      expect(find.text('Popup Content'), findsOneWidget);

      final buttonFinder = find.byType(ElevatedButton);

      mediaQueryData = const MediaQueryData(size: Size(200, 200));

      // Simulate a size change by pressing the button
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      // Verify that the CustomPopupContent widget is present
      expect(find.text('Popup Content'), findsNothing);
    });
  });
}
