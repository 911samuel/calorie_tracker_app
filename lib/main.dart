import 'package:calorie_tracker_app/core/ui/button.dart';
import 'package:calorie_tracker_app/core/ui/nutrition_card.dart';
import 'package:calorie_tracker_app/core/ui/nutrition_progress.dart';

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

void main() {
  runApp(const ProviderScope(child: CalorieTrackerApp()));
}

class CalorieTrackerApp extends StatelessWidget {
  const CalorieTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    List<FoodItem> breakfastItems = [
      FoodItem(
        name: 'Apple Juice',
        weight: '250g',
        calories: 115,
        carbs: 28,
        protein: 0,
        fat: 3,
        imagePath: 'assets/apple_juice.png',
      ),
      FoodItem(
        name: 'Cornflake Chocolate Chip',
        weight: '120g',
        calories: 522,
        carbs: 78,
        protein: 8,
        fat: 18,
        imagePath: 'assets/cornflake.png',
      ),
    ];
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: ListView(
          children: [
            NutritionCard(
              type: NutritionCardType.mealSelector,
              title: 'Breakfast',
              icon: Icons.wb_sunny,
              nutritionData: NutritionData(
                calories: 637,
                carbs: 106,
                protein: 8,
                fat: 21,
              ),
              foodItems: breakfastItems,
              onTap: () {
                // Handle add breakfast
                print('Add breakfast tapped');
              },
              // onFoodItemRemoved: () {},
            ),
            NutritionCard(
              type: NutritionCardType.mealSelector,
              title: 'Breakfast',
              icon: Icons.wb_sunny,
              nutritionData: NutritionData(
                calories: 637,
                carbs: 106,
                protein: 8,
                fat: 21,
              ),
              foodItems: breakfastItems,
              onTap: () {
                // Handle add breakfast
                print('Add breakfast tapped');
              },
              // onFoodItemRemoved: () {},
            ),

            // Input Field Card
            NutritionCard(
              type: NutritionCardType.inputField,
              title: 'Instant noodle',
              nutritionInfo: '230kcal / 100g',
              nutritionData: NutritionData(
                calories: 230,
                carbs: 28,
                protein: 5,
                fat: 10,
              ),
              inputHint: '0',
              inputSuffix: 'g',
              onInputChanged: (value) {
                print('Input changed: $value');
              },
              onInputSubmitted: (value) {
                print('Input submitted: $value');
              },
            ),
            NutritionRingProgress(
              carbsValue: 117,
              proteinValue: 78,
              fatValue: 84,
              carbsGoal: 150,
              proteinGoal: 120,
              fatGoal: 100,
              totalCalories: 1512, // Current consumed
              totalGoal: 2203, // Daily goal
            ),

            // Or let it auto-calculate from macros
            NutritionRingProgress(
              carbsValue: 117,
              proteinValue: 78,
              fatValue: 84,
              carbsGoal: 150,
              proteinGoal: 120,
              fatGoal: 100,
              // Will calculate: (117*4 + 78*4 + 84*9) = 1536 calories
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
