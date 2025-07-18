import 'gender.dart';
import 'activity_level.dart';
import 'goal_type.dart';

class UserInfo {
  final Gender gender;
  final int age;
  final double weight;
  final int height;
  final ActivityLevel activityLevel;
  final GoalType goalType;
  final double carbRatio;
  final double proteinRatio;
  final double fatRatio;

  const UserInfo({
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.goalType,
    required this.carbRatio,
    required this.proteinRatio,
    required this.fatRatio,
  });
}
