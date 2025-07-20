import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:calorie_tracker_app/domain/use_cases/calculate_nutrients_usecase.dart';
import 'package:calorie_tracker_app/data/services/shared_prefs_service.dart';
import 'package:calorie_tracker_app/domain/models/user.dart';

// Generate mocks using mockito's annotation
@GenerateMocks([SharedPrefsService])
import 'calculate_nutrients_usecase_test.mocks.dart';

void main() {
  group('CalculateMealNutrients', () {
    late MockSharedPrefsService mockPrefsService;
    late CalculateMealNutrients useCase;

    setUp(() {
      mockPrefsService = MockSharedPrefsService();
      useCase = CalculateMealNutrients(mockPrefsService);
    });

    tearDown(() {
      // Reset mocks after each test
      reset(mockPrefsService);
    });

    test('returns null when user is null', () async {
      // Setup mock response BEFORE calling the method
      when(mockPrefsService.loadUser()).thenAnswer((_) async => null);

      final result = await useCase.call();

      expect(result, isNull);
      verify(mockPrefsService.loadUser()).called(1);
    });

    test(
      'calculates correct nutrient goals for male user with medium activity and keep goal',
      () async {
        final user = User(
          gender: Gender.male,
          weight: 70,
          height: 175,
          age: 30,
          activityLevel: ActivityLevel.medium,
          goal: Goal.keep,
          carbPercentage: 40,
          proteinPercentage: 30,
          fatPercentage: 30,
        );

        // Setup mock response BEFORE calling the method
        when(mockPrefsService.loadUser()).thenAnswer((_) async => user);

        final result = await useCase.call();

        // Calculate expected BMR and goals manually
        final bmr = 66.47 + 13.75 * 70 + 5 * 175 - 6.75 * 30;
        final activityFactor = 1.3;
        final goalCalories = (bmr * activityFactor).round();

        final carbsGoal = (goalCalories * 0.4 / 4).round();
        final proteinGoal = (goalCalories * 0.3 / 4).round();
        final fatGoal = (goalCalories * 0.3 / 9).round();

        expect(result, isNotNull);
        expect(result!.caloriesGoal, goalCalories);
        expect(result.carbsGoal, carbsGoal);
        expect(result.proteinGoal, proteinGoal);
        expect(result.fatGoal, fatGoal);
        verify(mockPrefsService.loadUser()).called(1);
      },
    );

    test(
      'calculates correct nutrient goals for female user with high activity and gain goal',
      () async {
        final user = User(
          gender: Gender.female,
          weight: 60,
          height: 165,
          age: 25,
          activityLevel: ActivityLevel.high,
          goal: Goal.gain,
          carbPercentage: 50,
          proteinPercentage: 20,
          fatPercentage: 30,
        );

        // Setup mock response BEFORE calling the method
        when(mockPrefsService.loadUser()).thenAnswer((_) async => user);

        final result = await useCase.call();

        final bmr = 665.09 + 9.56 * 60 + 1.84 * 165 - 4.67 * 25;
        final activityFactor = 1.4;
        final goalCalories = (bmr * activityFactor + 500).round();

        final totalPercentage = 0.5 + 0.2 + 0.3;
        final carbsPercentage = 0.5 / totalPercentage;
        final proteinPercentage = 0.2 / totalPercentage;
        final fatPercentage = 0.3 / totalPercentage;

        final carbsGoal = (goalCalories * carbsPercentage / 4).round();
        final proteinGoal = (goalCalories * proteinPercentage / 4).round();
        final fatGoal = (goalCalories * fatPercentage / 9).round();

        expect(result, isNotNull);
        expect(result!.caloriesGoal, goalCalories);
        expect(result.carbsGoal, carbsGoal);
        expect(result.proteinGoal, proteinGoal);
        expect(result.fatGoal, fatGoal);
        verify(mockPrefsService.loadUser()).called(1);
      },
    );

    test(
      'uses default macro percentages when user percentages are null or zero',
      () async {
        final user = User(
          gender: Gender.male,
          weight: 80,
          height: 180,
          age: 40,
          activityLevel: ActivityLevel.low,
          goal: Goal.lose,
          carbPercentage: 0,
          proteinPercentage: 0,
          fatPercentage: 0,
        );

        // Setup mock response BEFORE calling the method
        when(mockPrefsService.loadUser()).thenAnswer((_) async => user);

        final result = await useCase.call();

        final bmr = 66.47 + 13.75 * 80 + 5 * 180 - 6.75 * 40;
        final activityFactor = 1.2;
        final goalCalories = (bmr * activityFactor - 500).round();

        final carbsGoal = (goalCalories * 0.4 / 4).round();
        final proteinGoal = (goalCalories * 0.3 / 4).round();
        final fatGoal = (goalCalories * 0.3 / 9).round();

        expect(result, isNotNull);
        expect(result!.caloriesGoal, goalCalories);
        expect(result.carbsGoal, carbsGoal);
        expect(result.proteinGoal, proteinGoal);
        expect(result.fatGoal, fatGoal);
        verify(mockPrefsService.loadUser()).called(1);
      },
    );
  });
}
