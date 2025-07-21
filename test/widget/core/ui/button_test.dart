import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/ui/button.dart';

void main() {
  testWidgets('CustomButton renders text and calls onPressed', (tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Press Me',
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Press Me'), findsOneWidget);
    await tester.tap(find.text('Press Me'));
    expect(pressed, isTrue);
  });

  testWidgets('CustomButton shows loading indicator when isLoading is true', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Loading',
            isLoading: true,
            onPressed: () {
              // Should not be called
            },
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading'), findsNothing);
  });

  testWidgets('CustomButton renders icon when provided', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'With Icon',
            icon: Icons.add,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('CustomButton renders different variants and selection state', (tester) async {
    for (var variant in ButtonVariant.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Variant Test',
              variant: variant,
              isSelected: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Variant Test'), findsOneWidget);
    }
  });
}
