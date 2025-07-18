import 'package:calorie_tracker_app/domain/models/enums/nutrition_card_types.dart';
import 'package:calorie_tracker_app/domain/models/nutrition_data.dart';
import 'package:calorie_tracker_app/ui/food_search/view_model/food_search_view_model.dart';
import 'package:calorie_tracker_app/ui/home/widget/nutrition_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodCard extends ConsumerWidget {
  final dynamic food;
  final String mealType;
  final DateTime selectedDate;

  const FoodCard({
    super.key,
    required this.food,
    required this.mealType,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodSearchViewModel = ref.read(foodSearchViewModelProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: NutritionCard(
        type: NutritionCardType.searchResult,
        title: food.name,
        imagePath: food.imageUrl,
        nutritionData: NutritionData(
          calories: food.caloriesPer100g,
          carbs: food.carbsPer100g,
          protein: food.proteinPer100g,
          fat: food.fatPer100g,
          weight: '100g',
        ),
        onInputSubmitted: (amount) =>
            _addFoodToMeal(context, foodSearchViewModel, food, amount, ref),
        onSave: () {},
      ),
    );
  }

  void _addFoodToMeal(
    BuildContext context,
    FoodSearchViewModel foodSearchViewModel,
    dynamic food,
    String amountStr,
    WidgetRef ref,
  ) async {
    final success = await foodSearchViewModel.addFoodToMeal(
      food: food,
      amountStr: amountStr,
      mealType: mealType,
      selectedDate: selectedDate,
      ref: ref,
    );
    if (context.mounted) {
      if (success) {
        Navigator.pop(context, true);
      } else if (foodSearchViewModel.addError != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(foodSearchViewModel.addError!)));
      }
    }
  }
}
