import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A platform-adaptive ListTile that automatically adjusts its appearance based on the current platform.
///
/// This widget intelligently chooses between [CupertinoListTile] for iOS and macOS platforms
/// and [ListTile] for other platforms, providing a native look and feel across different devices.
///
/// The [useAdaptiveListTile] flag allows overriding this behavior, forcing the use of [ListTile]
/// on all platforms when set to true.
///
/// This widget ensures a consistent minimum height across all platforms, making it ideal
/// for creating uniform list views in cross-platform applications.
class AdaptiveListTile extends StatelessWidget {
  /// Creates an [AdaptiveListTile].
  ///
  /// The [title] argument must not be null.
  /// The [useAdaptiveListTile] defaults to false, enabling platform-specific rendering.
  const AdaptiveListTile({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.useAdaptiveListTile = false,
  });

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  ///
  /// This field is required and cannot be null.
  final Widget title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  ///
  /// If null, the subtitle line will be omitted.
  final Widget? subtitle;

  /// A widget to display before the title.
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget.
  final Widget? leading;

  /// A widget to display after the title.
  ///
  /// Typically an [Icon] widget.
  ///
  /// To show right-aligned metadata instead of a trailing icon (e.g., the time of a message),
  /// consider using [ListTile.isThreeLine] and [ListTile.subtitle].
  final Widget? trailing;

  /// Called when the user taps this list tile.
  ///
  /// If null, the tile will not react to taps.
  final VoidCallback? onTap;

  /// Determines whether to use the adaptive list tile behavior.
  ///
  /// If false (default), the widget will use [CupertinoListTile] on iOS and macOS,
  /// and [ListTile] on other platforms.
  ///
  /// If true, [ListTile] will be used on all platforms, overriding the default adaptive behavior.
  ///
  /// This flag is useful when you want to maintain a consistent Material Design look
  /// across all platforms in your app.
  final bool useAdaptiveListTile;

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final isApplePlatform =
        platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;

    final Widget child;
    if (useAdaptiveListTile && !isApplePlatform) {
      // Use Material ListTile for other platforms or when overridden
      child = Material(
        child: ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListTile(
            title: title,
            subtitle: subtitle,
            leading: leading,
            trailing: trailing,
            onTap: onTap,
          ),
        ),
      );
    } else {
      // Use CupertinoListTile for Apple platforms when not overridden
      child = CupertinoListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        onTap: onTap,
        backgroundColor: CupertinoColors.systemBackground,
      );
    }

    // Ensure a minimum height for the list tile
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 48,
      ),
      child: child,
    );
  }
}
