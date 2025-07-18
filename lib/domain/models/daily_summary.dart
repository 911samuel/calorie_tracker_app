import 'package:calorie_tracker_app/domain/models/meal_summary.dart';

class DailySummary {
  final DateTime date;
  final List<MealSummary> meals;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;

  DailySummary({
    required this.date,
    required this.meals,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
  });

  factory DailySummary.fromMeals(DateTime date, List<MealSummary> meals) {
    return DailySummary(
      date: date,
      meals: meals,
      totalCalories: meals.fold(0, (sum, meal) => sum + meal.totalCalories),
      totalProtein: meals.fold(0.0, (sum, meal) => sum + meal.totalProtein),
      totalCarbs: meals.fold(0.0, (sum, meal) => sum + meal.totalCarbs),
      totalFat: meals.fold(0.0, (sum, meal) => sum + meal.totalFat),
    );
  }
}
