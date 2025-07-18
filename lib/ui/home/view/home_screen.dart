import 'package:calorie_tracker_app/data/services/shared_prefs_service.dart';
import 'package:calorie_tracker_app/domain/models/enums/nutrition_card_types.dart';
import 'package:calorie_tracker_app/domain/models/nutrition_data.dart';
import 'package:calorie_tracker_app/domain/use_cases/calculate_nutrients_usecase.dart';
import 'package:calorie_tracker_app/routes/routes.dart';
import 'package:calorie_tracker_app/ui/calorie_tracking_screen/calorie_tracking_provider.dart';
import 'package:calorie_tracker_app/ui/home/widget/date_picker_header.dart';
import 'package:calorie_tracker_app/ui/home/widget/nutrition_card.dart';
import 'package:flutter/material.dart';
import 'package:calorie_tracker_app/core/theme/app_theme.dart';
import 'package:calorie_tracker_app/core/ui/nutrition_progress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/domain/models/food_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  NutrientGoalResult? _nutrientGoalResult;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Load daily summary for the selected date
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(calorieTrackingProvider).setSelectedDate(selectedDate);
    });
  }

  Future<void> _loadUserData() async {
    final sharedPrefsService = SharedPrefsService();
    final calculateMealNutrients = CalculateMealNutrients(sharedPrefsService);
    final result = await calculateMealNutrients();
    if (mounted) {
      setState(() {
        _nutrientGoalResult = result;
      });
    }
  }

  void _incrementDate() {
    final newDate = selectedDate.add(const Duration(days: 1));
    setState(() => selectedDate = newDate);
    ref.read(calorieTrackingProvider).setSelectedDate(newDate);
  }

  void _decrementDate() {
    final newDate = selectedDate.subtract(const Duration(days: 1));
    setState(() => selectedDate = newDate);
    ref.read(calorieTrackingProvider).setSelectedDate(newDate);
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      ref.read(calorieTrackingProvider).setSelectedDate(picked);
    }
  }

  void _addFood(String mealType) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.foodSearch,
      arguments: {'mealType': mealType, 'selectedDate': selectedDate},
    );

    if (result == true) {
      // ✅ Refresh meals if one was added
      ref.read(calorieTrackingProvider).loadDailySummary();
    }
  }

  void _removeFoodFromMeal(int trackedFoodId) {
    ref.read(calorieTrackingProvider).removeFoodFromMeal(trackedFoodId);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(calorieTrackingProvider);
    final dailySummary = viewModel.dailySummary;
    // Calculate total nutrition from daily summary
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
                      carbsValue: totalCarbs,
                      carbsGoal: (_nutrientGoalResult?.carbsGoal ?? 150)
                          .toDouble(),
                      proteinValue: totalProtein,
                      proteinGoal: (_nutrientGoalResult?.proteinGoal ?? 120)
                          .toDouble(),
                      fatValue: totalFat,
                      fatGoal: (_nutrientGoalResult?.fatGoal ?? 100).toDouble(),
                      totalCalories: totalCalories,
                      totalGoal: (_nutrientGoalResult?.caloriesGoal ?? 2000)
                          .toDouble(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DatePickerHeader(
                    selectedDate: selectedDate,
                    onPrevious: _decrementDate,
                    onNext: _incrementDate,
                    onSelectDate: _selectDate,
                  ),
                ),
                ..._buildMealCards(dailySummary),
              ],
            ),
    );
  }

  List<Widget> _buildMealCards(dailySummary) {
    final mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
    final mealImages = {
      'Breakfast': 'assets/images/breakfast.jpg',
      'Lunch': 'assets/images/lunch.jpg',
      'Dinner': 'assets/images/dinner.jpg',
      'Snacks': 'assets/images/snack.jpg',
    };

    return mealTypes.map((mealType) {
      // Find the meal summary for this meal type
      final mealSummaryList = dailySummary?.meals
          .where(
            (meal) => meal.mealType.toLowerCase() == mealType.toLowerCase(),
          )
          .toList();

      final mealSummary = mealSummaryList != null && mealSummaryList.isNotEmpty
          ? mealSummaryList.first
          : null;

      // Convert tracked foods to food items for display
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

      return NutritionCard(
        type: NutritionCardType.mealSelector,
        title: mealType,
        imagePath: mealImages[mealType],
        nutritionData: NutritionData(
          calories: mealSummary?.totalCalories.toInt() ?? 0,
          carbs: mealSummary?.totalCarbs ?? 0,
          protein: mealSummary?.totalProtein ?? 0,
          fat: mealSummary?.totalFat ?? 0,
        ),
        foodItems: foodItems,
        onTap: () => _addFood(mealType),
        onFoodItemRemoved: (foodItem) {
          // Find the tracked food ID and remove it
          final matchingFoods = mealSummary?.foods
              .where((tf) => tf.name == foodItem.name)
              .toList();

          final trackedFood = matchingFoods != null && matchingFoods.isNotEmpty
              ? matchingFoods.first
              : null;

          if (trackedFood != null && trackedFood.id != null) {
            _removeFoodFromMeal(trackedFood.id!);
          }
        },
      );
    }).toList();
  }
}
