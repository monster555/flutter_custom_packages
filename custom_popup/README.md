## Table of Contents

- [Overview](#overview)
- [Usage](#usage)
  - [Displaying a Basic Popup](#displaying-a-basic-popup)
  - [Without the Arrow](#without-the-arrow)
  - [Using the `.menu` Constructor](#using-the-menu-constructor)
- [Customization](#customization)

## Overview

`CustomPopup` is a Flutter package that enables developers to integrate animated popups triggered by tapping or long-pressing a child widget. These popups originate from the position of the `CustomPopup` child widget and feature smooth animations that can align with both Cupertino and Material design languages, providing a versatile user experience across platforms.

The popup's content, appearance, and behavior can be customized, including an optional arrow pointing to the child widget. The `.menu` constructor allows for quick creation of menu-like popups with a list of actions, making `CustomPopup` ideal for building interactive and visually appealing interfaces that fit seamlessly into both iOS and Android environments. 

## Usage

### Displaying a Basic Popup

```dart
import 'package:custom_popup/custom_popup.dart';

CustomPopup(
  content: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text('Hello from CustomPopup!'),
  ),
  child: Text('Show Popup'),
);
```

### Without the Arrow

```dart
import 'package:custom_popup/custom_popup.dart';

CustomPopup(
  showArrow: false,
  content: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text('Hello from CustomPopup!'),
  ),
  child: Text('Show Popup'),
);
```

### Using the `.menu` Constructor

The `CustomPopup.menu` constructor simplifies the creation of popups with a menu-like structure, ideal for displaying a list of actions or options.

```dart
import 'package:custom_popup/custom_popup.dart';

List<MenuElement> menuElements = [
    MenuItem(
      icon: CupertinoIcons.reply,
      label: 'Reply',
      onPressed: () {},
    ),
    MenuItem(
      icon: CupertinoIcons.flag,
      label: 'Flag',
      onPressed: () {},
    ),
    MenuItem(
      icon: CupertinoIcons.square_on_square,
      label: 'Duplicate',
      onPressed: () {},
    ),
    const MenuDivider(),
    MenuItem(
      icon: CupertinoIcons.delete,
      label: 'Delete Note',
      isDestructive: true,
      onPressed: () {},
    ),
];

CustomPopup.menu(
  child: Text('Show Menu Popup'),
  actions: menuElements,
);
```

## Customization

`CustomPopup` provides several options for tailoring the popup's appearance and behavior to fit the application's design:

- **Trigger Interaction**: Configure how the popup is activated by setting the `showOnLongPress` property. Enable it for activation on a long press, or use the default setting for activation on a regular tap.

- **Visual Appearance**: Customize the popup's color scheme. Use `backgroundColor` for the main color, `arrowColor` for the optional arrow, and `barrierColor` to adjust the background overlay, creating a dimming effect.

- **Arrow Display**: Control the visibility of an arrow pointing to the trigger widget by setting the `showArrow` property, providing a clear visual link to the popup's origin.

- **Content Styling**: Adjust the interior styling of the popup using `contentPadding` for spacing, `contentRadius` for rounded corners, and `contentDecoration` for additional styling options like borders or gradients.

- **Positioning**: Use the `anchorKey` to align the popup relative to other UI components, ensuring precise placement and maintaining spatial context.

These options allow `CustomPopup` to be adapted to various design requirements and user interaction scenarios.
