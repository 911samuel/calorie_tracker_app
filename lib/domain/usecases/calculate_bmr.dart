import '../user.dart';

class CalculateBMR {
  double call(User user) {
    // Harris-Benedict formula
    if (user.gender == Gender.male) {
      return 88.362 +
          (13.397 * user.weight) +
          (4.799 * user.height) -
          (5.677 * user.age);
    } else if (user.gender == Gender.female) {
      return 447.593 +
          (9.247 * user.weight) +
          (3.098 * user.height) -
          (4.330 * user.age);
    } else {
      // For other gender, average of male and female formulas
      double maleBMR = 88.362 +
          (13.397 * user.weight) +
          (4.799 * user.height) -
          (5.677 * user.age);
      double femaleBMR = 447.593 +
          (9.247 * user.weight) +
          (3.098 * user.height) -
          (4.330 * user.age);
      return (maleBMR + femaleBMR) / 2;
    }
  }
}
