import 'package:cupertino_height_picker/cupertino_height_picker.dart';
import 'package:cupertino_height_picker/src/height_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('showCupertinoHeightPicker displays the modal correctly',
      (WidgetTester tester) async {
    final modalKey = GlobalKey<State<HeightPicker>>();

    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (BuildContext context) {
            return CupertinoButton(
              child: const Text('Show Picker'),
              onPressed: () {
                showCupertinoHeightPicker(
                  key: modalKey,
                  context: context,
                  onHeightChanged: (height) {},
                );
              },
            );
          },
        ),
      ),
    );

    // Tap the button to show the picker
    await tester.tap(find.text('Show Picker'));
    await tester.pumpAndSettle();

    // Verify that the modal is displayed
    expect(find.byKey(modalKey), findsOneWidget);
  });

  testWidgets('showCupertinoHeightPicker calls onHeightChanged callback',
      (WidgetTester tester) async {
    double targetHeight = 135;
    double? callbackHeight;

    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (BuildContext context) {
            return CupertinoButton(
              child: const Text('Show Picker'),
              onPressed: () {
                showCupertinoHeightPicker(
                  context: context,
                  initialSelectedHeightUnit: HeightUnit.cm,
                  onHeightChanged: (height) {
                    callbackHeight = height;
                  },
                );
              },
            );
          },
        ),
      ),
    );

    // Tap the button to show the picker
    await tester.tap(find.text('Show Picker'));
    await tester.pumpAndSettle();

    // Simulate Dragging
    await tester.drag(find.text('150'), const Offset(0, 500));
    await tester.pumpAndSettle();

    // Verify the callback is called with the correct height
    expect(callbackHeight, targetHeight);
  });

  testWidgets('showCupertinoHeightPicker sets initial height correctly',
      (WidgetTester tester) async {
    const int initialHeightWholeValue = 210;
    const int initialHeightDecimalValue = 3;

    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (BuildContext context) {
            return CupertinoButton(
              child: const Text('Show Picker'),
              onPressed: () {
                showCupertinoHeightPicker(
                  context: context,
                  initialHeight: (initialHeightWholeValue +
                      initialHeightDecimalValue * 0.1),
                  initialSelectedHeightUnit: HeightUnit.cm,
                  onHeightChanged: (height) {},
                );
              },
            );
          },
        ),
      ),
    );

    // Tap the button to show the picker
    await tester.tap(find.text('Show Picker'));
    await tester.pumpAndSettle();

    // Verify the initial height is set correctly
    expect(find.text('$initialHeightWholeValue'), findsOneWidget);
    expect(find.text('.'), findsOneWidget);
    expect(find.text('$initialHeightDecimalValue'), findsOneWidget);
  });

  testWidgets(
      'showCupertinoHeightPicker sets initial unit and canConvertUnit correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (BuildContext context) {
            return CupertinoButton(
              child: const Text('Show Picker'),
              onPressed: () {
                showCupertinoHeightPicker(
                  context: context,
                  canConvertUnit: false,
                  initialSelectedHeightUnit: HeightUnit.cm,
                  onHeightChanged: (height) {},
                );
              },
            );
          },
        ),
      ),
    );

    // Tap the button to show the picker
    await tester.tap(find.text('Show Picker'));
    await tester.pumpAndSettle();

    // Verify that the initial unit and canConvertUnit is set correctly
    expect(find.text('cm'), findsOneWidget);
    expect(find.text('inches'), findsNothing);
  });

  testWidgets(
      'showCupertinoHeightPicker automatically converts the unit values',
      (WidgetTester tester) async {
    double targetHeight = 172.72;
    double? callbackHeight;

    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (BuildContext context) {
            return CupertinoButton(
              child: const Text('Show Picker'),
              onPressed: () {
                showCupertinoHeightPicker(
                  context: context,
                  onHeightChanged: (height) {
                    callbackHeight = height;
                  },
                );
              },
            );
          },
        ),
      ),
    );

    // Tap the button to show the picker
    await tester.tap(find.text('Show Picker'));
    await tester.pumpAndSettle();

    //Drag feet to a different value
    await tester.drag(find.text('4').first, const Offset(0, -50));
    await tester.pumpAndSettle();

    // Drag inches to a different value
    await tester.drag(find.text('11').first, const Offset(0, 100));
    await tester.pumpAndSettle();

    // Verify that the value is 5 feet and 8 inches
    expect(find.text('5'), findsNWidgets(2));
    expect(find.text('feet'), findsOneWidget);
    expect(find.text('8'), findsNWidgets(2));

    // Convert Unit
    await tester.drag(find.text('inches'), const Offset(0, -500));
    await tester.pumpAndSettle();

    // Verify that the value has been converted automatically
    expect(callbackHeight, targetHeight);
    expect(find.text('172'), findsOneWidget);
    expect(find.text('.'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('cm'), findsOneWidget);
  });

  testWidgets(
      'showCupertinoHeightPicker does not allow conversion when canConvertUnit is false',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (BuildContext context) {
            return CupertinoButton(
              child: const Text('Show Picker'),
              onPressed: () {
                showCupertinoHeightPicker(
                  context: context,
                  canConvertUnit: false,
                  onHeightChanged: (height) {},
                );
              },
            );
          },
        ),
      ),
    );

    // Tap the button to show the picker
    await tester.tap(find.text('Show Picker'));
    await tester.pumpAndSettle();

    // Simulate Dragging
    await tester.drag(find.text('inches'), const Offset(0, -500));
    await tester.pumpAndSettle();

    // Verify that the unit has not being changed
    expect(find.text('cm'), findsNothing);
    expect(find.text('inches'), findsOneWidget);
  });

  group('showCupertinoHeightPicker sets showSeparationText correctly', () {
    testWidgets('when it is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (BuildContext context) {
              return CupertinoButton(
                child: const Text('Show Picker'),
                onPressed: () {
                  showCupertinoHeightPicker(
                    context: context,
                    showSeparationText: false,
                    onHeightChanged: (height) {},
                  );
                },
              );
            },
          ),
        ),
      );

      // Tap the button to show the picker
      await tester.tap(find.text('Show Picker'));
      await tester.pumpAndSettle();

      // Verify that the separation text is not shown
      expect(find.text('feet'), findsNothing);
    });

    testWidgets('when it is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (BuildContext context) {
              return CupertinoButton(
                child: const Text('Show Picker'),
                onPressed: () {
                  showCupertinoHeightPicker(
                    context: context,
                    showSeparationText: true,
                    onHeightChanged: (height) {},
                  );
                },
              );
            },
          ),
        ),
      );

      // Tap the button to show the picker
      await tester.tap(find.text('Show Picker'));
      await tester.pumpAndSettle();

      // Verify that the separation text is shown
      expect(find.text('feet'), findsOneWidget);
    });
  });

  testWidgets('showCupertinoHeightPicker respects modalHeight parameter',
      (WidgetTester tester) async {
    final modalKey = GlobalKey<State<HeightPicker>>();
    double modalHeight = 300.0;

    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (BuildContext context) {
            return CupertinoButton(
              child: const Text('Show Picker'),
              onPressed: () {
                showCupertinoHeightPicker(
                  key: modalKey,
                  context: context,
                  modalHeight: modalHeight,
                  onHeightChanged: (height) {},
                );
              },
            );
          },
        ),
      ),
    );

    // Tap the button to show the picker
    await tester.tap(find.text('Show Picker'));
    await tester.pumpAndSettle();

    // Verify the modal height is set correctly
    expect(modalKey.currentState!.context.size!.height, modalHeight);
  });

  testWidgets('showCupertinoHeightPicker respects maxModalWidth parameter',
      (WidgetTester tester) async {
    final modalKey = GlobalKey<State<HeightPicker>>();
    double maxModalWidth = 250.0;

    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (BuildContext context) {
            return CupertinoButton(
              child: const Text('Show Picker'),
              onPressed: () {
                showCupertinoHeightPicker(
                  key: modalKey,
                  context: context,
                  maxModalWidth: maxModalWidth,
                  onHeightChanged: (height) {},
                );
              },
            );
          },
        ),
      ),
    );

    // Tap the button to show the picker
    await tester.tap(find.text('Show Picker'));
    await tester.pumpAndSettle();

    // Verify that the maximum modal width is set correctly
    expect(modalKey.currentState!.context.size!.width, maxModalWidth);
  });

  testWidgets(
      'showCupertinoHeightPicker respects modalBackgroundColor parameter',
      (WidgetTester tester) async {
    Color modalBackgroundColor = CupertinoColors.systemTeal;

    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (BuildContext context) {
            return CupertinoButton(
              child: const Text('Show Picker'),
              onPressed: () {
                showCupertinoHeightPicker(
                  context: context,
                  modalBackgroundColor: modalBackgroundColor,
                  onHeightChanged: (height) {},
                );
              },
            );
          },
        ),
      ),
    );

    // Tap the button to show the picker
    await tester.tap(find.text('Show Picker'));
    await tester.pumpAndSettle();

    // Verify that the modal background color is set correctly
    expect(
        ((tester.widgetList(find.byType(ColoredBox)).last) as ColoredBox).color,
        modalBackgroundColor);
  });

  testWidgets('showCupertinoHeightPicker respects barrierColor parameter',
      (WidgetTester tester) async {
    Color barrierColor = CupertinoColors.black.withOpacity(0.6);

    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (BuildContext context) {
            return CupertinoButton(
              child: const Text('Show Picker'),
              onPressed: () {
                showCupertinoHeightPicker(
                  context: context,
                  barrierColor: barrierColor,
                  onHeightChanged: (height) {},
                );
              },
            );
          },
        ),
      ),
    );

    // Tap the button to show the picker
    await tester.tap(find.text('Show Picker'));
    await tester.pumpAndSettle();

    // Verify that the barrier color is set correctly
    expect(
        ((tester.widgetList(find.byType(ColoredBox)).toList()[1]) as ColoredBox)
            .color,
        barrierColor);
  });
}
