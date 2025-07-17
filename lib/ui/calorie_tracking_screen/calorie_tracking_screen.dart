import 'package:calorie_tracker_app/ui/calorie_tracking_screen/calorie_tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:calorie_tracker_app/ui/calorie_tracking_screen/view_model/calorie_tracking_view_model.dart';
import 'package:calorie_tracker_app/ui/calorie_tracking_screen/widgets/food_search_dialog.dart';
import 'package:calorie_tracker_app/ui/calorie_tracking_screen/widgets/meal_type_selector.dart';
import 'package:calorie_tracker_app/ui/calorie_tracking_screen/widgets/nutrition_progress_widget.dart';
import 'package:calorie_tracker_app/domain/models/meal_summary.dart';
import 'package:calorie_tracker_app/domain/models/meal_type.dart';
import 'package:calorie_tracker_app/domain/models/tracked_food.dart';

class EnhancedCalorieTrackingScreen extends ConsumerStatefulWidget {
  const EnhancedCalorieTrackingScreen({super.key});

  @override
  ConsumerState<EnhancedCalorieTrackingScreen> createState() =>
      _EnhancedCalorieTrackingScreenState();
}

class _EnhancedCalorieTrackingScreenState
    extends ConsumerState<EnhancedCalorieTrackingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(calorieTrackingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Tracker'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Daily View', icon: Icon(Icons.today)),
            Tab(text: 'Progress', icon: Icon(Icons.trending_up)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildDailyView(viewModel), _buildProgressView(viewModel)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFoodSearchDialog(context, viewModel),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDailyView(CalorieTrackingViewModel viewModel) {
    if (viewModel.isLoading && viewModel.dailySummary == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        _buildDateSelector(viewModel),
        _buildSummaryCard(viewModel),
        MealTypeSelector(
          selectedMealType: viewModel.selectedMealType,
          onMealTypeChanged: viewModel.setSelectedMealType,
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildMealsList(viewModel)),
      ],
    );
  }

  Widget _buildProgressView(CalorieTrackingViewModel viewModel) {
    if (viewModel.dailySummary == null) {
      return const Center(child: Text('No data available'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildDateSelector(viewModel),
          NutritionProgressWidget(dailySummary: viewModel.dailySummary!),
        ],
      ),
    );
  }

  Widget _buildDateSelector(CalorieTrackingViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              final previousDay = viewModel.selectedDate.subtract(
                const Duration(days: 1),
              );
              viewModel.setSelectedDate(previousDay);
            },
          ),
          GestureDetector(
            onTap: () => _selectDate(context, viewModel),
            child: Text(
              DateFormat('EEEE, MMM d').format(viewModel.selectedDate),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              final nextDay = viewModel.selectedDate.add(
                const Duration(days: 1),
              );
              viewModel.setSelectedDate(nextDay);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(CalorieTrackingViewModel viewModel) {
    final summary = viewModel.dailySummary;
    if (summary == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Daily Summary',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutrientInfo(
                  'Calories',
                  '${summary.totalCalories}',
                  Colors.orange,
                ),
                _buildNutrientInfo(
                  'Protein',
                  '${summary.totalProtein.toStringAsFixed(1)}g',
                  Colors.blue,
                ),
                _buildNutrientInfo(
                  'Carbs',
                  '${summary.totalCarbs.toStringAsFixed(1)}g',
                  Colors.green,
                ),
                _buildNutrientInfo(
                  'Fat',
                  '${summary.totalFat.toStringAsFixed(1)}g',
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildMealsList(CalorieTrackingViewModel viewModel) {
    final summary = viewModel.dailySummary;
    if (summary == null || summary.meals.isEmpty) {
      return const Center(child: Text('No foods tracked for this day'));
    }

    return ListView.builder(
      itemCount: MealType.all.length,
      itemBuilder: (context, index) {
        final mealType = MealType.all[index];
        final mealSummary = summary.meals.firstWhere(
          (meal) => meal.mealType == mealType,
          orElse: () => MealSummary.fromFoods(mealType, []),
        );

        return _buildMealCard(mealType, mealSummary, viewModel);
      },
    );
  }

  Widget _buildMealCard(
    String mealType,
    MealSummary mealSummary,
    CalorieTrackingViewModel viewModel,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              mealType.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${mealSummary.totalCalories} cal',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            viewModel.setSelectedMealType(mealType);
            _showFoodSearchDialog(context, viewModel);
          },
        ),
        children: [
          ...mealSummary.foods.map((food) => _buildFoodItem(food, viewModel)),
        ],
      ),
    );
  }

  Widget _buildFoodItem(TrackedFood food, CalorieTrackingViewModel viewModel) {
    return ListTile(
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
      subtitle: Text('${food.amount.toStringAsFixed(0)}g'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${food.calories} cal',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => viewModel.removeFoodFromMeal(food.id!),
          ),
        ],
      ),
    );
  }

  void _showFoodSearchDialog(
    BuildContext context,
    CalorieTrackingViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => FoodSearchDialog(viewModel: viewModel),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    CalorieTrackingViewModel viewModel,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viewModel.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != viewModel.selectedDate) {
      viewModel.setSelectedDate(picked);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
