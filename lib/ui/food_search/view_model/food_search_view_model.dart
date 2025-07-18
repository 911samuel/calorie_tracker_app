import 'package:calorie_tracker_app/data/repository/food_repository.dart';
import 'package:calorie_tracker_app/domain/models/food.dart';
import 'package:calorie_tracker_app/config/service_locator.dart';
import 'package:calorie_tracker_app/ui/food_search/view_model/calorie_tracking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodSearchViewModel extends ChangeNotifier {
  bool _isAdding = false;
  String? _addError;

  bool get isAdding => _isAdding;
  String? get addError => _addError;

  final IFoodRepository _foodRepository;

  // Constructor with fallback to GetIt
  FoodSearchViewModel({IFoodRepository? foodRepository})
    : _foodRepository = foodRepository ?? getIt<IFoodRepository>();

  List<Food> _foods = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _lastQuery = ''; // Track last search query

  List<Food> get foods => _foods;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get lastQuery => _lastQuery;

  Future<void> searchFoods(String query) async {
    final trimmedQuery = query.trim();

    // Early return for empty query
    if (trimmedQuery.isEmpty) {
      _foods = [];
      _lastQuery = '';
      notifyListeners();
      return;
    }

    // Avoid duplicate searches
    if (trimmedQuery == _lastQuery && !_isLoading) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _lastQuery = trimmedQuery;
    notifyListeners();

    try {
      _foods = await _foodRepository.searchFoods(searchTerm: trimmedQuery);

      // Only update if this is still the current query (handle race conditions)
      if (_lastQuery == trimmedQuery) {
        _errorMessage = null;
      }
    } catch (e) {
      // Only update error if this is still the current query
      if (_lastQuery == trimmedQuery) {
        _errorMessage = e.toString();
        _foods = [];
      }
    } finally {
      // Only update loading state if this is still the current query
      if (_lastQuery == trimmedQuery) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void clearResults() {
    _foods = [];
    _errorMessage = null;
    _lastQuery = '';
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Add method to retry last search
  Future<void> retryLastSearch() async {
    if (_lastQuery.isNotEmpty) {
      await searchFoods(_lastQuery);
    }
  }

  // Add method to check if we have results
  bool get hasResults => _foods.isNotEmpty;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _foods.isEmpty && !_isLoading && !hasError;

  // Add food to meal, with validation and state
  Future<bool> addFoodToMeal({
    required dynamic food,
    required String amountStr,
    required String mealType,
    required DateTime selectedDate,
    required WidgetRef ref,
  }) async {
    final amount = double.tryParse(amountStr);
    if (amount == null || amount <= 0) {
      _addError = 'Please enter a valid amount';
      notifyListeners();
      return false;
    }
    if (_isAdding) return false;
    _isAdding = true;
    _addError = null;
    notifyListeners();
    try {
      ref.read(calorieTrackingProvider).setSelectedMealType(mealType);
      ref.read(calorieTrackingProvider).setSelectedDate(selectedDate);
      await ref.read(calorieTrackingProvider).addFoodToMeal(food, amount);
      _addError = null;
      notifyListeners();
      return true;
    } catch (e) {
      _addError = 'Error adding food: $e';
      notifyListeners();
      return false;
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  final foodSearchProvider = ChangeNotifierProvider<FoodSearchViewModel>((ref) {
    return FoodSearchViewModel(foodRepository: getIt<IFoodRepository>());
  });

  @override
  void dispose() {
    // Clean up if needed
    super.dispose();
  }
}

final foodSearchViewModelProvider = ChangeNotifierProvider(
  (ref) => FoodSearchViewModel(),
);
