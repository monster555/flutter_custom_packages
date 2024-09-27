import 'package:flutter/cupertino.dart';

/// A `BuildContext` extension for convenient navigation methods.
extension NavigatorX on BuildContext {
  /// Pushes the given route onto the navigator stack.
  ///
  /// [route] is the [Route] object to push onto the stack. It determines the screen
  ///   that will be displayed next.
  ///
  /// Returns a [Future] that completes when the pushed route is popped. If a result
  /// is returned from the popped route, the [Future] completes with that value.
  ///
  /// ```dart
  /// final result = await context.pushRoute(
  ///   CupertinoPageRoute(builder: (_) => NewScreen()),
  /// );
  /// if (result != null) {
  ///   // Handle the result
  /// }
  /// ```
  ///
  /// This method is a shorthand for `Navigator.of(context).push(route)` and provides
  /// a more readable and convenient way to navigate between screens using the provided route.
  Future<T?> pushRoute<T extends Object?>(Route<T> route) =>
      Navigator.of(this).push(route);

  /// Pops the top-most route off the navigator stack.
  ///
  /// [result] is an optional result to return to the previous route when popping.
  /// The result is of type [T], which extends [Object], and it can be null.
  ///
  /// This method is a convenient way to call `Navigator.of(context).pop(result)`
  /// within your widget code, allowing you to close the current screen and optionally
  /// return a result to the previous route.
  ///
  /// ```dart
  /// context.pop(); // Simple pop with no result
  /// context.pop('Some result'); // Pop with a result
  /// ```
  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);
}
