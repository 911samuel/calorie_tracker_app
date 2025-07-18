import 'package:calorie_tracker_app/domain/models/food.dart';
import 'package:calorie_tracker_app/ui/calorie_tracking_screen/view_model/calorie_tracking_view_model.dart';
import 'package:flutter/material.dart';

class FoodSearchDialog extends StatefulWidget {
  final CalorieTrackingViewModel viewModel;

  const FoodSearchDialog({super.key, required this.viewModel});

  @override
  State<FoodSearchDialog> createState() => _FoodSearchDialogState();
}

class _FoodSearchDialogState extends State<FoodSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Add Food to ${widget.viewModel.selectedMealType.toUpperCase()}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for food...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                widget.viewModel.searchFoods(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: widget.viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : widget.viewModel.searchResults.isEmpty
                  ? const Center(child: Text('No results found'))
                  : ListView.builder(
                      itemCount: widget.viewModel.searchResults.length,
                      itemBuilder: (context, index) {
                        final food = widget.viewModel.searchResults[index];
                        return _buildFoodSearchItem(food);
                      },
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodSearchItem(Food food) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: food.imageUrl != null
            ? Image.network(
                food.imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.fastfood),
              )
            : const Icon(Icons.fastfood),
        title: Text(food.name),
        subtitle: Text('${food.caloriesPer100g} cal per 100g'),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showAmountDialog(food),
        ),
      ),
    );
  }

  void _showAmountDialog(Food food) {
    _amountController.text = '100'; // Default to 100g
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${food.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (grams)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _buildNutritionPreview(food),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(_amountController.text);
              if (amount != null && amount > 0) {
                await widget.viewModel.addFoodToMeal(food, amount);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(); // Close amount dialog
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(); // Close search dialog
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionPreview(Food food) {
    final amount = double.tryParse(_amountController.text) ?? 100;
    final ratio = amount / 100;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Nutrition for ${amount.toStringAsFixed(0)}g',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNutrientPreview(
                'Calories',
                (food.caloriesPer100g * ratio).round().toString(),
                Colors.orange,
              ),
              _buildNutrientPreview(
                'Protein',
                '${(food.proteinPer100g * ratio).toStringAsFixed(1)}g',
                Colors.blue,
              ),
              _buildNutrientPreview(
                'Carbs',
                '${(food.carbsPer100g * ratio).toStringAsFixed(1)}g',
                Colors.green,
              ),
              _buildNutrientPreview(
                'Fat',
                '${(food.fatPer100g * ratio).toStringAsFixed(1)}g',
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientPreview(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
