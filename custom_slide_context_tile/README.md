# CustomSlideContextTile

`CustomSlideContextTile` is a Flutter package that adds leading and trailing actions to a CupertinoListTile. It provides a smooth and interactive way to reveal contextual actions for list items.

## Features

- Actions on both leading and trailing sides
- Long drag to trigger default actions (first leading action or last trailing action)
- Haptic feedback on iOS (Android support pending due to device variability)
- Three built-in animation types: Reveal, Pull, and Parallax
- Customizable appearance and behavior
- Optional context menu support

## Table of Contents

- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [Animation Types](#animation-types)
- [Customization](#customization)
- [Examples](#examples)

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  custom_slide_context_tile:
    git:
      url: https://github.com/yourusername/flutter_custom_packages.git
      path: custom_slide_context_tile
```

## Basic Usage

Here's a basic example of how to use `CustomSlideContextTile`:

```dart
import 'package:custom_slide_context_tile/custom_slide_context_tile.dart';

CustomSlideContextTile(
  title: Text('Swipeable List Tile'),
  subtitle: Text('Swipe left or right to reveal actions'),
  leading: Icon(Icons.star),
  trailing: Icon(Icons.arrow_forward_ios),
  leadingActions: [
    MenuAction(
      onPressed: () => print('Archive'),
      icon: Icons.archive,
      label: 'Archive',
      backgroundColor: Colors.blue,
    ),
  ],
  trailingActions: [
    MenuAction(
      onPressed: () => print('Delete'),
      icon: Icons.delete,
      label: 'Delete',
      backgroundColor: Colors.red,
      isDestructive: true,
    ),
  ],
  onTap: () => print('Tile tapped'),
)
```

## Animation Types

`CustomSlideContextTile` offers three built-in animation types:

1. Reveal: Actions appear to be uncovered as the tile is swiped, as if they were behind the slidable widget.
2. Pull: Actions seem to be pulled from the edge like a drawer.
3. Parallax: Adds a parallax effect to the actions during swiping.

To set the animation type, use the revealAnimationType parameter:

```dart
CustomSlideContextTile(
  revealAnimationType: RevealAnimationType.parallax,
  // ... other parameters
)
```

## Customization

`CustomSlideContextTile` offers various customization options:
- Action Appearance: Customize colors, icons, and labels for each action.
- Animation Type: Choose between Reveal, Pull, and Parallax animations.
- Action Execution Threshold: Set the drag distance required to trigger the default action.
- Context Menu: Enable or disable the context menu feature.

Example of customization:
```dart
CustomSlideContextTile(
  title: Text('Customized Tile'),
  subtitle: Text('With custom settings'),
  revealAnimationType: RevealAnimationType.pull,
  actionExecutionThreshold: 120.0,
  shouldCloseOnScroll: false,
  leadingActions: [
    MenuAction(
      onTap: () => print('Custom Action'),
      backgroundColor: Colors.green,
      icon: Icons.star,
      label: 'Favorite',
    ),
  ],
  // ... other parameters
)
```

## Examples

Basic Usage with Leading and Trailing Actions

```dart
CustomSlideContextTile(
  title: Text('Swipeable List Tile'),
  subtitle: Text('Swipe left or right to reveal actions'),
  leadingActions: [
    MenuAction(
      onTap: () => print('Archive'),
      backgroundColor: Colors.blue,
      icon: Icons.archive,
      label: 'Archive',
    ),
  ],
  trailingActions: [
    MenuAction(
      onTap: () => print('Delete'),
      backgroundColor: Colors.red,
      icon: Icons.delete,
      label: 'Delete',
    ),
    MenuAction(
      onTap: () => print('Flag'),
      backgroundColor: Colors.orange,
      icon: Icons.flag,
      label: 'Flag',
    ),
  ],
)
```

## Using Context Menu

```dart
CustomSlideContextTile.withContextMenu(
  title: Text('Tile with Context Menu'),
  subtitle: Text('Long press to show context menu'),
  leadingActions: [
    MenuAction(
      onTap: () => print('Share'),
      backgroundColor: Colors.green,
      icon: Icons.share,
      label: 'Share',
    ),
  ],
  trailingActions: [
    MenuAction(
      onTap: () => print('Edit'),
      backgroundColor: Colors.blue,
      icon: Icons.edit,
      label: 'Edit',
    ),
  ],
)
```

For more examples and advanced usage, please refer to the [example folder](https://github.com/monster555/flutter_custom_packages/tree/main/custom_slide_context_tile/example) in the package repository.