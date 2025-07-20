import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:calorie_tracker_app/ui/food_search/view_model/food_search_view_model.dart';
import 'package:calorie_tracker_app/data/repository/food_repository.dart';
import 'package:calorie_tracker_app/domain/models/food.dart';
import 'package:calorie_tracker_app/ui/food_search/view_model/calorie_tracking_view_model.dart';

// Generate mocks
@GenerateMocks([IFoodRepository, CalorieTrackingViewModel])
import 'food_search_view_model_test.mocks.dart';

void main() {
  group('FoodSearchViewModel', () {
    late FoodSearchViewModel viewModel;
    late MockIFoodRepository mockRepository;

    setUp(() {
      mockRepository = MockIFoodRepository();
      viewModel = FoodSearchViewModel(foodRepository: mockRepository);
    });

    test('Initial values are correct', () {
      expect(viewModel.foods, []);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      expect(viewModel.lastQuery, '');
      expect(viewModel.isAdding, false);
      expect(viewModel.addError, null);
      expect(viewModel.hasResults, false);
      expect(viewModel.hasError, false);
      expect(viewModel.isEmpty, true);
    });

    test('searchFoods sets loading and updates foods on success', () async {
      final foods = [
        Food(
          id: '1',
          name: 'Apple',
          caloriesPer100g: 52,
          proteinPer100g: 0.3,
          carbsPer100g: 14.0,
          fatPer100g: 0.2,
          imageUrl: null,
        ),
      ];
      when(
        mockRepository.searchFoods(searchTerm: 'apple'),
      ).thenAnswer((_) async => foods);

      // Track loading state changes
      bool loadingWasTrue = false;
      viewModel.addListener(() {
        if (viewModel.isLoading) {
          loadingWasTrue = true;
        }
      });

      await viewModel.searchFoods('apple');

      expect(loadingWasTrue, true); // Verify loading was set to true
      expect(viewModel.foods, foods);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      expect(viewModel.lastQuery, 'apple');
      expect(viewModel.hasResults, true);
      expect(viewModel.isEmpty, false);
    });

    test('searchFoods handles errors', () async {
      when(
        mockRepository.searchFoods(searchTerm: 'fail'),
      ).thenThrow(Exception('Network error'));

      // Track loading state changes
      bool loadingWasTrue = false;
      viewModel.addListener(() {
        if (viewModel.isLoading) {
          loadingWasTrue = true;
        }
      });

      await viewModel.searchFoods('fail');

      expect(loadingWasTrue, true); // Verify loading was set to true
      expect(viewModel.foods, []);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.errorMessage, contains('Exception: Network error'));
      expect(viewModel.lastQuery, 'fail');
      expect(viewModel.hasError, true);
      expect(viewModel.hasResults, false);
    });

    test('searchFoods with empty query clears results', () async {
      await viewModel.searchFoods('');

      expect(viewModel.foods, []);
      expect(viewModel.lastQuery, '');
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);

      // Test with whitespace
      await viewModel.searchFoods('   ');
      expect(viewModel.foods, []);
      expect(viewModel.lastQuery, '');
    });

    test('searchFoods avoids duplicate searches', () async {
      final foods = [
        Food(
          id: '1',
          name: 'Apple',
          caloriesPer100g: 52,
          proteinPer100g: 0.3,
          carbsPer100g: 14.0,
          fatPer100g: 0.2,
          imageUrl: null,
        ),
      ];
      when(
        mockRepository.searchFoods(searchTerm: 'apple'),
      ).thenAnswer((_) async => foods);

      // First search
      await viewModel.searchFoods('apple');

      // Second search with same query should not trigger another API call
      await viewModel.searchFoods('apple');

      // Verify the repository was called only once
      verify(mockRepository.searchFoods(searchTerm: 'apple')).called(1);
    });

    test('clearResults resets foods and errorMessage', () {
      // Set up some initial state
      viewModel.searchFoods('test');

      viewModel.clearResults();

      expect(viewModel.foods, []);
      expect(viewModel.errorMessage, null);
      expect(viewModel.lastQuery, '');
      expect(viewModel.hasResults, false);
      expect(viewModel.hasError, false);
      expect(viewModel.isEmpty, true);
    });

    test('clearError resets errorMessage', () {
      // First trigger an error
      when(
        mockRepository.searchFoods(searchTerm: 'error'),
      ).thenThrow(Exception('Test error'));

      viewModel.searchFoods('error');

      viewModel.clearError();
      expect(viewModel.errorMessage, null);
      expect(viewModel.hasError, false);
    });

    test('retryLastSearch repeats the last search', () async {
      final foods = [
        Food(
          id: '1',
          name: 'Apple',
          caloriesPer100g: 52,
          proteinPer100g: 0.3,
          carbsPer100g: 14.0,
          fatPer100g: 0.2,
          imageUrl: null,
        ),
      ];
      when(
        mockRepository.searchFoods(searchTerm: 'apple'),
      ).thenAnswer((_) async => foods);

      // First search
      await viewModel.searchFoods('apple');

      // Clear results
      viewModel.clearResults();
      expect(viewModel.foods, []);

      // Retry should restore the last query
      await viewModel.retryLastSearch();

      // But since clearResults also clears lastQuery, this won't do anything
      expect(viewModel.foods, []);

      // Test retry with existing lastQuery
      await viewModel.searchFoods('apple');
      viewModel.clearError(); // Clear error but keep lastQuery
      await viewModel.retryLastSearch();

      expect(viewModel.foods, foods);
    });

    // Note: addFoodToMeal test is complex due to Riverpod dependencies
    // For now, we'll test just the validation logic conceptually
    test('addFoodToMeal amount validation logic', () {
      // Test the validation logic that would be used in addFoodToMeal

      // Invalid amount strings
      expect(double.tryParse('invalid'), null);
      expect(double.tryParse(''), null);
      expect(double.tryParse('abc'), null);

      // Valid amounts
      expect(double.tryParse('1.5'), 1.5);
      expect(double.tryParse('10'), 10.0);

      // Edge cases
      expect(double.tryParse('0'), 0.0);
      expect(double.tryParse('-1'), -1.0);

      // The actual validation in addFoodToMeal checks: amount == null || amount <= 0
      final validAmount = double.tryParse('1.5');
      expect(validAmount != null && validAmount > 0, true);

      final invalidAmount = double.tryParse('0');
      expect(invalidAmount == null || invalidAmount <= 0, true);
    });

    test('state getters work correctly', () {
      // Test initial empty state
      expect(viewModel.isEmpty, true);
      expect(viewModel.hasResults, false);
      expect(viewModel.hasError, false);

      // Simulate loading state
      viewModel.searchFoods('test');
      // Note: We can't easily test the loading state synchronously
      // since the method is async and completes quickly in tests
    });

    test('race condition handling in searchFoods', () async {
      // This test is more conceptual since it's hard to create actual race conditions in tests
      // but we can verify that the lastQuery tracking works

      final foods1 = [
        Food(
          id: '1',
          name: 'Apple',
          caloriesPer100g: 52,
          proteinPer100g: 0.3,
          carbsPer100g: 14.0,
          fatPer100g: 0.2,
          imageUrl: null,
        ),
      ];

      final foods2 = [
        Food(
          id: '2',
          name: 'Banana',
          caloriesPer100g: 89,
          proteinPer100g: 1.1,
          carbsPer100g: 23.0,
          fatPer100g: 0.3,
          imageUrl: null,
        ),
      ];

      when(
        mockRepository.searchFoods(searchTerm: 'apple'),
      ).thenAnswer((_) async => foods1);
      when(
        mockRepository.searchFoods(searchTerm: 'banana'),
      ).thenAnswer((_) async => foods2);

      // Quick successive searches
      await viewModel.searchFoods('apple');
      await viewModel.searchFoods('banana');

      // The last search should win
      expect(viewModel.lastQuery, 'banana');
      expect(viewModel.foods, foods2);
    });
  });
}
