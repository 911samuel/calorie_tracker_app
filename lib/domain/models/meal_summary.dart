import 'package:calorie_tracker_app/domain/models/tracked_food.dart';

class MealSummary {
  final String mealType;
  final List<TrackedFood> foods;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;

  MealSummary({
    required this.mealType,
    required this.foods,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
  });

  factory MealSummary.fromFoods(String mealType, List<TrackedFood> foods) {
    return MealSummary(
      mealType: mealType,
      foods: foods,
      totalCalories: foods.fold(0, (sum, food) => sum + food.calories),
      totalProtein: foods.fold(0.0, (sum, food) => sum + food.protein),
      totalCarbs: foods.fold(0.0, (sum, food) => sum + food.carbs),
      totalFat: foods.fold(0.0, (sum, food) => sum + food.fat),
    );
  }
}
