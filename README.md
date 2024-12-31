# Flutter Custom Packages

This repository contains a few custom **Flutter** packages:

1. `CustomPopup`
2. `CustomSlideContextTile`
3. `CustomExpandableSlider`

Just a set of **Flutter** packages I've built. No third-party libraries.

No package leaves without passing a comprehensive test battery ;)

## Packages

### CustomPopup

`CustomPopup` is a **Flutter** package that enables developers to integrate animated popups triggered by tapping or long-pressing a child widget. These popups originate from the position of the `CustomPopup` child widget and feature smooth animations that can align with both Cupertino and Material design languages.

[Learn more about CustomPopup](./custom_popup/README.md)

### CustomSlideContextTile

`CustomSlideContextTile` is a **Flutter** package that enhances list items by adding swipeable leading and trailing actions. It provides a smooth and interactive way to reveal contextual actions for list items, offering an intuitive and space-efficient interface for mobile applications. This versatile package can be adapted to various UI designs and requirements, making it suitable for a wide range of mobile app interfaces.

[Learn more about CustomSlideContextTile](./custom_slide_context_tile/README.md)

### CustomExpandableSlider

`CustomExpandableSlider` is a **Flutter** widget that provides an expandable slider with smooth animations. It features expansion animations using `Transform` and `AnimationController`, easily customizable appearance, and haptic feedback for enhanced user experience. This widget is implemented without relying on third-party packages, offering full control over its behavior and appearance.

[Learn more about CustomExpandableSlider](./custom_expandable_slider/README.md)

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

  custom_expandable_slider:
    git:
      url: https://github.com/monster555/flutter_custom_packages.git
      path: custom_expandable_slider
```

## Usage

For detailed usage instructions and examples, please refer to the README of each package:

- [CustomPopup Usage](./custom_popup/README.md#usage)
- [CustomSlideContextTile Usage](./custom_slide_context_tile/README.md#basic-usage)
- [CustomExpandableSlider Usage](./custom_expandable_slider/README.md#usage)

## Examples

You can find example projects demonstrating the use of these packages in their respective example folders:
- [CustomPopup Examples](./custom_popup/example/)
- [CustomSlideContextTile Examples](./custom_slide_context_tile/example/)
- [CustomExpandableSlider Examples](./custom_expandable_slider/example/)

## Contributing

Contributions to either package are welcome! Please feel free to submit issues or pull requests.

## Support
Like this project? Show your support with a ⭐️ — it’s free and means a lot!<br> 
Feeling generous? A coffee would definitely kickstart my morning! ☕ Thanks!

<a href="https://www.buymeacoffee.com/danicoy" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

## License

These packages are licensed under the MIT License. See the LICENSE file for details.
