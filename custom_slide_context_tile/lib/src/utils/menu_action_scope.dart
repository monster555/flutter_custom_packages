import 'package:flutter/widgets.dart';

class MenuActionScope extends InheritedWidget {
  final bool showLabels;

  const MenuActionScope({
    super.key,
    required this.showLabels,
    required super.child,
  });

  static MenuActionScope of(BuildContext context) {
    final MenuActionScope? result =
        context.dependOnInheritedWidgetOfExactType<MenuActionScope>();
    assert(result != null, 'No MenuActionScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(MenuActionScope oldWidget) =>
      showLabels != oldWidget.showLabels;
}
