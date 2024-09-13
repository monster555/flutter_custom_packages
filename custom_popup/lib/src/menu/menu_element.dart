import 'package:flutter/material.dart';

/// An abstract class that defines the base data type for menu elements in a menu widget.
///
/// The [MenuElement] class serves as a foundational class for all elements
/// that can be children of a custom menu widget. By extending this class,
/// specific menu item types such as `MenuItem` and `MenuDivider`are ensured to
/// be supported as valid children of the menu.
///
/// This class extends [StatefulWidget] to allow for dynamic updates and interactions
/// within the menu, enabling more complex and stateful behavior for its derived widgets.
///
/// ## Purpose
///
/// The primary goal of the [MenuElement] class is to provide a type-safe mechanism
/// for defining the allowed children of the menu widget. This ensures consistency
/// and prevents invalid widget types from being used as menu elements.
///
/// ## Supported Elements
///
/// Currently, the following elements are supported as children of the menu:
/// - `MenuItem`
/// - `MenuDivider`
///
/// Here is an example of how to create and use a custom menu with supported elements:
///
/// ```dart
/// class MyMenu extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return CustomMenuButton(
///       actions: [
///         MenuItem(
///           title: 'Item 1',
///           onPressed: (){
///             // Do something here
///           },
///         ),
///         MenuDivider(),
///         MenuItem(
///           title: 'Delete',
///           onPressed: (){
///             // Do something here
///           },
///         ),
///       ],
///     );
///   }
/// }
/// ```
abstract class MenuElement extends StatefulWidget {
  const MenuElement({super.key});
}
