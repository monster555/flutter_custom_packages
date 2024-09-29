# Flutter Custom Packages

This repository contains two custom **Flutter** packages:

1. `CustomPopup`
2. `CustomSlideContextTile`

These packages are the result of my experimentation and enjoyment in **Flutter** development, designed to improve the user experience in **Flutter** applications.

## Packages

### CustomPopup

`CustomPopup` is a **Flutter** package that enables developers to integrate animated popups triggered by tapping or long-pressing a child widget. These popups originate from the position of the `CustomPopup` child widget and feature smooth animations that can align with both Cupertino and Material design languages.

[Learn more about CustomPopup](./custom_popup/README.md)

### CustomSlideContextTile

`CustomSlideContextTile` is a **Flutter** package that enhances list items by adding swipeable leading and trailing actions. It provides a smooth and interactive way to reveal contextual actions for list items, offering an intuitive and space-efficient interface for mobile applications. This versatile package can be adapted to various UI designs and requirements, making it suitable for a wide range of mobile app interfaces.

[Learn more about CustomSlideContextTile](./custom_slide_context_tile/README.md)

## Installation

To use these packages in your **Flutter** project, add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  custom_popup:
    git:
      url: https://github.com/monster555/flutter_custom_packages.git
      path: custom_popup
  custom_slide_context_tile:
    git:
      url: https://github.com/monster555/flutter_custom_packages.git
      path: custom_slide_context_tile
```

## Usage

For detailed usage instructions and examples, please refer to the README of each package:

- [CustomPopup Usage](./custom_popup/README.md#usage)
- [CustomSlideContextTile Usage](./custom_slide_context_tile/README.md#basic-usage)

## Examples

You can find example projects demonstrating the use of these packages in their respective example folders:
- [CustomPopup Examples](./custom_popup/example/)
- [CustomSlideContextTile Examples](./custom_slide_context_tile/example/)

## Contributing

Contributions to either package are welcome! Please feel free to submit issues or pull requests.

## License

Both packages are licensed under the MIT License. See the LICENSE file for details.
