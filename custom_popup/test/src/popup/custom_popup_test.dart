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
  });
}
