enum Gender {
  male,
  female,
  other,
}

enum ActivityLevel {
  low,
  medium,
  high,
}

enum Goal {
  lose,
  keep,
  gain,
}

class User {
  final Gender gender;
  final int age;
  final double height; // in cm
  final double weight; // in kg
  final ActivityLevel activityLevel;
  final Goal goal;
  final double carbPercentage;
  final double proteinPercentage;
  final double fatPercentage;

  User({
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.activityLevel,
    required this.goal,
    required this.carbPercentage,
    required this.proteinPercentage,
    required this.fatPercentage,
  });
}
