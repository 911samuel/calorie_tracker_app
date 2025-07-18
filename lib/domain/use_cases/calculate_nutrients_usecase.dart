import '../../data/services/shared_prefs_service.dart';
import '../models/user.dart';

class CalculateMealNutrients {
  final SharedPrefsService prefsService;

  CalculateMealNutrients(this.prefsService);

  Future<NutrientGoalResult?> call() async {
    final user = await prefsService.loadUser();
    if (user == null) return null;

    final weight = user.weight ?? 0;
    final height = user.height ?? 0;
    final age = user.age ?? 0;

    // Calculate BMR based on gender
    final bmr = (user.gender == Gender.male)
        ? (66.47 + 13.75 * weight + 5 * height - 6.75 * age)
        : (665.09 + 9.56 * weight + 1.84 * height - 4.67 * age);

    // Activity factor
    final activityFactor = switch (user.activityLevel) {
      ActivityLevel.low => 1.2,
      ActivityLevel.medium => 1.3,
      ActivityLevel.high => 1.4,
      _ => 1.2,
    };

    // Goal calorie adjustment
    final goalCalories = switch (user.goal) {
      Goal.lose => -500,
      Goal.keep => 0,
      Goal.gain => 500,
      _ => 0,
    };

    final caloriesGoal = (bmr * activityFactor + goalCalories).round();

    // Safely parse percentages, assuming input may be 0-100 or null
    double carbsPercentage = ((user.carbPercentage ?? 40) / 100).clamp(
      0.0,
      1.0,
    );
    double proteinPercentage = ((user.proteinPercentage ?? 30) / 100).clamp(
      0.0,
      1.0,
    );
    double fatPercentage = ((user.fatPercentage ?? 30) / 100).clamp(0.0, 1.0);

    final totalPercentage = carbsPercentage + proteinPercentage + fatPercentage;

    // Fallback if percentages sum to zero or invalid
    if (totalPercentage == 0) {
      carbsPercentage = 0.4;
      proteinPercentage = 0.3;
      fatPercentage = 0.3;
    } else {
      // Normalize to 1.0 total if needed (optional but better)
      carbsPercentage /= totalPercentage;
      proteinPercentage /= totalPercentage;
      fatPercentage /= totalPercentage;
    }

    final carbsGoal = (caloriesGoal * carbsPercentage / 4).round();
    final proteinGoal = (caloriesGoal * proteinPercentage / 4).round();
    final fatGoal = (caloriesGoal * fatPercentage / 9).round();

    return NutrientGoalResult(
      caloriesGoal: caloriesGoal,
      carbsGoal: carbsGoal,
      proteinGoal: proteinGoal,
      fatGoal: fatGoal,
    );
  }
}

class NutrientGoalResult {
  final int caloriesGoal;
  final int carbsGoal;
  final int proteinGoal;
  final int fatGoal;

  NutrientGoalResult({
    required this.caloriesGoal,
    required this.carbsGoal,
    required this.proteinGoal,
    required this.fatGoal,
  });
}
