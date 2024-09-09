/// A library for displaying Cupertino-style height pickers.
///
/// This library provides widgets and utilities for selecting height values
/// in either centimeters or inches. It includes a modal popup for height
/// selection and an enumeration for height units.
///
/// Terminology:
/// - HeightUnit: An enumeration representing the units of height (centimeters or inches).
/// - HeightPicker: A widget that allows users to pick a height value.
///
/// Example usage:
///
/// ```dart
/// import 'package:cupertino_height_picker/cupertino_height_picker.dart';
///
/// void main() {
///   runApp(MyApp());
/// }
///
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return CupertinoApp(
///       home: CupertinoPageScaffold(
///         navigationBar: CupertinoNavigationBar(
///           middle: Text('Height Picker Example'),
///         ),
///         child: Center(
///           child: CupertinoButton(
///             child: Text('Select Height'),
///             onPressed: () {
///               showCupertinoHeightPicker(
///                 context: context,
///                 onHeightChanged: (double height) {
///                   print('Selected height: $height');
///                 },
///                 initialHeight: 170.0,
///                 initialSelectedHeightUnit: HeightUnit.centimeters,
///               );
///             },
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// Links:
/// - [HeightUnit]
/// - [showCupertinoHeightPicker]
library cupertino_height_picker;

export 'src/height_unit_enum.dart';
export 'src/height_picker_modal_sheet.dart';
