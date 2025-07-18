import 'package:calorie_tracker_app/core/ui/custom_text.dart';
import 'package:calorie_tracker_app/domain/models/enums/nutrition_card_types.dart';
import 'package:calorie_tracker_app/domain/models/nutrition_data.dart';
import 'package:calorie_tracker_app/ui/calorie_tracking_screen/calorie_tracking_provider.dart';
import 'package:calorie_tracker_app/ui/food_search/provider/food_search_provider.dart';
import 'package:calorie_tracker_app/ui/food_search/widget/food_search_search_bar.dart';
import 'package:calorie_tracker_app/ui/home/widget/nutrition_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  final String mealType;
  final DateTime selectedDate;

  const FoodSearchScreen({
    super.key,
    required this.mealType,
    required this.selectedDate,
  });

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  @override
  void initState() {
    super.initState();
    // Set the selected meal type and date in the calorie tracking provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(calorieTrackingProvider).setSelectedMealType(widget.mealType);
      ref.read(calorieTrackingProvider).setSelectedDate(widget.selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final foodSearchViewModel = ref.watch(foodSearchProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText(
          label: 'Add to ${widget.mealType}',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          FoodSearchSearchBar(
            onSubmitted: (query) => foodSearchViewModel.searchFoods(query),
          ),
          Expanded(child: _buildBody(foodSearchViewModel, context)),
        ],
      ),
    );
  }

  Widget _buildBody(foodSearchViewModel, BuildContext context) {
    if (foodSearchViewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    if (foodSearchViewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${foodSearchViewModel.errorMessage}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: foodSearchViewModel.clearResults,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (foodSearchViewModel.foods.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Search for foods to add to your meal',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: foodSearchViewModel.foods.length,
      itemBuilder: (context, index) {
        final food = foodSearchViewModel.foods[index];
        return _buildFoodCard(food, context);
      },
    );
  }

  Widget _buildFoodCard(dynamic food, BuildContext context) {
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
        onInputSubmitted: (amount) => _addFoodToMeal(food, amount),
        onSave: () {
          // This will be called when the user confirms the amount
        },
      ),
    );
  }

  bool _isAdding = false; // Add this at the top of _FoodSearchScreenState

  void _addFoodToMeal(dynamic food, String amountStr) async {
    final amount = double.tryParse(amountStr);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (_isAdding) return; // Prevent multiple taps
    _isAdding = true;

    try {
      ref.read(calorieTrackingProvider).setSelectedMealType(widget.mealType);
      await ref.read(calorieTrackingProvider).addFoodToMeal(food, amount);

      if (mounted) {
        // ✅ Return to HomeScreen with result = true
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding food: $e')));
      }
    } finally {
      _isAdding = false;
    }
  }
}
