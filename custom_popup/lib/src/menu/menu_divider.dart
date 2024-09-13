import 'package:custom_popup/src/menu/menu_element.dart';
import 'package:flutter/material.dart';

/// A horizontal line widget used to separate items within a menu.
///
/// [MenuDivider] is a simple, non-interactive widget that visually segments
/// menu items, enhancing the clarity and organization of the menu layout.
/// It extends [MenuElement] and utilizes the [Divider] widget to achieve
/// a consistent and clean separation between sections or groups of items.
class MenuDivider extends MenuElement {
  /// Creates a new [MenuDivider] for use in menu layouts.
  const MenuDivider({super.key});

  @override
  State<MenuDivider> createState() => _MenuDividerState();
}

class _MenuDividerState extends State<MenuDivider> {
  @override
  Widget build(BuildContext context) {
    // Builds a divider widget that separates menu items.
    // The Divider widget is a simple horizontal line that
    // visually divides its surrounding widgets.
    return const Divider();
  }
}
