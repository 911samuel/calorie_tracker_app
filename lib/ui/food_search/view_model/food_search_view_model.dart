import 'package:calorie_tracker_app/data/repository/food_repository.dart';
import 'package:calorie_tracker_app/domain/models/food.dart';
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
      debugPrint('✅ Found ${_foods.length} foods for query: $trimmedQuery');

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
      debugPrint('❌ Error searching foods: $e');
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

  @override
  void dispose() {
    // Clean up if needed
    super.dispose();
  }
}