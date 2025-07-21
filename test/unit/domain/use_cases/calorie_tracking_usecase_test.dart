import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:calorie_tracker_app/domain/use_cases/calorie_tracking_usecase.dart';
import 'package:calorie_tracker_app/domain/models/food.dart';
import 'package:calorie_tracker_app/domain/models/tracked_food.dart';
import 'package:calorie_tracker_app/domain/models/daily_summary.dart';
import 'package:calorie_tracker_app/data/repository/tracked_food_repository.dart';

import 'calorie_tracking_usecase_test.mocks.dart';

@GenerateMocks([ITrackedFoodRepository])
void main() {
  group('CalorieTrackingUseCase', () {
    late MockITrackedFoodRepository mockRepository;
    late CalorieTrackingUseCase useCase;

    setUp(() {
      mockRepository = MockITrackedFoodRepository();
      useCase = CalorieTrackingUseCase(repository: mockRepository);
    });

    test(
      'addFoodToMeal calls repository.addTrackedFood with correct TrackedFood',
      () async {
        final food = Food(
          id: '2',
          name: 'Banana',
          caloriesPer100g: 89,
          proteinPer100g: 1.1,
          carbsPer100g: 23,
          fatPer100g: 0.3,
        );
        final amount = 150.0;
        final date = DateTime(2023, 1, 1);
        final mealType = 'breakfast';

        await useCase.addFoodToMeal(
          food: food,
          amount: amount,
          date: date,
          mealType: mealType,
        );

        verify(
          mockRepository.addTrackedFood(
            argThat(
              isA<TrackedFood>()
                  .having((f) => f.name, 'name', food.name)
                  .having((f) => f.amount, 'amount', amount)
                  .having((f) => f.date, 'date', date)
                  .having((f) => f.mealType, 'mealType', mealType),
            ),
          ),
        ).called(1);
      },
    );

    test(
      'removeFoodFromMeal calls repository.removeTrackedFood with correct id',
      () async {
        final trackedFoodId = 42;

        await useCase.removeFoodFromMeal(trackedFoodId);

        verify(mockRepository.removeTrackedFood(trackedFoodId)).called(1);
      },
    );

    test(
      'getMealFoods returns list from repository.getTrackedFoodsByDateAndMeal',
      () async {
        final date = DateTime(2023, 1, 2);
        final mealType = 'lunch';
        final trackedFoods = [
          TrackedFood(
            name: 'Apple',
            amount: 100,
            calories: 52,
            protein: 0,
            carbs: 14,
            fat: 0,
            date: date,
            mealType: mealType,
          ),
        ];

        when(
          mockRepository.getTrackedFoodsByDateAndMeal(date, mealType),
        ).thenAnswer((_) async => trackedFoods);

        final result = await useCase.getMealFoods(date, mealType);

        expect(result, trackedFoods);
      },
    );

    test(
      'getDailySummary returns summary from repository.getDailySummary',
      () async {
        final date = DateTime(2023, 1, 3);
        final summary = DailySummary(
          date: date,
          meals: [],
          totalCalories: 2000,
          totalProtein: 150,
          totalCarbs: 250,
          totalFat: 70,
        );

        when(
          mockRepository.getDailySummary(date),
        ).thenAnswer((_) async => summary);

        final result = await useCase.getDailySummary(date);

        expect(result, summary);
      },
    );

    test(
      'getAllTrackedFoods returns list from repository.getAllTrackedFoods',
      () async {
        final trackedFoods = [
          TrackedFood(
            name: 'Orange',
            amount: 120,
            calories: 47,
            protein: 0.9,
            carbs: 12,
            fat: 0.1,
            date: DateTime(2023, 1, 4),
            mealType: 'snack',
          ),
        ];

        when(
          mockRepository.getAllTrackedFoods(),
        ).thenAnswer((_) async => trackedFoods);

        final result = await useCase.getAllTrackedFoods();

        expect(result, trackedFoods);
      },
    );
  });
}
