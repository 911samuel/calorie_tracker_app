import 'package:calorie_tracker_app/ui/food_search/view_model/food_search_view_model.dart';
import 'package:calorie_tracker_app/ui/food_search/widget/food_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodSearchBody extends ConsumerWidget {
  final String mealType;
  final DateTime selectedDate;

  const FoodSearchBody({
    super.key,
    required this.mealType,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodSearchViewModel = ref.watch(foodSearchViewModelProvider);

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
        return FoodCard(
          food: food,
          mealType: mealType,
          selectedDate: selectedDate,
        );
      },
    );
  }
}
