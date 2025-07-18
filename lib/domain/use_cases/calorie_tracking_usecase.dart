import 'package:calorie_tracker_app/data/repository/tracked_food_repository.dart';
import 'package:calorie_tracker_app/domain/models/daily_summary.dart';
import 'package:calorie_tracker_app/domain/models/food.dart';
import 'package:calorie_tracker_app/domain/models/tracked_food.dart';

class CalorieTrackingUseCase {
  final ITrackedFoodRepository _repository;

  CalorieTrackingUseCase({required ITrackedFoodRepository repository})
    : _repository = repository;

  Future<void> addFoodToMeal({
    required Food food,
    required double amount,
    required DateTime date,
    required String mealType,
  }) async {
    final trackedFood = TrackedFood.fromFood(food, amount, date, mealType);
    await _repository.addTrackedFood(trackedFood);
  }

  Future<void> removeFoodFromMeal(int trackedFoodId) async {
    await _repository.removeTrackedFood(trackedFoodId);
  }

  Future<List<TrackedFood>> getMealFoods(DateTime date, String mealType) async {
    return await _repository.getTrackedFoodsByDateAndMeal(date, mealType);
  }

  Future<DailySummary> getDailySummary(DateTime date) async {
    return await _repository.getDailySummary(date);
  }

  Future<List<TrackedFood>> getAllTrackedFoods() async {
    return await _repository.getAllTrackedFoods();
  }
}
