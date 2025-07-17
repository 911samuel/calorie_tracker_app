import 'package:calorie_tracker_app/data/services/tracked_food_service.dart';
import 'package:calorie_tracker_app/domain/models/daily_summary.dart';
import 'package:calorie_tracker_app/domain/models/meal_summary.dart';
import 'package:calorie_tracker_app/domain/models/tracked_food.dart';

abstract class ITrackedFoodRepository {
  Future<void> addTrackedFood(TrackedFood food);
  Future<void> removeTrackedFood(int id);
  Future<List<TrackedFood>> getTrackedFoodsByDate(DateTime date);
  Future<List<TrackedFood>> getTrackedFoodsByDateAndMeal(
    DateTime date,
    String mealType,
  );
  Future<DailySummary> getDailySummary(DateTime date);
  Future<List<TrackedFood>> getAllTrackedFoods();
}

class TrackedFoodRepository implements ITrackedFoodRepository {
  final TrackedFoodService _service;

  TrackedFoodRepository({required TrackedFoodService service})
    : _service = service;

  @override
  Future<void> addTrackedFood(TrackedFood food) async {
    await _service.insertTrackedFood(food);
  }

  @override
  Future<void> removeTrackedFood(int id) async {
    await _service.deleteTrackedFood(id);
  }

  @override
  Future<List<TrackedFood>> getTrackedFoodsByDate(DateTime date) async {
    return await _service.getTrackedFoodsByDate(date);
  }

  @override
  Future<List<TrackedFood>> getTrackedFoodsByDateAndMeal(
    DateTime date,
    String mealType,
  ) async {
    return await _service.getTrackedFoodsByDateAndMeal(date, mealType);
  }

  @override
  Future<DailySummary> getDailySummary(DateTime date) async {
    final trackedFoods = await getTrackedFoodsByDate(date);

    // Group foods by meal type
    final Map<String, List<TrackedFood>> groupedFoods = {};
    for (final food in trackedFoods) {
      if (!groupedFoods.containsKey(food.mealType)) {
        groupedFoods[food.mealType] = [];
      }
      groupedFoods[food.mealType]!.add(food);
    }

    // Create meal summaries
    final meals = groupedFoods.entries
        .map((entry) => MealSummary.fromFoods(entry.key, entry.value))
        .toList();

    return DailySummary.fromMeals(date, meals);
  }

  @override
  Future<List<TrackedFood>> getAllTrackedFoods() async {
    return await _service.getAllTrackedFoods();
  }
}
