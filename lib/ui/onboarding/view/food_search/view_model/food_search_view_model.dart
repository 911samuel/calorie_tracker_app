import 'package:calorie_tracker_app/data/repository/food_repository.dart';
import 'package:calorie_tracker_app/domain/food.dart';
import 'package:calorie_tracker_app/config/service_locator.dart';
import 'package:flutter/material.dart';

class FoodSearchViewModel extends ChangeNotifier {
  final IFoodRepository _foodRepository;

  // Constructor with fallback to GetIt
  FoodSearchViewModel({IFoodRepository? foodRepository})
    : _foodRepository = foodRepository ?? getIt<IFoodRepository>();

  List<Food> _foods = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Food> get foods => _foods;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> searchFoods(String query) async {
    if (query.trim().isEmpty) {
      _foods = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _foods = await _foodRepository.searchFoods(searchTerm: query);
      print('✅ Found ${_foods.length} foods for query: $query');
    } catch (e) {
      _errorMessage = e.toString();
      _foods = [];
      print('❌ Error searching foods: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResults() {
    _foods = [];
    _errorMessage = null;
    notifyListeners();
  }
}
