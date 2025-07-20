import 'package:calorie_tracker_app/domain/use_cases/calculate_nutrients_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:calorie_tracker_app/ui/home/view/home_screen.dart';
import 'package:calorie_tracker_app/ui/home/view_model/home_viewmodel.dart';
import 'package:calorie_tracker_app/ui/food_search/view_model/calorie_tracking_view_model.dart';
import 'package:calorie_tracker_app/ui/home/widget/date_picker_header.dart';
import 'package:calorie_tracker_app/ui/home/widget/nutrition_card.dart';
import 'package:calorie_tracker_app/core/ui/nutrition_progress.dart';
import 'package:calorie_tracker_app/domain/models/daily_summary.dart';
import 'package:calorie_tracker_app/domain/models/meal_summary.dart';
import 'package:calorie_tracker_app/domain/models/tracked_food.dart';
import 'package:calorie_tracker_app/domain/models/food_item.dart';

// Generate mocks
@GenerateMocks([
  HomeViewModel,
  CalorieTrackingViewModel,
  DailySummary,
  MealSummary,
  TrackedFood,
  FoodItem,
  NutrientGoalResult,
])
import 'home_screen_test.mocks.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    late MockHomeViewModel mockHomeViewModel;
    late MockCalorieTrackingViewModel mockCalorieTrackingViewModel;
    late MockDailySummary mockDailySummary;
    late MockNutrientGoalResult mockNutrientGoalResult;

    setUp(() {
      mockHomeViewModel = MockHomeViewModel();
      mockCalorieTrackingViewModel = MockCalorieTrackingViewModel();
      mockDailySummary = MockDailySummary();
      mockNutrientGoalResult = MockNutrientGoalResult();
    });

    Widget createHomeScreen() {
      return ProviderScope(
        overrides: [
          homeViewModelProvider.overrideWith((ref) => mockHomeViewModel),
          calorieTrackingProvider.overrideWith(
            (ref) => mockCalorieTrackingViewModel,
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      );
    }

    group('Initial State Tests', () {
      testWidgets('should display loading indicator when isLoading is true', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockHomeViewModel.isLoading).thenReturn(true);
        when(mockHomeViewModel.selectedDate).thenReturn(DateTime(2024, 1, 15));
        when(
          mockHomeViewModel.nutrientGoalResult,
        ).thenReturn(mockNutrientGoalResult);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({
          'calories': 0.0,
          'carbs': 0.0,
          'protein': 0.0,
          'fat': 0.0,
        });
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);
        when(mockNutrientGoalResult.caloriesGoal).thenReturn(2000);
        when(mockNutrientGoalResult.carbsGoal).thenReturn(150);
        when(mockNutrientGoalResult.proteinGoal).thenReturn(120);
        when(mockNutrientGoalResult.fatGoal).thenReturn(100);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(ListView), findsNothing);
      });

      testWidgets('should display main content when not loading', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockHomeViewModel.isLoading).thenReturn(false);
        when(mockHomeViewModel.selectedDate).thenReturn(DateTime(2024, 1, 15));
        when(
          mockHomeViewModel.nutrientGoalResult,
        ).thenReturn(mockNutrientGoalResult);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({
          'calories': 1500.0,
          'carbs': 120.0,
          'protein': 80.0,
          'fat': 60.0,
        });
        when(mockHomeViewModel.buildMealData(any)).thenReturn([]);
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);
        when(mockNutrientGoalResult.caloriesGoal).thenReturn(2000);
        when(mockNutrientGoalResult.carbsGoal).thenReturn(150);
        when(mockNutrientGoalResult.proteinGoal).thenReturn(120);
        when(mockNutrientGoalResult.fatGoal).thenReturn(100);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(DatePickerHeader), findsOneWidget);
      });
    });

    group('AppBar Tests', () {
      testWidgets('should display NutritionRingProgress in AppBar', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockHomeViewModel.isLoading).thenReturn(false);
        when(mockHomeViewModel.selectedDate).thenReturn(DateTime(2024, 1, 15));
        when(
          mockHomeViewModel.nutrientGoalResult,
        ).thenReturn(mockNutrientGoalResult);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({
          'calories': 1200.0,
          'carbs': 100.0,
          'protein': 70.0,
          'fat': 50.0,
        });
        when(mockHomeViewModel.buildMealData(any)).thenReturn([]);
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);
        when(mockNutrientGoalResult.caloriesGoal).thenReturn(2000);
        when(mockNutrientGoalResult.carbsGoal).thenReturn(150);
        when(mockNutrientGoalResult.proteinGoal).thenReturn(120);
        when(mockNutrientGoalResult.fatGoal).thenReturn(100);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Assert
        expect(find.byType(NutritionRingProgress), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('should display AppBar with correct properties', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockHomeViewModel.isLoading).thenReturn(false);
        when(mockHomeViewModel.selectedDate).thenReturn(DateTime(2024, 1, 15));
        when(
          mockHomeViewModel.nutrientGoalResult,
        ).thenReturn(mockNutrientGoalResult);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({});
        when(mockHomeViewModel.buildMealData(any)).thenReturn([]);
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);
        when(mockNutrientGoalResult.caloriesGoal).thenReturn(2000);
        when(mockNutrientGoalResult.carbsGoal).thenReturn(150);
        when(mockNutrientGoalResult.proteinGoal).thenReturn(120);
        when(mockNutrientGoalResult.fatGoal).thenReturn(100);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Assert
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.backgroundColor, Colors.transparent);
        expect(appBar.elevation, 0);
        expect(appBar.toolbarHeight, 280);
        expect(appBar.automaticallyImplyLeading, false);
      });
    });

    group('DatePickerHeader Tests', () {
      testWidgets('should display DatePickerHeader with correct date', (
        WidgetTester tester,
      ) async {
        // Arrange
        final selectedDate = DateTime(2024, 3, 15);
        when(mockHomeViewModel.isLoading).thenReturn(false);
        when(mockHomeViewModel.selectedDate).thenReturn(selectedDate);
        when(
          mockHomeViewModel.nutrientGoalResult,
        ).thenReturn(mockNutrientGoalResult);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({});
        when(mockHomeViewModel.buildMealData(any)).thenReturn([]);
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);
        when(mockNutrientGoalResult.caloriesGoal).thenReturn(2000);
        when(mockNutrientGoalResult.carbsGoal).thenReturn(150);
        when(mockNutrientGoalResult.proteinGoal).thenReturn(120);
        when(mockNutrientGoalResult.fatGoal).thenReturn(100);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Assert
        expect(find.byType(DatePickerHeader), findsOneWidget);
        final datePickerHeader = tester.widget<DatePickerHeader>(
          find.byType(DatePickerHeader),
        );
        expect(datePickerHeader.selectedDate, selectedDate);
      });

      testWidgets('should call decrementDate when previous button is tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockHomeViewModel.isLoading).thenReturn(false);
        when(mockHomeViewModel.selectedDate).thenReturn(DateTime(2024, 1, 15));
        when(
          mockHomeViewModel.nutrientGoalResult,
        ).thenReturn(mockNutrientGoalResult);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({});
        when(mockHomeViewModel.buildMealData(any)).thenReturn([]);
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);
        when(mockNutrientGoalResult.caloriesGoal).thenReturn(2000);
        when(mockNutrientGoalResult.carbsGoal).thenReturn(150);
        when(mockNutrientGoalResult.proteinGoal).thenReturn(120);
        when(mockNutrientGoalResult.fatGoal).thenReturn(100);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Find and tap the previous button (assuming it's an IconButton or similar)
        final datePickerHeader = tester.widget<DatePickerHeader>(
          find.byType(DatePickerHeader),
        );
        datePickerHeader.onPrevious();

        // Assert
        verify(mockHomeViewModel.decrementDate()).called(1);
      });

      testWidgets('should call incrementDate when next button is tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockHomeViewModel.isLoading).thenReturn(false);
        when(mockHomeViewModel.selectedDate).thenReturn(DateTime(2024, 1, 15));
        when(
          mockHomeViewModel.nutrientGoalResult,
        ).thenReturn(mockNutrientGoalResult);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({});
        when(mockHomeViewModel.buildMealData(any)).thenReturn([]);
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);
        when(mockNutrientGoalResult.caloriesGoal).thenReturn(2000);
        when(mockNutrientGoalResult.carbsGoal).thenReturn(150);
        when(mockNutrientGoalResult.proteinGoal).thenReturn(120);
        when(mockNutrientGoalResult.fatGoal).thenReturn(100);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Find and tap the next button
        final datePickerHeader = tester.widget<DatePickerHeader>(
          find.byType(DatePickerHeader),
        );
        datePickerHeader.onNext();

        // Assert
        verify(mockHomeViewModel.incrementDate()).called(1);
      });
    });

    group('Meal Cards Tests', () {
      testWidgets('should display nutrition cards for each meal', (
        WidgetTester tester,
      ) async {
        // Arrange
        final mockMealSummary = MockMealSummary();
        final mockTrackedFood = MockTrackedFood();
        final mockFoodItem = MockFoodItem();

        when(mockTrackedFood.id).thenReturn(123); 
        when(mockTrackedFood.name).thenReturn('Apple');
        when(mockMealSummary.foods).thenReturn([mockTrackedFood]);
        when(mockFoodItem.name).thenReturn('Apple');

        when(mockHomeViewModel.isLoading).thenReturn(false);
        when(mockHomeViewModel.selectedDate).thenReturn(DateTime(2024, 1, 15));
        when(
          mockHomeViewModel.nutrientGoalResult,
        ).thenReturn(mockNutrientGoalResult);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({});
        when(mockHomeViewModel.buildMealData(any)).thenReturn([
          {
            'mealType': 'Breakfast',
            'imagePath': 'assets/breakfast.png',
            'nutritionData': {
              'calories': 300,
              'protein': 10,
              'carbs': 40,
              'fat': 8,
            },
            'foodItems': [mockFoodItem],
            'mealSummary': mockMealSummary,
          },
          {
            'mealType': 'Lunch',
            'imagePath': 'assets/lunch.png',
            'nutritionData': {
              'calories': 450,
              'protein': 25,
              'carbs': 35,
              'fat': 18,
            },
            'foodItems': [mockFoodItem],
            'mealSummary': mockMealSummary,
          },
        ]);
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);
        when(mockNutrientGoalResult.caloriesGoal).thenReturn(2000);
        when(mockNutrientGoalResult.carbsGoal).thenReturn(150);
        when(mockNutrientGoalResult.proteinGoal).thenReturn(120);
        when(mockNutrientGoalResult.fatGoal).thenReturn(100);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Assert
        expect(find.byType(NutritionCard), findsNWidgets(2));
      });

      testWidgets('should call addFood when nutrition card is tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        final mockMealSummary = MockMealSummary();
        final mockFoodItem = MockFoodItem();

        when(mockHomeViewModel.isLoading).thenReturn(false);
        when(mockHomeViewModel.selectedDate).thenReturn(DateTime(2024, 1, 15));
        when(
          mockHomeViewModel.nutrientGoalResult,
        ).thenReturn(mockNutrientGoalResult);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({});
        when(mockHomeViewModel.buildMealData(any)).thenReturn([
          {
            'mealType': 'Breakfast',
            'imagePath': 'assets/breakfast.png',
            'nutritionData': {'calories': 300},
            'foodItems': [mockFoodItem],
            'mealSummary': mockMealSummary,
          },
        ]);
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);
        when(mockNutrientGoalResult.caloriesGoal).thenReturn(2000);
        when(mockNutrientGoalResult.carbsGoal).thenReturn(150);
        when(mockNutrientGoalResult.proteinGoal).thenReturn(120);
        when(mockNutrientGoalResult.fatGoal).thenReturn(100);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Find and tap the nutrition card
        final nutritionCard = tester.widget<NutritionCard>(
          find.byType(NutritionCard),
        );
        nutritionCard.onTap!();

        // Assert
        verify(mockHomeViewModel.addFood(any, 'Breakfast')).called(1);
      });

      testWidgets('should call removeFoodFromMeal when food item is removed', (
        WidgetTester tester,
      ) async {
        // Arrange
        final mockMealSummary = MockMealSummary();
        final mockTrackedFood = MockTrackedFood();
        final mockFoodItem = MockFoodItem();

        when(mockTrackedFood.id).thenReturn(123);
        when(mockTrackedFood.name).thenReturn('Apple');
        when(mockMealSummary.foods).thenReturn([mockTrackedFood]);
        when(mockFoodItem.name).thenReturn('Apple');

        when(mockHomeViewModel.isLoading).thenReturn(false);
        when(mockHomeViewModel.selectedDate).thenReturn(DateTime(2024, 1, 15));
        when(
          mockHomeViewModel.nutrientGoalResult,
        ).thenReturn(mockNutrientGoalResult);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({});
        when(mockHomeViewModel.buildMealData(any)).thenReturn([
          {
            'mealType': 'Breakfast',
            'imagePath': 'assets/breakfast.png',
            'nutritionData': {'calories': 300},
            'foodItems': [mockFoodItem],
            'mealSummary': mockMealSummary,
          },
        ]);
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);
        when(mockNutrientGoalResult.caloriesGoal).thenReturn(2000);
        when(mockNutrientGoalResult.carbsGoal).thenReturn(150);
        when(mockNutrientGoalResult.proteinGoal).thenReturn(120);
        when(mockNutrientGoalResult.fatGoal).thenReturn(100);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Simulate food item removal
        final nutritionCard = tester.widget<NutritionCard>(
          find.byType(NutritionCard),
        );
        nutritionCard.onFoodItemRemoved!(mockFoodItem);

        // Assert
        verify(mockHomeViewModel.removeFoodFromMeal(123)).called(1);
      });
    });

    group('Nutrition Progress Tests', () {
      testWidgets('should display nutrition progress with correct values', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockHomeViewModel.isLoading).thenReturn(false);
        when(mockHomeViewModel.selectedDate).thenReturn(DateTime(2024, 1, 15));
        when(
          mockHomeViewModel.nutrientGoalResult,
        ).thenReturn(mockNutrientGoalResult);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({
          'calories': 1800.0,
          'carbs': 130.0,
          'protein': 100.0,
          'fat': 75.0,
        });
        when(mockHomeViewModel.buildMealData(any)).thenReturn([]);
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);
        when(mockNutrientGoalResult.caloriesGoal).thenReturn(2000);
        when(mockNutrientGoalResult.carbsGoal).thenReturn(150);
        when(mockNutrientGoalResult.proteinGoal).thenReturn(120);
        when(mockNutrientGoalResult.fatGoal).thenReturn(100);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Assert
        expect(find.byType(NutritionRingProgress), findsOneWidget);
        final nutritionProgress = tester.widget<NutritionRingProgress>(
          find.byType(NutritionRingProgress),
        );
        expect(nutritionProgress.totalCalories, 1800.0);
        expect(nutritionProgress.totalGoal, 2000.0);
        expect(nutritionProgress.carbsValue, 130.0);
        expect(nutritionProgress.carbsGoal, 150.0);
        expect(nutritionProgress.proteinValue, 100.0);
        expect(nutritionProgress.proteinGoal, 120.0);
        expect(nutritionProgress.fatValue, 75.0);
        expect(nutritionProgress.fatGoal, 100.0);
      });

      testWidgets('should use default values when nutrient goals are null', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockHomeViewModel.isLoading).thenReturn(false);
        when(mockHomeViewModel.selectedDate).thenReturn(DateTime(2024, 1, 15));
        when(mockHomeViewModel.nutrientGoalResult).thenReturn(null);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({
          'calories': 1200.0,
          'carbs': 100.0,
          'protein': 80.0,
          'fat': 50.0,
        });
        when(mockHomeViewModel.buildMealData(any)).thenReturn([]);
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Assert
        final nutritionProgress = tester.widget<NutritionRingProgress>(
          find.byType(NutritionRingProgress),
        );
        expect(nutritionProgress.totalGoal, 2000.0);
        expect(nutritionProgress.carbsGoal, 150.0);
        expect(nutritionProgress.proteinGoal, 120.0);
        expect(nutritionProgress.fatGoal, 100.0);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty meal data', (WidgetTester tester) async {
        // Arrange
        when(mockHomeViewModel.isLoading).thenReturn(false);
        when(mockHomeViewModel.selectedDate).thenReturn(DateTime(2024, 1, 15));
        when(
          mockHomeViewModel.nutrientGoalResult,
        ).thenReturn(mockNutrientGoalResult);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({});
        when(mockHomeViewModel.buildMealData(any)).thenReturn([]);
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);
        when(mockNutrientGoalResult.caloriesGoal).thenReturn(2000);
        when(mockNutrientGoalResult.carbsGoal).thenReturn(150);
        when(mockNutrientGoalResult.proteinGoal).thenReturn(120);
        when(mockNutrientGoalResult.fatGoal).thenReturn(100);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Assert
        expect(find.byType(NutritionCard), findsNothing);
        expect(find.byType(DatePickerHeader), findsOneWidget);
        expect(find.byType(NutritionRingProgress), findsOneWidget);
      });

      testWidgets('should handle null totals values', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockHomeViewModel.isLoading).thenReturn(false);
        when(mockHomeViewModel.selectedDate).thenReturn(DateTime(2024, 1, 15));
        when(
          mockHomeViewModel.nutrientGoalResult,
        ).thenReturn(mockNutrientGoalResult);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({
          'calories': ?null,
          'carbs': ?null,
          'protein': ?null,
          'fat': ?null,
        });
        when(mockHomeViewModel.buildMealData(any)).thenReturn([]);
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);
        when(mockNutrientGoalResult.caloriesGoal).thenReturn(2000);
        when(mockNutrientGoalResult.carbsGoal).thenReturn(150);
        when(mockNutrientGoalResult.proteinGoal).thenReturn(120);
        when(mockNutrientGoalResult.fatGoal).thenReturn(100);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Assert
        final nutritionProgress = tester.widget<NutritionRingProgress>(
          find.byType(NutritionRingProgress),
        );
        expect(nutritionProgress.totalCalories, 0);
        expect(nutritionProgress.carbsValue, 0);
        expect(nutritionProgress.proteinValue, 0);
        expect(nutritionProgress.fatValue, 0);
      });

      testWidgets('should handle food removal when tracked food has no ID', (
        WidgetTester tester,
      ) async {
        // Arrange
        final mockMealSummary = MockMealSummary();
        final mockTrackedFood = MockTrackedFood();
        final mockFoodItem = MockFoodItem();

        when(mockTrackedFood.id).thenReturn(null); // No ID
        when(mockTrackedFood.name).thenReturn('Apple');
        when(mockMealSummary.foods).thenReturn([mockTrackedFood]);
        when(mockFoodItem.name).thenReturn('Apple');

        when(mockHomeViewModel.isLoading).thenReturn(false);
        when(mockHomeViewModel.selectedDate).thenReturn(DateTime(2024, 1, 15));
        when(
          mockHomeViewModel.nutrientGoalResult,
        ).thenReturn(mockNutrientGoalResult);
        when(mockHomeViewModel.calculateTotals(any)).thenReturn({});
        when(mockHomeViewModel.buildMealData(any)).thenReturn([
          {
            'mealType': 'Breakfast',
            'imagePath': 'assets/breakfast.png',
            'nutritionData': {'calories': 300},
            'foodItems': [mockFoodItem],
            'mealSummary': mockMealSummary,
          },
        ]);
        when(
          mockCalorieTrackingViewModel.dailySummary,
        ).thenReturn(mockDailySummary);
        when(mockNutrientGoalResult.caloriesGoal).thenReturn(2000);
        when(mockNutrientGoalResult.carbsGoal).thenReturn(150);
        when(mockNutrientGoalResult.proteinGoal).thenReturn(120);
        when(mockNutrientGoalResult.fatGoal).thenReturn(100);

        // Act
        await tester.pumpWidget(createHomeScreen());

        // Simulate food item removal
        final nutritionCard = tester.widget<NutritionCard>(
          find.byType(NutritionCard),
        );
        nutritionCard.onFoodItemRemoved!(mockFoodItem);

        // Assert - removeFoodFromMeal should not be called when ID is null
        verifyNever(mockHomeViewModel.removeFoodFromMeal(any));
      });
    });
  });
}
