import 'package:calorie_tracker_app/ui/food_search/view_model/calorie_tracking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/ui/home/view_model/home_viewmodel.dart';
import 'package:calorie_tracker_app/ui/home/widget/date_picker_header.dart';
import 'package:calorie_tracker_app/ui/home/widget/nutrition_card.dart';
import 'package:calorie_tracker_app/core/theme/app_theme.dart';
import 'package:calorie_tracker_app/core/ui/nutrition_progress.dart';
import 'package:calorie_tracker_app/domain/models/enums/nutrition_card_types.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final homeViewModel = ref.watch(homeViewModelProvider);
    final dailySummary = ref.watch(calorieTrackingProvider).dailySummary;
    final totals = homeViewModel.calculateTotals(dailySummary);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 280,
        automaticallyImplyLeading: false,
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          child: Container(
            color: AppTheme.lightTheme.primaryColor,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NutritionRingProgress(
                      carbsValue: totals['carbs'] ?? 0,
                      carbsGoal: (homeViewModel.nutrientGoalResult?.carbsGoal ?? 150).toDouble(),
                      proteinValue: totals['protein'] ?? 0,
                      proteinGoal: (homeViewModel.nutrientGoalResult?.proteinGoal ?? 120).toDouble(),
                      fatValue: totals['fat'] ?? 0,
                      fatGoal: (homeViewModel.nutrientGoalResult?.fatGoal ?? 100).toDouble(),
                      totalCalories: totals['calories'] ?? 0,
                      totalGoal: (homeViewModel.nutrientGoalResult?.caloriesGoal ?? 2000).toDouble(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: homeViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DatePickerHeader(
                    selectedDate: homeViewModel.selectedDate,
                    onPrevious: homeViewModel.decrementDate,
                    onNext: homeViewModel.incrementDate,
                    onSelectDate: () => homeViewModel.selectDate(context),
                  ),
                ),
                ...homeViewModel.buildMealData(dailySummary).map((meal) => NutritionCard(
                  type: NutritionCardType.mealSelector,
                  title: meal['mealType'],
                  imagePath: meal['imagePath'],
                  nutritionData: meal['nutritionData'],
                  foodItems: meal['foodItems'],
                  onTap: () => homeViewModel.addFood(context, meal['mealType']),
                  onFoodItemRemoved: (foodItem) {
                    final mealSummary = meal['mealSummary'];
                    final matchingFoods = mealSummary?.foods?.where((tf) => tf.name == foodItem.name).toList();
                    final trackedFood = matchingFoods != null && matchingFoods.isNotEmpty ? matchingFoods.first : null;
                    if (trackedFood != null && trackedFood.id != null) {
                      homeViewModel.removeFoodFromMeal(trackedFood.id!);
                    }
                  },
                )),
              ],
            ),
    );
  }

}
