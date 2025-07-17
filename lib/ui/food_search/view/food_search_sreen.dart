import 'package:calorie_tracker_app/core/ui/custom_text.dart';
import 'package:calorie_tracker_app/core/ui/nutrition_card.dart';
import 'package:calorie_tracker_app/ui/food_search/view_model/food_search_view_model.dart';
import 'package:calorie_tracker_app/ui/food_search/widget/food_search_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodSearchSreen extends StatelessWidget {
  final String title;

  const FoodSearchSreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FoodSearchViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: CustomText(
            label: title, // Use the title parameter here
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Consumer<FoodSearchViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                FoodSearchSearchBar(
                  onSubmitted: (query) => viewModel.searchFoods(query),
                ),
                Expanded(child: _buildBody(viewModel, context)),
              ],
            );
          },
        ),
      ),
    );
  }
}

  Widget _buildBody(FoodSearchViewModel viewModel, BuildContext context) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${viewModel.errorMessage}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: viewModel.clearResults,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (viewModel.foods.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Search for foods to see results',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: viewModel.foods.length,
      itemBuilder: (context, index) {
        final food = viewModel.foods[index];
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
          carbs: food.carbs,
          protein: food.protein,
          fat: food.fat,
          weight: food.weight,
        ),
      ),
    );
  }
