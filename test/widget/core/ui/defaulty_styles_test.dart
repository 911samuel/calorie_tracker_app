import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/ui/defaulty_styles.dart';
import 'package:calorie_tracker_app/core/ui/text_field.dart';  // Import for ValidationState

void main() {
  testWidgets('DefaultyStyles renders child widget', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DefaultyStyles(
            validator: (_) => null,
            obscureText: false,
            keyboardType: TextInputType.text,
            prefixIcon: Icons.add,
            suffixIcon: Icons.clear,
            onSuffixTap: () {},
            validationState: ValidationState.none,
            errorText: null,
            enabled: true,
            suffixText: 'Suffix',
            suffixTextColor: Colors.black,
            onChanged: (_) {},
            controller: TextEditingController(),
          ),
        ),
      ),
    );

    expect(find.byType(DefaultyStyles), findsOneWidget);
  });
}
