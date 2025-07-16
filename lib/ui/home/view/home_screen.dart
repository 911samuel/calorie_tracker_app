import 'package:calorie_tracker_app/ui/home/widget/date_picker_header.dart';
import 'package:flutter/material.dart';
import 'package:calorie_tracker_app/core/theme/app_theme.dart';
import 'package:calorie_tracker_app/core/ui/nutrition_card.dart';
import 'package:calorie_tracker_app/core/ui/nutrition_progress.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();

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
        imagePath: 'assets/images/apple_juice.png',
      ),
      FoodItem(
        name: 'Cornflake Chocolate Chip',
        weight: '120g',
        calories: 522,
        carbs: 78,
        protein: 8,
        fat: 18,
        imagePath: 'assets/images/cornflake.png',
      ),
    ];

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
                      totalGoal: 2203,
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
            icon: Icons.wb_sunny,
            nutritionData: NutritionData(
              calories: 637,
              carbs: 106,
              protein: 8,
              fat: 21,
            ),
            foodItems: breakfastItems,
            onTap: () => debugPrint('Add breakfast tapped'),
          ),
          NutritionCard(
            type: NutritionCardType.mealSelector,
            title: 'Lunch',
            icon: Icons.lunch_dining,
            nutritionData: NutritionData(
              calories: 0,
              carbs: 0,
              protein: 0,
              fat: 0,
            ),
            foodItems: [],
            onTap: () => debugPrint('Add lunch tapped'),
          ),
          NutritionCard(
            type: NutritionCardType.mealSelector,
            title: 'Dinner',
            icon: Icons.dinner_dining,
            nutritionData: NutritionData(
              calories: 0,
              carbs: 0,
              protein: 0,
              fat: 0,
            ),
            foodItems: [],
            onTap: () => debugPrint('Add dinner tapped'),
          ),
          NutritionCard(
            type: NutritionCardType.mealSelector,
            title: 'Snacks',
            icon: Icons.cookie,
            nutritionData: NutritionData(
              calories: 0,
              carbs: 0,
              protein: 0,
              fat: 0,
            ),
            foodItems: [],
            onTap: () => debugPrint('Add snacks tapped'),
          ),
        ],
      ),
    );
  }
}
