import 'package:calorie_tracker_app/ui/food_search/view_model/calorie_tracking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/data/services/shared_prefs_service.dart';
import 'package:calorie_tracker_app/domain/use_cases/calculate_nutrients_usecase.dart';
import 'package:calorie_tracker_app/domain/models/food_item.dart';
import 'package:calorie_tracker_app/domain/models/nutrition_data.dart';

class HomeViewModel extends ChangeNotifier {
  final Ref ref;
  DateTime selectedDate = DateTime.now();
  NutrientGoalResult? nutrientGoalResult;
  bool isLoading = false;

  HomeViewModel(this.ref) {
    _loadUserData();
    ref.read(calorieTrackingProvider).setSelectedDate(selectedDate);
  }

  Future<void> _loadUserData() async {
    isLoading = true;
    notifyListeners();
    final sharedPrefsService = SharedPrefsService();
    final calculateMealNutrients = CalculateMealNutrients(sharedPrefsService);
    final result = await calculateMealNutrients();
    nutrientGoalResult = result;
    isLoading = false;
    notifyListeners();
  }

  void incrementDate() {
    selectedDate = selectedDate.add(const Duration(days: 1));
    ref.read(calorieTrackingProvider).setSelectedDate(selectedDate);
    notifyListeners();
  }

  void decrementDate() {
    selectedDate = selectedDate.subtract(const Duration(days: 1));
    ref.read(calorieTrackingProvider).setSelectedDate(selectedDate);
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      ref.read(calorieTrackingProvider).setSelectedDate(picked);
      notifyListeners();
    }
  }

  Future<void> addFood(BuildContext context, String mealType) async {
    final result = await Navigator.pushNamed(
      context,
      '/food-search',
      arguments: {'mealType': mealType, 'selectedDate': selectedDate},
    );
    if (result == true) {
      ref.read(calorieTrackingProvider).loadDailySummary();
      notifyListeners();
    }
  }

  void removeFoodFromMeal(int trackedFoodId) {
    ref.read(calorieTrackingProvider).removeFoodFromMeal(trackedFoodId);
    notifyListeners();
  }

  // Nutrition calculation helpers
  Map<String, double> calculateTotals(dynamic dailySummary) {
    double totalCalories = 0;
    double totalCarbs = 0;
    double totalProtein = 0;
    double totalFat = 0;
    if (dailySummary != null) {
      for (final meal in dailySummary.meals) {
        totalCalories += meal.totalCalories;
        totalCarbs += meal.totalCarbs;
        totalProtein += meal.totalProtein;
        totalFat += meal.totalFat;
      }
    }
    return {
      'calories': totalCalories,
      'carbs': totalCarbs,
      'protein': totalProtein,
      'fat': totalFat,
    };
  }

  List<Map<String, dynamic>> buildMealData(dynamic dailySummary) {
    final mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
    final mealImages = {
      'Breakfast': 'assets/images/breakfast.jpg',
      'Lunch': 'assets/images/lunch.jpg',
      'Dinner': 'assets/images/dinner.jpg',
      'Snacks': 'assets/images/snack.jpg',
    };
    return mealTypes.map((mealType) {
      final mealSummaryList = dailySummary?.meals
          .where(
            (meal) => meal.mealType.toLowerCase() == mealType.toLowerCase(),
          )
          .toList();
      final mealSummary = mealSummaryList != null && mealSummaryList.isNotEmpty
          ? mealSummaryList.first
          : null;
      final List<FoodItem>? foodItems = mealSummary?.foods.isNotEmpty == true
          ? mealSummary!.foods
                .map<FoodItem>(
                  (trackedFood) => FoodItem(
                    name: trackedFood.name,
                    weight: '${trackedFood.amount.toInt()}g',
                    calories: trackedFood.calories,
                    carbs: trackedFood.carbs,
                    protein: trackedFood.protein,
                    fat: trackedFood.fat,
                    imagePath: trackedFood.imageUrl,
                  ),
                )
                .toList()
          : null;
      return {
        'mealType': mealType,
        'imagePath': mealImages[mealType],
        'nutritionData': NutritionData(
          calories: mealSummary?.totalCalories.toInt() ?? 0,
          carbs: mealSummary?.totalCarbs ?? 0,
          protein: mealSummary?.totalProtein ?? 0,
          fat: mealSummary?.totalFat ?? 0,
        ),
        'foodItems': foodItems,
        'mealSummary': mealSummary,
      };
    }).toList();
  }
}

final homeViewModelProvider = ChangeNotifierProvider(
  (ref) => HomeViewModel(ref),
);
