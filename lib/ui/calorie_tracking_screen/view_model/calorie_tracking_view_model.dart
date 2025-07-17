import 'package:calorie_tracker_app/data/repository/food_repository.dart';
import 'package:calorie_tracker_app/domain/models/daily_summary.dart';
import 'package:calorie_tracker_app/domain/models/food.dart';
import 'package:calorie_tracker_app/domain/models/meal_type.dart';
import 'package:calorie_tracker_app/domain/use_cases/calorie_tracking_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CalorieTrackingViewModel extends ChangeNotifier {
  final CalorieTrackingUseCase _useCase;
  final IFoodRepository _foodRepository;

  CalorieTrackingViewModel({
    required CalorieTrackingUseCase useCase,
    required IFoodRepository foodRepository,
  }) : _useCase = useCase,
       _foodRepository = foodRepository;

  // State management
  bool _isLoading = false;
  String? _errorMessage;
  DailySummary? _dailySummary;
  List<Food> _searchResults = [];
  DateTime _selectedDate = DateTime.now();
  String _selectedMealType = MealType.breakfast;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DailySummary? get dailySummary => _dailySummary;
  List<Food> get searchResults => _searchResults;
  DateTime get selectedDate => _selectedDate;
  String get selectedMealType => _selectedMealType;

  // Load daily summary
  Future<void> loadDailySummary([DateTime? date]) async {
    _setLoading(true);
    try {
      final targetDate = date ?? _selectedDate;
      _dailySummary = await _useCase.getDailySummary(targetDate);
      _clearError();
    } catch (e) {
      _setError('Failed to load daily summary: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search foods
  Future<void> searchFoods(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      _searchResults = [];
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint("here we are");
      _searchResults = await _foodRepository.searchFoods(
        searchTerm: trimmedQuery,
      );
      debugPrint(
        '✅ Found ${_searchResults.length} foods for query: $trimmedQuery',
      );
    } catch (e) {
      _searchResults = [];
      _errorMessage = '❌ Error searching foods: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add food to meal
  Future<void> addFoodToMeal(Food food, double amount) async {
    _setLoading(true);
    try {
      await _useCase.addFoodToMeal(
        food: food,
        amount: amount,
        date: _selectedDate,
        mealType: _selectedMealType,
      );
      await loadDailySummary(); // Refresh the summary
      _clearError();
    } catch (e) {
      _setError('Failed to add food: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Remove food from meal
  Future<void> removeFoodFromMeal(int trackedFoodId) async {
    _setLoading(true);
    try {
      await _useCase.removeFoodFromMeal(trackedFoodId);
      await loadDailySummary(); // Refresh the summary
      _clearError();
    } catch (e) {
      _setError('Failed to remove food: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
    loadDailySummary();
  }

  // Set selected meal type
  void setSelectedMealType(String mealType) {
    _selectedMealType = mealType;
    notifyListeners();
  }

  // Clear search results
  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
