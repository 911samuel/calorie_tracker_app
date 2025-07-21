import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/ui/onboarding_text_field.dart';

void main() {
  testWidgets('OnboardingTextField renders hintText and suffixText', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OnboardingTextField(
            hintText: 'Enter value',
            suffixText: 'kg',
          ),
        ),
      ),
    );

    expect(find.text('Enter value'), findsOneWidget);
    expect(find.text('kg'), findsOneWidget);
  });

  testWidgets('OnboardingTextField shows errorText', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OnboardingTextField(
            errorText: 'Error message',
          ),
        ),
      ),
    );

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('OnboardingTextField calls onChanged callback', (tester) async {
    String? changedValue;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OnboardingTextField(
            onChanged: (value) {
              changedValue = value;
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), '123');
    expect(changedValue, '123');
  });
}
