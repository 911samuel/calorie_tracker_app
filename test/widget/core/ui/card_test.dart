import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/ui/card.dart';

void main() {
  testWidgets('CustomCard renders child and responds to tap', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomCard(
            onTap: () {
              tapped = true;
            },
            child: const Text('Card Content'),
          ),
        ),
      ),
    );

    expect(find.text('Card Content'), findsOneWidget);
    await tester.tap(find.text('Card Content'));
    expect(tapped, isTrue);
  });

  testWidgets('CustomCard applies padding and margin', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomCard(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(10),
            child: const Text('Padded Card'),
          ),
        ),
      ),
    );

    expect(find.text('Padded Card'), findsOneWidget);
  });

  testWidgets('CustomCard applies glow effect', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomCard(
            hasGlow: true,
            child: const Text('Glowing Card'),
          ),
        ),
      ),
    );

    expect(find.text('Glowing Card'), findsOneWidget);
  });
}
