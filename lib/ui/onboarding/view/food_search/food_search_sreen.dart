import 'package:calorie_tracker_app/ui/onboarding/view/food_search/view_model/food_search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Don't pass any parameters - let the ViewModel use GetIt
      create: (_) => FoodSearchViewModel(),
      child: Scaffold(
        appBar: AppBar(title: Text('Food Search')),
        body: Consumer<FoodSearchViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onSubmitted: (query) => viewModel.searchFoods(query),
                    decoration: InputDecoration(
                      hintText: 'Search for foods...',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(child: _buildBody(viewModel)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(FoodSearchViewModel viewModel) {
    if (viewModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Error: ${viewModel.errorMessage}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.clearResults(),
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (viewModel.foods.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Search for foods to see results'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.foods.length,
      itemBuilder: (context, index) {
        final food = viewModel.foods[index];
        return ListTile(
          leading: food.imageUrl != null
              ? Image.network(
                  food.imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.fastfood);
                  },
                )
              : Icon(Icons.fastfood),
          title: Text(food.name),
          subtitle: Text('${food.caloriesPer100g} kcal/100g'),
          trailing: Text(
            'P: ${food.proteinPer100g.toStringAsFixed(1)}g\n'
            'C: ${food.carbsPer100g.toStringAsFixed(1)}g\n'
            'F: ${food.fatPer100g.toStringAsFixed(1)}g',
            style: TextStyle(fontSize: 10),
          ),
          onTap: () {
            // Handle food selection
            print('Selected food: ${food.name}');
          },
        );
      },
    );
  }
}
