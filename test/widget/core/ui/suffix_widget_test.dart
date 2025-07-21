import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/ui/suffix_widget.dart';

void main() {
  testWidgets('SuffixWidget renders suffixIcon and responds to tap', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SuffixWidget(
            suffixIcon: Icons.clear,
            onSuffixTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.clear), findsOneWidget);
    await tester.tap(find.byIcon(Icons.clear));
    expect(tapped, isTrue);
  });

  testWidgets('SuffixWidget renders suffixText', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SuffixWidget(
            suffixText: 'Suffix',
          ),
        ),
      ),
    );

    expect(find.text('Suffix'), findsOneWidget);
  });

  testWidgets('SuffixWidget renders nothing when no icon or text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SuffixWidget(),
        ),
      ),
    );

    expect(find.byType(SizedBox), findsOneWidget);
  });
}
