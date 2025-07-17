import 'package:calorie_tracker_app/data/services/food_api_service.dart';
import 'package:calorie_tracker_app/domain/models/food.dart';

abstract class IFoodRepository {
  Future<List<Food>> searchFoods({
    required String searchTerm,
    int page = 1,
    int? pageSize,
  });
}

class FoodRepository implements IFoodRepository {
  final IFoodApiService _foodApiService;

  FoodRepository({required IFoodApiService foodApiService})
    : _foodApiService = foodApiService;

  @override
  Future<List<Food>> searchFoods({
    required String searchTerm,
    page = 1,
    int? pageSize,
  }) async {
    return await _foodApiService.searchFoods(
      searchTerm: searchTerm,
      page: page,
      pageSize: pageSize,
    );
  }
}
