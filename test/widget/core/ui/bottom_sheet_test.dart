import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/ui/bottom_sheet.dart';

void main() {
  testWidgets('CustomBottomSheet shows and dismisses', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    CustomBottomSheet.show(
                      context: context,
                      child: const Text('Bottom Sheet Content'),
                    );
                  },
                  child: const Text('Show Bottom Sheet'),
                ),
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('Show Bottom Sheet'), findsOneWidget);
    expect(find.text('Bottom Sheet Content'), findsNothing);

    await tester.tap(find.text('Show Bottom Sheet'));
    await tester.pumpAndSettle();

    expect(find.text('Bottom Sheet Content'), findsOneWidget);

    // Dismiss bottom sheet by tapping outside
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.text('Bottom Sheet Content'), findsNothing);
  });
}
