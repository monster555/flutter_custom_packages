import 'package:custom_popup/src/menu/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  Widget buildMenuItem({
    IconData iconData = Icons.home,
    String label = 'Home',
    bool isDestructive = false,
  }) {
    return MaterialApp(
      home: Material(
        child: MenuItem(
          icon: iconData,
          label: label,
          onPressed: () {},
          isDestructive: isDestructive,
        ),
      ),
    );
  }

  BuildContext getTestContext(WidgetTester tester) {
    final state = tester.state(find.byType(MaterialApp)) as State<MaterialApp>;
    return state.context;
  }

  group('MenuItem', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      const iconData = Icons.home;
      const label = 'Home';

      // Test not hovered, not destructive
      await tester.pumpWidget(buildMenuItem());

      expect(find.byType(MenuItem), findsOneWidget);

      expect(find.byIcon(iconData), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(find.text(label), findsOneWidget);
    });

    testWidgets('destructive item renders correctly',
        (WidgetTester tester) async {
      const iconData = Icons.home;
      const label = 'Home';

      // Test not hovered, destructive
      await tester.pumpWidget(buildMenuItem(isDestructive: true));

      expect(find.byType(MenuItem), findsOneWidget);

      expect(find.byIcon(iconData), findsOneWidget);

      final context = getTestContext(tester);

      final iconFinder = tester.widget<Icon>(find.byType(Icon));
      expect(iconFinder.icon, iconData);
      expect(iconFinder.color, Theme.of(context).colorScheme.error);

      final textFinder = tester.widget<Text>(find.byType(Text));
      expect(textFinder.data, label);
      expect(textFinder.style!.color, Theme.of(context).colorScheme.error);
    });
  });
}
