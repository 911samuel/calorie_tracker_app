import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/domain/user.dart';
import 'package:calorie_tracker_app/domain/usecases/calculate_bmr.dart';

void main() {
  group('CalculateBMR', () {
    final calculateBMR = CalculateBMR();

    test('calculates BMR for male correctly', () {
      final user = User(
        gender: Gender.male,
        age: 25,
        height: 180,
        weight: 75,
        activityLevel: ActivityLevel.medium,
        goal: Goal.keep,
        carbPercentage: 40,
        proteinPercentage: 30,
        fatPercentage: 30,
      );

      final bmr = calculateBMR.call(user);
      expect(bmr, closeTo(1771.5, 1.0));
    });

    test('calculates BMR for female correctly', () {
      final user = User(
        gender: Gender.female,
        age: 30,
        height: 165,
        weight: 60,
        activityLevel: ActivityLevel.low,
        goal: Goal.lose,
        carbPercentage: 40,
        proteinPercentage: 30,
        fatPercentage: 30,
      );

      final bmr = calculateBMR.call(user);
      expect(bmr, closeTo(1399.5, 1.0));
    });

    test('calculates BMR for other gender as average', () {
      final user = User(
        gender: Gender.other,
        age: 28,
        height: 170,
        weight: 65,
        activityLevel: ActivityLevel.high,
        goal: Goal.gain,
        carbPercentage: 40,
        proteinPercentage: 30,
        fatPercentage: 30,
      );

      final bmr = calculateBMR.call(user);
      final maleBMR = 88.362 + (13.397 * 65) + (4.799 * 170) - (5.677 * 28);
      final femaleBMR = 447.593 + (9.247 * 65) + (3.098 * 170) - (4.330 * 28);
      final expected = (maleBMR + femaleBMR) / 2;

      expect(bmr, closeTo(expected, 1.0));
    });
  });
}
