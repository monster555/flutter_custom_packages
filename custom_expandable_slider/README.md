# Flutter Expandable Slider

A customizable slider widget for Flutter that expands on interaction, providing an enhanced user experience with haptic feedback and visual indicators.

## Features

- Smooth expansion animation on interaction
- Customizable colors and styling
- Optional thumb indicator with progress percentage
- Haptic feedback at slider boundaries
- Easy to integrate and customize

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_expandable_slider: ^latest_version
```

## Usage

```dart
ExpandableSlider(
  width: 200,
  height: 40,
  onProgressChanged: (value) {
    print('Progress: ${value * 100}%');
  },
  color: Colors.blue,
  enableHaptics: false,
  showThumb: false,
)
```

## With Thumb Constructor

```dart
ExpandableSlider.withThumb(
  width: 200,
  height: 40,
  onProgressChanged: (value) {
    print('Progress: ${value * 100}%');
  },
  color: Colors.blue,
)
```

## Example
An example project is included to demonstrate the usage and customization of the `ExpandableSlider` widget. Please refer to the example directory for more details.

<!-- Include GIFs here -->

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

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.