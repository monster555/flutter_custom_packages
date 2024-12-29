# Custom Expandable Slider

A customizable slider widget for Flutter that expands on interaction, providing an enhanced user experience with haptic feedback and visual indicators.

## Features

- Smooth expansion animation on interaction
- Customizable colors and styling
- Optional thumb indicator with progress percentage
- Haptic feedback at slider boundaries
- Easy to integrate and customize

## Usage

```dart
CustomExpandableSlider(
  width: 200,
  height: 40,
  onProgressChanged: (value) {
    print('Progress: ${value * 100}%');
  },
  color: Colors.red,
  enableHaptics: false,
  showThumb: false,
)
```

![no_tumb_no_haptics](https://github.com/user-attachments/assets/dfa7cead-90a2-49e4-9162-17111722a9ec)

## With Thumb Constructor

```dart
CustomExpandableSlider.withThumb(
  width: 200,
  height: 40,
  onProgressChanged: (value) {
    print('Progress: ${value * 100}%');
  },
  color: Colors.green,
)
```

![with_thumb](https://github.com/user-attachments/assets/694b6857-3693-40ff-96fc-ebf8c6b59f0d)

## Example
An example project is included to demonstrate the usage and customization of the `CustomExpandableSlider` widget. Please refer to the example directory for more details.

## Properties

### Required
- `width` (double): The width of the slider
- `height` (double): The height of the slider
- `onProgressChanged` (Function(double)): Callback triggered when progress changes

### Optional
- `initialValue` (double): Initial progress value (0.0 to 1.0). Defaults to 0.0
- `color` (Color): Main color of the slider. Defaults to Colors.blue
- `backgroundColor` (Color): Background color. Defaults to Colors.grey
- `showThumb` (bool): Show/hide the progress thumb. Defaults to false

### Styling
- `border` (BoxBorder?): Optional border decoration
- `borderRadius` (BorderRadius): Border radius. Defaults to BorderRadius.circular(8.0)

### Behavior
- `enableHaptics` (bool): Enable/disable haptic feedback. Defaults to true

## Support
Like this project? Show your support with a ⭐️ — it’s free and means a lot!<br> 
Feeling generous? A coffee would definitely kickstart my morning! ☕ Thanks!

<a href="https://www.buymeacoffee.com/danicoy" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
