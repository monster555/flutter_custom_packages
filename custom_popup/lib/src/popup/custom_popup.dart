import 'package:custom_popup/src/extensions/navigator_extensions.dart';
import 'package:custom_popup/src/menu/menu_content.dart';
import 'package:custom_popup/src/menu/menu_element.dart';
import 'package:custom_popup/src/popup/custom_popup_route.dart';
import 'package:flutter/material.dart';

/// A widget that provides a custom popup functionality, which can be displayed
/// when a child widget is tapped or long-pressed.
///
/// This widget allows for the display of a popup with customizable content,
/// appearance, and behavior. The popup can be shown on a regular tap or a
/// long press, and it can include an optional arrow pointing to the anchor
/// widget.
///
/// The [CustomPopup] can also be created using a factory constructor `menu`
/// to easily create menu-like popups with a list of [MenuElement] actions.
class CustomPopup extends StatelessWidget {
  /// Creates a [CustomPopup] widget that displays a customizable popup menu.
  ///
  /// The [CustomPopup] constructor initializes a popup with the specified content and child widget,
  /// allowing for extensive customization of its appearance and behavior. This widget can be used
  /// to create interactive popups that can be shown on user interactions such as taps or long presses.
  ///
  /// [child] Is the widget that triggers the popup when interacted with. This is typically a button
  /// or any other tappable element.
  ///
  /// [anchorKey] Is an optional [GlobalKey] that specifies the anchor point for positioning the
  /// popup. If provided, the popup will align relative to the widget associated with this key.
  ///
  /// [showOnLongPress] Is a boolean indicating whether the popup should be displayed on a long press
  /// of the child widget. Defaults to false, meaning the popup will show on a regular tap.
  ///
  /// [backgroundColor] Is The background color of the popup. If not provided, it defaults to a
  /// standard color.
  ///
  /// [arrowColor] Is the color of the arrow indicator, if displayed. Defaults to a standard color
  /// if not specified.
  ///
  /// [showArrow] Is a boolean indicating whether the arrow should be rendered. If set to true, the
  /// arrow will be displayed; otherwise, it will be hidden. Defaults to true.
  ///
  /// [barrierColor] Is the color of the barrier that appears behind the popup when it is displayed.
  /// This can be used to create a dimming effect for the background.
  ///
  /// [contentPadding] Specifies the internal padding for the content area of the popup. This
  /// controls the spacing between the content and the edges of the popup. Defaults to
  /// `EdgeInsets.all(16.0)`.
  ///
  /// [contentRadius] Is the radius of the popup content box's corners, allowing for rounded corners.
  /// Defaults to 16.0 if not specified.
  ///
  /// [contentDecoration] Is an optional [BoxDecoration] for additional styling of the popup content
  /// box, such as borders or gradients.
  ///
  /// ```dart
  /// CustomPopup(
  ///   contentPadding: EdgeInsets.zero,
  ///   content: ConstrainedBox(
  ///     constraints: const BoxConstraints(
  ///       maxWidth: 280.0,
  ///       maxHeight: 250.0,
  ///     ),
  ///     child: Column(
  ///       children: [
  ///         Expanded(
  ///           child: CupertinoDatePicker(
  ///             mode: CupertinoDatePickerMode.date,
  ///             onDateTimeChanged: (DateTime date) {
  ///               // Do something with the selected date
  ///               print(date);
  ///             },
  ///           ),
  ///         ),
  ///       ],
  ///     ),
  ///   ),
  ///   child: Container(
  ///     padding: const EdgeInsets.all(8.0),
  ///     color: Theme.of(context).primaryColor,
  ///     child: Text(
  ///       'Show date picker',
  ///       style: TextStyle(
  ///         color: Theme.of(context).colorScheme.onPrimary,
  ///       ),
  ///     ),
  ///   ),
  /// ),
  /// ```
  const CustomPopup({
    super.key,
    required this.content,
    required this.child,
    this.anchorKey,
    this.showOnLongPress = false,
    this.backgroundColor,
    this.arrowColor,
    this.showArrow = true,
    this.barrierColor,
    this.contentPadding = const EdgeInsets.all(16.0),
    this.contentRadius = 16.0,
    this.contentDecoration,
  });

  /// Key used to identify the anchor widget to which the popup is attached.
  final GlobalKey? anchorKey;

  /// The content to display inside the popup.
  final Widget content;

