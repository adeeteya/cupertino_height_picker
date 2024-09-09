A seamless Cupertino-style height picker widget for Flutter.
Supports height selection in both centimeters (metric) and feet/inches (imperial), providing versatility and precision for users.

| Imperial System | Metric System | Automatic Unit Conversion |
| :---: | :---: | :---: |
| <img src="https://raw.githubusercontent.com/adeeteya/cupertino_height_picker/master/screenshots/imperial_system_demo.gif" height="350px" alt="Imperial System Demo"> | <img src="https://raw.githubusercontent.com/adeeteya/cupertino_height_picker/master/screenshots/metric_system_demo.gif" height="350px" alt="Metric System Demo"> | <img src="https://raw.githubusercontent.com/adeeteya/cupertino_height_picker/master/screenshots/unit_convert_demo.gif" height="350px" alt="Unit Conversion Demo"> |

## Features

- **Automatic Unit Conversion**: Effortlessly switch between centimeters and feet/inches with automatic conversions.
- **Decimal Value Precision**: Allows for precise height measurements.
- **Cupertino Styled Number Picker**: A clean, intuitive interface consistent with iOS design.
- **Light & Dark Themes:** Built-in support for both light and dark themes, adapting to the user's theme settings.

## Getting started

### 1. Depend on it

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  cupertino_height_picker: ^1.0.1
```

### 2. Install it

You can install packages from the command line:

```
$ flutter pub get
```

### 3. Import it

Now in your `Dart` code, you can use:

```dart
import 'package:cupertino_height_picker/cupertino_height_picker.dart';
```

## Usage

Call the default showCupertinoHeightPicker Function which always returns the height in centimeters and has automatic unit conversion enabled by default


<img src="https://raw.githubusercontent.com/adeeteya/cupertino_height_picker/master/screenshots/usage_1.png" align = "right" height = "250px" alt="screenshot_1">

```dart
await showCupertinoHeightPicker(
  context: context,
  onHeightChanged: (val) {
    setState(() {
      heightInCm = val;
      });
  },
);




```

Allow Height to be input only from metric system

<img src="https://raw.githubusercontent.com/adeeteya/cupertino_height_picker/master/screenshots/usage_2.png" align = "right" height = "250px" alt="screenshot_2">

```dart
await showCupertinoHeightPicker(
  context: context,
  initialSelectedHeightUnit:HeightUnit.cm,
  canConvertUnit: false,
  onHeightChanged: (val) {
    print(val);
  },
);




```

Start from a custom initial height and don't show the separation text between feet and inches

<img src="https://raw.githubusercontent.com/adeeteya/cupertino_height_picker/master/screenshots/usage_3.png" align = "right" height = "250px" alt="screenshot_3">

```dart
await showCupertinoHeightPicker(
  context: context,
  initialHeight: 185.5,
  showSeparationText: false,
  onHeightChanged: (val) {
    print(val);
  },
);




```

Customize the Look of the Modal to your liking!

<img src="https://raw.githubusercontent.com/adeeteya/cupertino_height_picker/master/screenshots/usage_4.png" align = "right" height = "250px" alt="screenshot_4">

```dart
await showCupertinoHeightPicker(
  context: context,
  modalHeight: 300,
  maxModalWidth: 500,
  modalBackgroundColor: CupertinoColors.systemTeal,
  barrierColor: CupertinoColors.systemGreen.withOpacity(0.5),
  onHeightChanged: (val) {
    print(val);
  },
);


```

### Parameters

- **context**: (Required) The `BuildContext` object, which is necessary for rendering the height picker within the widget tree.

- **onHeightChanged**: (Required) A callback function that handles height changes when the user scrolls through different height values. The selected height is returned in centimeters.

- **initialHeight**: Sets the default initial height value when the picker is opened. The default is `150.0` cm.

- **initialSelectedHeightUnit**: Specifies the default height unit (either `HeightUnit.inches` or `HeightUnit.cm`) when the picker is opened. The default is `HeightUnit.inches`.

- **canConvertUnit**: A boolean that determines whether the height picker allows conversion between imperial and metric systems. The default is `true`.

- **showSeparationText**: A boolean that controls whether a separation text (e.g., 'feet') or a decimal point text is shown between the two sliders. The default is `true`.

- **modalHeight**: Specifies the height of the modal sheet. The default value is `216.0`.

- **maxModalWidth**: Defines the maximum width of the modal sheet. This is useful for responsiveness on larger screens, such as tablets and laptops. If `null`, the modal takes up the full device width. The default is `null`.

- **modalBackgroundColor**: Defines the background color of the modal sheet. The default is `null`.

- **barrierColor**: Sets the color of the screen behind the modal, allowing for a custom background color with reduced opacity. The default is `kCupertinoModalBarrierColor`.

## Maintainers

[Aditya R](https://www.github.com/adeeteya/)
