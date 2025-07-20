import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:calorie_tracker_app/ui/food_search/view/food_search_screen.dart';
import 'package:calorie_tracker_app/ui/food_search/view_model/calorie_tracking_view_model.dart';
import 'package:calorie_tracker_app/ui/food_search/view_model/food_search_view_model.dart';
import 'package:calorie_tracker_app/ui/food_search/widget/food_search_body.dart';
import 'package:calorie_tracker_app/ui/food_search/widget/food_search_search_bar.dart';
import 'package:calorie_tracker_app/core/ui/custom_text.dart';

// Generate mocks
@GenerateMocks([CalorieTrackingViewModel, FoodSearchViewModel])
import 'food_search_screen_test.mocks.dart';

void main() {
  group('FoodSearchScreen Widget Tests', () {
    late MockCalorieTrackingViewModel mockCalorieTrackingViewModel;
    late MockFoodSearchViewModel mockFoodSearchViewModel;
    late DateTime testDate;
    const String testMealType = 'Breakfast';

    setUp(() {
      mockCalorieTrackingViewModel = MockCalorieTrackingViewModel();
      mockFoodSearchViewModel = MockFoodSearchViewModel();
      testDate = DateTime(2024, 3, 15);
    });

    Widget createFoodSearchScreen({
      String mealType = testMealType,
      DateTime? selectedDate,
    }) {
      return ProviderScope(
        overrides: [
          calorieTrackingProvider.overrideWith(
            (ref) => mockCalorieTrackingViewModel,
          ),
          foodSearchViewModelProvider.overrideWith(
            (ref) => mockFoodSearchViewModel,
          ),
        ],
        child: MaterialApp(
          home: FoodSearchScreen(
            mealType: mealType,
            selectedDate: selectedDate ?? testDate,
          ),
        ),
      );
    }

    group('Initialization Tests', () {
      testWidgets('should initialize with correct meal type and date', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createFoodSearchScreen());
        await tester.pumpAndSettle();

        // Assert
        verify(
          mockCalorieTrackingViewModel.setSelectedMealType(testMealType),
        ).called(1);
        verify(
          mockCalorieTrackingViewModel.setSelectedDate(testDate),
        ).called(1);
      });

      testWidgets('should initialize with different meal types', (
        WidgetTester tester,
      ) async {
        const lunchMealType = 'Lunch';

        // Act
        await tester.pumpWidget(
          createFoodSearchScreen(mealType: lunchMealType),
        );
        await tester.pumpAndSettle();

        // Assert
        verify(
          mockCalorieTrackingViewModel.setSelectedMealType(lunchMealType),
        ).called(1);
      });

      testWidgets('should initialize with different dates', (
        WidgetTester tester,
      ) async {
        final differentDate = DateTime(2024, 5, 20);

        // Act
        await tester.pumpWidget(
          createFoodSearchScreen(selectedDate: differentDate),
        );
        await tester.pumpAndSettle();

        // Assert
        verify(
          mockCalorieTrackingViewModel.setSelectedDate(differentDate),
        ).called(1);
      });
    });

    group('AppBar Tests', () {
      testWidgets('should display correct title in AppBar', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createFoodSearchScreen());

        // Assert
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(CustomText), findsOneWidget);

        final customText = tester.widget<CustomText>(find.byType(CustomText));
        expect(customText.label, 'Add to $testMealType');
        expect(customText.fontSize, 20);
        expect(customText.fontWeight, FontWeight.bold);
      });

      testWidgets('should display correct title for different meal types', (
        WidgetTester tester,
      ) async {
        const dinnerMealType = 'Dinner';

        // Act
        await tester.pumpWidget(
          createFoodSearchScreen(mealType: dinnerMealType),
        );

        // Assert
        final customText = tester.widget<CustomText>(find.byType(CustomText));
        expect(customText.label, 'Add to $dinnerMealType');
      });

      testWidgets('should have correct AppBar properties', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createFoodSearchScreen());

        // Assert
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.backgroundColor, Colors.white);
        expect(appBar.elevation, 0);
      });

      testWidgets('should display back button in AppBar', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createFoodSearchScreen());

        // Assert
        expect(find.byType(IconButton), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      });

      testWidgets('should navigate back when back button is pressed', (
        WidgetTester tester,
      ) async {

        // Arrange - Create a custom navigator observer
        final mockObserver = NavigatorObserver();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              calorieTrackingProvider.overrideWith(
                (ref) => mockCalorieTrackingViewModel,
              ),
              foodSearchViewModelProvider.overrideWith(
                (ref) => mockFoodSearchViewModel,
              ),
            ],
            child: MaterialApp(
              navigatorObservers: [mockObserver],
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FoodSearchScreen(
                            mealType: testMealType,
                            selectedDate: testDate,
                          ),
                        ),
                      );
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              ),
            ),
          ),
        );

        // Navigate to FoodSearchScreen
        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        // Act - Tap back button
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        // Assert - Should be back to the previous screen
        expect(find.byType(FoodSearchScreen), findsNothing);
        expect(find.text('Navigate'), findsOneWidget);
      });
    });

    group('Body Structure Tests', () {
      testWidgets('should have correct scaffold background color', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createFoodSearchScreen());

        // Assert
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, Colors.white);
      });

      testWidgets('should display Column with correct children', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createFoodSearchScreen());

        // Assert
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(FoodSearchSearchBar), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.byType(FoodSearchBody), findsOneWidget);
      });

      testWidgets('should display FoodSearchSearchBar', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createFoodSearchScreen());

        // Assert
        expect(find.byType(FoodSearchSearchBar), findsOneWidget);
      });

      testWidgets('should display FoodSearchBody with correct parameters', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createFoodSearchScreen());

        // Assert
        expect(find.byType(FoodSearchBody), findsOneWidget);

        final foodSearchBody = tester.widget<FoodSearchBody>(
          find.byType(FoodSearchBody),
        );
        expect(foodSearchBody.mealType, testMealType);
        expect(foodSearchBody.selectedDate, testDate);
      });

      testWidgets(
        'should pass correct parameters to FoodSearchBody for different inputs',
        (WidgetTester tester) async {
          const snackMealType = 'Snack';
          final customDate = DateTime(2024, 7, 10);

          // Act
          await tester.pumpWidget(
            createFoodSearchScreen(
              mealType: snackMealType,
              selectedDate: customDate,
            ),
          );

          // Assert
          final foodSearchBody = tester.widget<FoodSearchBody>(
            find.byType(FoodSearchBody),
          );
          expect(foodSearchBody.mealType, snackMealType);
          expect(foodSearchBody.selectedDate, customDate);
        },
      );
    });

    group('Search Functionality Tests', () {
      testWidgets('should call searchFoods when search is submitted', (
        WidgetTester tester,
      ) async {
        const searchQuery = 'apple';

        // Act
        await tester.pumpWidget(createFoodSearchScreen());

        // Find the search bar and simulate onSubmitted
        final searchBar = tester.widget<FoodSearchSearchBar>(
          find.byType(FoodSearchSearchBar),
        );
        searchBar.onSubmitted(searchQuery);

        // Assert
        verify(mockFoodSearchViewModel.searchFoods(searchQuery)).called(1);
      });

      testWidgets('should call searchFoods with different queries', (
        WidgetTester tester,
      ) async {
        const queries = ['banana', 'chicken breast', 'rice'];

        // Act
        await tester.pumpWidget(createFoodSearchScreen());

        final searchBar = tester.widget<FoodSearchSearchBar>(
          find.byType(FoodSearchSearchBar),
        );

        for (final query in queries) {
          searchBar.onSubmitted(query);
        }

        // Assert
        for (final query in queries) {
          verify(mockFoodSearchViewModel.searchFoods(query)).called(1);
        }
      });

      testWidgets('should handle empty search query', (
        WidgetTester tester,
      ) async {
        const emptyQuery = '';

        // Act
        await tester.pumpWidget(createFoodSearchScreen());

        final searchBar = tester.widget<FoodSearchSearchBar>(
          find.byType(FoodSearchSearchBar),
        );
        searchBar.onSubmitted(emptyQuery);

        // Assert
        verify(mockFoodSearchViewModel.searchFoods(emptyQuery)).called(1);
      });
    });

    group('Layout Tests', () {
      testWidgets('should have FoodSearchBody in Expanded widget', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createFoodSearchScreen());

        // Assert
        final expanded = tester.widget<Expanded>(find.byType(Expanded));
        expect(expanded.child, isA<FoodSearchBody>());
      });

      testWidgets('should maintain correct widget hierarchy', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createFoodSearchScreen());

        // Assert - Check that Scaffold contains AppBar and body
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);

        // Check that body contains Column
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.body, isA<Column>());

        // Check Column children order
        final column = scaffold.body as Column;
        expect(column.children.length, 2);
        expect(column.children[0], isA<FoodSearchSearchBar>());
        expect(column.children[1], isA<Expanded>());
      });
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('should handle null or invalid meal type gracefully', (
        WidgetTester tester,
      ) async {
        const emptyMealType = '';

        // Act
        await tester.pumpWidget(
          createFoodSearchScreen(mealType: emptyMealType),
        );
        await tester.pumpAndSettle();

        // Assert
        verify(
          mockCalorieTrackingViewModel.setSelectedMealType(emptyMealType),
        ).called(1);

        final customText = tester.widget<CustomText>(find.byType(CustomText));
        expect(customText.label, 'Add to $emptyMealType');
      });

      testWidgets('should handle past dates', (WidgetTester tester) async {
        final pastDate = DateTime(2020, 1, 1);

        // Act
        await tester.pumpWidget(createFoodSearchScreen(selectedDate: pastDate));
        await tester.pumpAndSettle();

        // Assert
        verify(
          mockCalorieTrackingViewModel.setSelectedDate(pastDate),
        ).called(1);

        final foodSearchBody = tester.widget<FoodSearchBody>(
          find.byType(FoodSearchBody),
        );
        expect(foodSearchBody.selectedDate, pastDate);
      });

      testWidgets('should handle future dates', (WidgetTester tester) async {
        final futureDate = DateTime(2030, 12, 31);

        // Act
        await tester.pumpWidget(
          createFoodSearchScreen(selectedDate: futureDate),
        );
        await tester.pumpAndSettle();

        // Assert
        verify(
          mockCalorieTrackingViewModel.setSelectedDate(futureDate),
        ).called(1);

        final foodSearchBody = tester.widget<FoodSearchBody>(
          find.byType(FoodSearchBody),
        );
        expect(foodSearchBody.selectedDate, futureDate);
      });

      testWidgets('should rebuild correctly when parameters change', (
        WidgetTester tester,
      ) async {
        // Initial build
        await tester.pumpWidget(createFoodSearchScreen());
        await tester.pumpAndSettle();

        // Change parameters and rebuild
        const newMealType = 'Lunch';
        final newDate = DateTime(2024, 6, 15);

        await tester.pumpWidget(
          createFoodSearchScreen(mealType: newMealType, selectedDate: newDate),
        );
        await tester.pumpAndSettle();

        // Assert new parameters are used
        final customText = tester.widget<CustomText>(find.byType(CustomText));
        expect(customText.label, 'Add to $newMealType');

        final foodSearchBody = tester.widget<FoodSearchBody>(
          find.byType(FoodSearchBody),
        );
        expect(foodSearchBody.mealType, newMealType);
        expect(foodSearchBody.selectedDate, newDate);
      });
    });

    group('Integration Tests', () {
      testWidgets('should maintain state during widget lifecycle', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createFoodSearchScreen());
        await tester.pumpAndSettle();

        // Pump again to simulate rebuild
        await tester.pump();

        // Assert that initialization only happens once
        verify(
          mockCalorieTrackingViewModel.setSelectedMealType(testMealType),
        ).called(1);
        verify(
          mockCalorieTrackingViewModel.setSelectedDate(testDate),
        ).called(1);
      });

      testWidgets('should work with all meal types', (
        WidgetTester tester,
      ) async {
        final mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

        for (final mealType in mealTypes) {
          // Clear previous interactions
          reset(mockCalorieTrackingViewModel);

          await tester.pumpWidget(createFoodSearchScreen(mealType: mealType));
          await tester.pumpAndSettle();

          // Assert correct meal type is set
          verify(
            mockCalorieTrackingViewModel.setSelectedMealType(mealType),
          ).called(1);

          // Assert correct title is displayed
          final customText = tester.widget<CustomText>(find.byType(CustomText));
          expect(customText.label, 'Add to $mealType');
        }
      });
    });
  });
}
