enum Gender { male, female, other }

enum ActivityLevel { low, medium, high }

enum Goal { lose, keep, gain }

class User {
  final Gender? gender;
  final int? age;
  final double? height; // in cm
  final double? weight; // in kg
  final ActivityLevel? activityLevel;
  final Goal? goal;
  final double? carbPercentage;
  final double? proteinPercentage;
  final double? fatPercentage;

  User({
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.activityLevel,
    this.goal,
    this.carbPercentage,
    this.proteinPercentage,
    this.fatPercentage,
  });

  User copyWith({
    Gender? gender,
    int? age,
    double? height,
    double? weight,
    ActivityLevel? activityLevel,
    Goal? goal,
    double? carbPercentage,
    double? proteinPercentage,
    double? fatPercentage,
  }) {
    return User(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      carbPercentage: carbPercentage ?? this.carbPercentage,
      proteinPercentage: proteinPercentage ?? this.proteinPercentage,
      fatPercentage: fatPercentage ?? this.fatPercentage,
    );
  }
}
