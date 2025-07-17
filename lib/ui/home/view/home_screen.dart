import 'package:calorie_tracker_app/data/services/shared_prefs_service.dart';
import 'package:calorie_tracker_app/domain/models/enums/nutrition_card_types.dart';
import 'package:calorie_tracker_app/domain/models/nutrition_data.dart';
import 'package:calorie_tracker_app/domain/models/user.dart';
import 'package:calorie_tracker_app/domain/use_cases/calculate_nutrients_usecase.dart';
import 'package:calorie_tracker_app/routes/routes.dart';
import 'package:calorie_tracker_app/ui/home/widget/date_picker_header.dart';
import 'package:calorie_tracker_app/ui/home/widget/nutrition_card.dart';
import 'package:flutter/material.dart';
import 'package:calorie_tracker_app/core/theme/app_theme.dart';
import 'package:calorie_tracker_app/core/ui/nutrition_progress.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  User? _user;
  NutrientGoalResult? _nutrientGoalResult;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final sharedPrefsService = SharedPrefsService();
    final user = await sharedPrefsService.loadUser();

    final calculateMealNutrients = CalculateMealNutrients(sharedPrefsService);
    final result = await calculateMealNutrients();

    setState(() {
      _user = user;
      _nutrientGoalResult = result;
    });

    if (result != null) {
      debugPrint('Calories Goal: ${result.caloriesGoal}');
      debugPrint('Carbs Goal: ${result.carbsGoal}');
      debugPrint('Protein Goal: ${result.proteinGoal}');
      debugPrint('Fat Goal: ${result.fatGoal}');
    }
  }

  void _incrementDate() {
    setState(() => selectedDate = selectedDate.add(const Duration(days: 1)));
  }

  void _decrementDate() {
    setState(
      () => selectedDate = selectedDate.subtract(const Duration(days: 1)),
    );
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
    }
  }

  void _addFood(String mealType) {
    Navigator.pushNamed(
      context,
      AppRoutes.foodSearch,
      arguments: {'mealType': mealType},
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    // Single combined nutrition progress
                    NutritionRingProgress(
                      carbsValue: 117,
                      carbsGoal: 150,
                      proteinValue: 78,
                      proteinGoal: 120,
                      fatValue: 84,
                      fatGoal: 100,
                      totalCalories: 1512,
                      totalGoal: (_nutrientGoalResult?.caloriesGoal ?? 0)
                          .toDouble(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      body: ListView(
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
          NutritionCard(
            type: NutritionCardType.mealSelector,
            title: 'Breakfast',
            imagePath: 'assets/images/breakfast.jpg',
            nutritionData: NutritionData(
              calories: 637,
              carbs: 106,
              protein: 8,
              fat: 21,
              weight: '400g',
            ),
            foodItems: [],
            onTap: () => _addFood('Breakfast'),
          ),
          NutritionCard(
            type: NutritionCardType.mealSelector,
            title: 'Lunch',
            imagePath: 'assets/images/lunch.jpg',
            nutritionData: NutritionData(
              calories: 0,
              carbs: 0,
              protein: 0,
              fat: 0,
            ),
            foodItems: [],
            onTap: () => _addFood('Lunch'),
          ),
          NutritionCard(
            type: NutritionCardType.mealSelector,
            title: 'Dinner',
            imagePath: 'assets/images/dinner.jpg',
            nutritionData: NutritionData(
              calories: 0,
              carbs: 0,
              protein: 0,
              fat: 0,
            ),
            foodItems: [],
            onTap: () => _addFood('Dinner'),
          ),
          NutritionCard(
            type: NutritionCardType.mealSelector,
            title: 'Snacks',
            imagePath: 'assets/images/snack.jpg',
            nutritionData: NutritionData(
              calories: 0,
              carbs: 0,
              protein: 0,
              fat: 0,
            ),
            foodItems: [],
            onTap: () => _addFood('Snacks'),
          ),
        ],
      ),
    );
  }
}
