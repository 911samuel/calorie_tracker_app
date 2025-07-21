import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/ui/nutrition_ring.dart';

void main() {
  testWidgets('NutritionRing renders progress and texts', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NutritionRing(
            value: 50,
            goal: 100,
            label: 'Carbs',
            color: Colors.red,
            backgroundColor: Colors.grey,
          ),
        ),
      ),
    );

    expect(find.text('50 g'), findsOneWidget);
    expect(find.text('Carbs'), findsOneWidget);
    expect(find.byType(NutritionRing), findsOneWidget);
  });
}
