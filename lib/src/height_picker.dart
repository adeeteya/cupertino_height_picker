import 'package:flutter/cupertino.dart';
import 'height_unit_enum.dart';

/// A widget that allows users to pick a height value.
///
/// The height can be selected in either centimeters or inches.
class HeightPicker extends StatefulWidget {
  /// The initial height value to be displayed.
  final double initialHeight;

  /// The initial unit of height to be displayed.
  final HeightUnit initialSelectedHeightUnit;

  /// Whether to show separation text in the picker.
  final bool showSeparationText;

  /// Whether the user can switch between units.
  final bool canConvertUnit;

  /// Callback function that is called whenever the height value changes.
  final Function(double) onHeightChanged;

  /// Creates a [HeightPicker] widget.
  ///
  /// The [initialHeight], [initialSelectedHeightUnit], [showSeparationText], and [onHeightChanged]
  /// parameters are required.
  const HeightPicker({
    super.key,
    required this.initialHeight,
    required this.initialSelectedHeightUnit,
    required this.showSeparationText,
    required this.canConvertUnit,
    required this.onHeightChanged,
  });

  @override
  State<HeightPicker> createState() => _HeightPickerState();
}

/// The state for the [HeightPicker] widget.
class _HeightPickerState extends State<HeightPicker> {
  /// The current height value in centimeters.
  late double _cmValue;

  /// Whether the height is currently being converted between units.
  bool _isConverting = false;

  /// The currently selected height unit.
  late HeightUnit _currentUnitSelected;

  /// Controller for the main scroll view.
  late final FixedExtentScrollController _mainScrollController;

  /// Controller for the secondary scroll view.
  late final FixedExtentScrollController _secondaryScrollController;

  /// Controller for the unit scroll view.
  late final FixedExtentScrollController _unitScrollController;

  /// The feet part of the height when converted to inches.
  int get _feetPart => (_cmValue / 2.54) ~/ 12;

  /// The inches part of the height when converted to inches.
  int get _inchesPart => ((_cmValue / 2.54) % 12).floor();

  /// The whole number part of the height in centimeters.
  int get _cmWholeValue => _cmValue.floor();

  /// The decimal part of the height in centimeters.
  int get _cmDecimalValue => ((_cmValue - _cmValue.truncate()) * 10).round();

  /// Converts a height from feet and inches to centimeters.
  ///
  /// Takes [feet] and [inches] as input and returns the height in centimeters.
  double _convertInchesToCm(int feet, int inches) {
    int inchesTotal = (feet * 12) + inches;
    return inchesTotal * 2.54;
  }

  /// Initializes the state of the [HeightPicker] widget.
  ///
  /// Sets the initial height value and the selected height unit. Initializes
  /// the scroll controllers based on the selected height unit.
  @override
  void initState() {
    _cmValue = widget.initialHeight;
    _currentUnitSelected = widget.initialSelectedHeightUnit;
    if (widget.initialSelectedHeightUnit == HeightUnit.inches) {
      _mainScrollController =
          FixedExtentScrollController(initialItem: _feetPart - 1);
      _secondaryScrollController =
          FixedExtentScrollController(initialItem: _inchesPart);
      _unitScrollController = FixedExtentScrollController(initialItem: 0);
    } else {
      _mainScrollController =
          FixedExtentScrollController(initialItem: _cmWholeValue - 1);
      _secondaryScrollController =
          FixedExtentScrollController(initialItem: _cmDecimalValue);
      _unitScrollController = FixedExtentScrollController(initialItem: 1);
    }
    super.initState();
  }

  /// Disposes the scroll controllers to free up resources.
  @override
  void dispose() {
    _mainScrollController.dispose();
    _secondaryScrollController.dispose();
    _unitScrollController.dispose();
    super.dispose();
  }