  /// The child widget that triggers the popup.
  final Widget child;

  /// Determines whether the popup should be shown on a long press.
  /// If `false`, the popup is shown on a regular tap.
  final bool showOnLongPress;

  /// Background color of the popup.
  final Color? backgroundColor;

  /// Color of the arrow pointing to the anchor widget.
  final Color? arrowColor;

  /// Color of the barrier that appears behind the popup.
  final Color? barrierColor;

  /// Determines whether to display an arrow pointing to the anchor widget.
  final bool showArrow;

  /// Padding inside the popup content.
  final EdgeInsets contentPadding;

  /// Radius of the popup's corners.
  final double contentRadius;

  /// Custom decoration for the popup content.
  final BoxDecoration? contentDecoration;

  /// Creates a [CustomPopup] with predefined menu options.
  ///
  /// A convenient way to create a [CustomPopup] with a menu-like structure. It
  /// takes the child widget, which typically triggers the popup, and a list of
  /// [MenuElement] actions to be displayed inside the popup content.
  ///
  /// [child] is the widget that triggers the popup. It is typically an icon or
  /// a button that triggers the popup.
  ///
  /// [showArrow] is a boolean indicating whether the arrow should be
  /// shown. Defaults to true.
  ///
  /// [contentRadius] is the radius of the popup content box's corners. Defaults
  /// to 16.0 if not specified.
  ///
  /// [actions] is a list of [MenuElement] actions to be displayed inside the
  /// popup content.
  ///
  /// ```dart
  /// CustomPopup.menu(
  ///   child: const Icon(CupertinoIcons.ellipsis_circle),
  ///   actions: [
  ///     MenuItem(
  ///       icon: CupertinoIcons.star,
  ///       label: 'Star',
  ///       onPressed: (){
  ///         // Do something
  ///       },
  ///     ),
  ///     MenuItem(
  ///       icon: CupertinoIcons.square_on_square,
  ///       label: 'Copy',
  ///       onPressed: (){
  ///         // Do something
  ///       },
  ///     ),
  ///     const MenuDivider(),
  ///     MenuItem(
  ///       icon: CupertinoIcons.delete,
  ///       label: 'Delete',
  ///       isDestructive: true, // Indicates that the menu item represents a destructive action
  ///       onPressed: (){
  ///         // Do something
  ///       },
  ///     ),
  ///   ],
  /// )
  /// ```
  ///
  /// See Also:
  ///
  ///  - [MenuElement] for more details.
  factory CustomPopup.menu({
    required Widget child,
    GlobalKey? anchorKey,
    bool showArrow = true,
    double contentRadius = 16.0,
    List<MenuElement> actions = const [],
  }) {
    return CustomPopup(
      anchorKey: anchorKey,
      contentPadding: EdgeInsets.zero,
      contentRadius: contentRadius,
      showArrow: showArrow,
      content: MenuContent(
        actions: actions,
      ),
      child: child,
    );
  }

  /// Displays the popup by pushing a [CustomPopupRoute] onto the navigator.
  ///
  /// This method calculates the position of the anchor widget, creates the
  /// popup route, and pushes it onto the navigator stack.
  void _show(BuildContext context) {
    // Obtain the context of the anchor key if provided, or use the current context.
    final anchor = anchorKey?.currentContext ?? context;

    final renderBox = anchor.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    // Calculate the global offset of the top-left corner of the render box.
    final offset = renderBox.localToGlobal(renderBox.paintBounds.topLeft);

    // Push the custom popup route onto the navigator.
    context
        .pushRoute(CustomPopupRoute(
          context,
          targetRect: offset & renderBox.paintBounds.size,
          backgroundColor: backgroundColor,
          arrowColor: arrowColor,
          showArrow: showArrow,
          barrierColor: barrierColor,
          contentPadding: contentPadding,
          contentRadius: contentRadius,
          contentDecoration: contentDecoration,
          child: content,
        ))
        .then(_executeCallback);
  }

  /// Executes a callback function if provided.
  ///
  /// This method is used to handle any additional actions that need to be
  /// performed after the popup is shown.
  void _executeCallback(VoidCallback? callback) => callback?.call();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPress: showOnLongPress ? () => _show(context) : null,
        onTapUp: !showOnLongPress ? (_) => _show(context) : null,
        child: child,
      ),
    );
  }
}
