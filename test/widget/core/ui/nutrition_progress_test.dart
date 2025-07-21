import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/ui/nutrition_progress.dart';

void main() {
  testWidgets('NutritionRingProgress displays calorie texts and progress bars', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NutritionRingProgress(
            carbsValue: 50,
            proteinValue: 30,
            fatValue: 20,
            carbsGoal: 100,
            proteinGoal: 60,
            fatGoal: 40,
            totalCalories: 600,
            totalGoal: 1200,
          ),
        ),
      ),
    );

    expect(find.text('Your goal:'), findsOneWidget);
    expect(find.text('600 kcal'), findsOneWidget);
    expect(find.text('1200 kcal'), findsOneWidget);

    // Check presence of NutritionRingProgress widget
    expect(find.byType(NutritionRingProgress), findsOneWidget);
  });
}
