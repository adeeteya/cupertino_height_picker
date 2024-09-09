import 'package:cupertino_height_picker/cupertino_height_picker.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: "Cupertino Height Picker Example",
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double heightInCm = 150;
  HeightUnit selectedHeightUnit = HeightUnit.cm;
  bool canConvertUnit = true;
  bool showSeparationText = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Cupertino Height Picker Example"),
      ),
      child: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Height: ${heightInCm.toStringAsFixed(1)} cm",
                style:
                    CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
              ),
              const SizedBox(height: 20),
              CupertinoFormSection(
                children: [
                  CupertinoFormRow(
                    prefix: const Text("Unit Convertible"),
                    child: CupertinoSwitch(
                      onChanged: (val) {
                        setState(() {
                          canConvertUnit = val;
                        });
                      },
                      value: canConvertUnit,
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: const Text("Show Separation Text"),
                    child: CupertinoSwitch(
                      onChanged: (val) {
                        setState(() {
                          showSeparationText = val;
                        });
                      },
                      value: showSeparationText,
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: const Text("Selected Unit"),
                    child: CupertinoSlidingSegmentedControl<HeightUnit>(
                      groupValue: selectedHeightUnit,
                      children: const {
                        HeightUnit.inches: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("Feet/Inches"),
                        ),
                        HeightUnit.cm: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("Centimeters"),
                        ),
                      },
                      onValueChanged: (val) {
                        setState(() {
                          selectedHeightUnit = val!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                child: const Text("Pick height"),
                onPressed: () async {
                  await showCupertinoHeightPicker(
                    context: context,
                    initialHeight: heightInCm,
                    initialSelectedHeightUnit: selectedHeightUnit,
                    canConvertUnit: canConvertUnit,
                    showSeparationText: showSeparationText,
                    onHeightChanged: (val) {
                      setState(() {
                        heightInCm = val;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
