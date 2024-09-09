import 'package:flutter/cupertino.dart';

import 'height_picker.dart';
import 'height_unit_enum.dart';

/// Displays a Cupertino-style modal sheet that allows the user to pick a height.
///
/// This function shows a modal popup that allows the user to select a height value.
/// The height can be specified in either centimeters or inches.
///
/// The [key] parameter is optional and can be used to identify this widget in the widget tree.
/// 
/// The [context] parameter is required to show the modal.
///
/// The [onHeightChanged] callback is called whenever the height value changes.
///
/// The [initialHeight] parameter sets the initial height value to be displayed. Defaults to 150.0cm.
///
/// The [initialSelectedHeightUnit] parameter sets the initial unit of height to be displayed. Defaults to [HeightUnit.inches].
///
/// The [canConvertUnit] parameter determines whether the user can switch between units. Defaults to true.
///
/// The [showSeparationText] parameter determines whether separation text is shown in the picker. Defaults to true.
///
/// The [modalHeight] parameter sets the height of the modal. Defaults to 216.0.
///
/// The [maxModalWidth] parameter sets the maximum width of the modal.
///
/// The [modalBackgroundColor] parameter sets the background color of the modal.
///
/// The [barrierColor] parameter sets the color of the barrier behind the modal. Defaults to [kCupertinoModalBarrierColor].
Future<void> showCupertinoHeightPicker({
  Key? key,
  required BuildContext context,
  required Function(double) onHeightChanged,
  double initialHeight = 150.0,
  HeightUnit initialSelectedHeightUnit = HeightUnit.inches,
  bool canConvertUnit = true,
  bool showSeparationText = true,
  double modalHeight = 216.0,
  double? maxModalWidth,
  Color? modalBackgroundColor,
  Color barrierColor = kCupertinoModalBarrierColor,
}) async {
  return await showCupertinoModalPopup<void>(
    context: context,
    barrierColor: barrierColor,
    builder: (context) {
      return SafeArea(
        top: false,
        child: SizedBox(
          height: modalHeight,
          width: maxModalWidth ?? double.infinity,
          child: ColoredBox(
            color: modalBackgroundColor ??
                CupertinoColors.systemBackground.resolveFrom(context),
            child: HeightPicker(
              key: key,
              initialHeight: initialHeight,
              initialSelectedHeightUnit: initialSelectedHeightUnit,
              showSeparationText: showSeparationText,
              canConvertUnit: canConvertUnit,
              onHeightChanged: onHeightChanged,
            ),
          ),
        ),
      );
    },
  );
}