  /// Handles changes in the selected height unit.
  ///
  /// Animates the scroll controllers to the appropriate positions based on the
  /// selected height unit. Updates the state to reflect the new height unit.
  ///
  /// [index] is the index of the selected height unit.
  Future<void> onHeightUnitChanged(int index) async {
    if (index == 0 && _currentUnitSelected != HeightUnit.inches) {
      setState(() {
        _isConverting = true;
        _currentUnitSelected = HeightUnit.inches;
      });
      _mainScrollController.animateToItem(
        _feetPart - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      await _secondaryScrollController.animateToItem(
        _inchesPart,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      setState(() {
        _isConverting = false;
      });
    }
    if (index == 1 && _currentUnitSelected != HeightUnit.cm) {
      setState(() {
        _isConverting = true;
        _currentUnitSelected = HeightUnit.cm;
      });
      _mainScrollController.animateToItem(
        _cmWholeValue - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      await _secondaryScrollController.animateToItem(
        _cmDecimalValue,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      setState(() {
        _isConverting = false;
      });
    }
  }

  /// Handles changes in the main scroll view.
  ///
  /// Updates the height value based on the selected item in the main scroll view.
  /// Calls the [onHeightChanged] callback with the new height value.
  ///
  /// [index] is the index of the selected item.
  void onMainSelectedItemChanged(int index) {
    if (_isConverting) return;
    if (_currentUnitSelected == HeightUnit.inches) {
      _cmValue = _convertInchesToCm(
          index + 1, _secondaryScrollController.selectedItem);
    } else {
      _cmValue = (index + 1) + (_secondaryScrollController.selectedItem * 0.1);
    }
    setState(() {});
    widget.onHeightChanged(_cmValue);
  }

  /// Handles changes in the secondary scroll view.
  ///
  /// Updates the height value based on the selected item in the secondary scroll view.
  /// Calls the [onHeightChanged] callback with the new height value.
  ///
  /// [index] is the index of the selected item.
  void onSecondarySelectedItemChanged(int index) {
    if (_isConverting) return;
    if (_currentUnitSelected == HeightUnit.inches) {
      _cmValue =
          _convertInchesToCm(_mainScrollController.selectedItem + 1, index);
    } else {
      _cmValue = (_mainScrollController.selectedItem + 1) + (index * 0.1);
    }
    setState(() {});
    widget.onHeightChanged(_cmValue);
  }

  /// Builds the [HeightPicker] widget.
  ///
  /// Returns a row of [CupertinoPicker] widgets for selecting the height value
  /// and the height unit. The pickers are configured based on the current height
  /// unit and the provided widget properties.
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: _mainScrollController,
            selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
              capEndEdge: false,
            ),
            onSelectedItemChanged: onMainSelectedItemChanged,
            children: List.generate(
              (_currentUnitSelected == HeightUnit.inches) ? 9 : 275,
              (index) => Text("${index + 1}"),
            ),
          ),
        ),
        if (widget.showSeparationText)
          Expanded(
            child: SizedBox(
              height: 32,
              child: Stack(
                children: [
                  const CupertinoPickerDefaultSelectionOverlay(
                    capStartEdge: false,
                    capEndEdge: false,
                  ),
                  Center(
                    child: Text(
                      (_currentUnitSelected == HeightUnit.inches)
                          ? "feet"
                          : ".",
                      style:
                          CupertinoTheme.of(context).textTheme.pickerTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Expanded(
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: _secondaryScrollController,
            selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
              capStartEdge: false,
              capEndEdge: false,
            ),
            onSelectedItemChanged: onSecondarySelectedItemChanged,
            children: List.generate(
              (_currentUnitSelected == HeightUnit.inches) ? 12 : 10,
              (index) => Text("$index"),
            ),
          ),
        ),
        if (widget.canConvertUnit)
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32,
              scrollController: _unitScrollController,
              selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
                capStartEdge: false,
              ),
              onSelectedItemChanged: onHeightUnitChanged,
              children: const [
                Text("inches"),
                Text("cm"),
              ],
            ),
          ),
        if (!widget.canConvertUnit)
          Expanded(
            child: SizedBox(
              height: 32,
              child: Stack(
                children: [
                  const CupertinoPickerDefaultSelectionOverlay(
                    capStartEdge: false,
                  ),
                  Center(
                    child: Text(
                      (_currentUnitSelected == HeightUnit.inches)
                          ? "inches"
                          : "cm",
                      style:
                          CupertinoTheme.of(context).textTheme.pickerTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
