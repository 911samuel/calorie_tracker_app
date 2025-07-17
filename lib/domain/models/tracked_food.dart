import 'package:calorie_tracker_app/domain/models/food.dart';

class TrackedFood {
  final int? id;
  final String name;
  final double amount; // in grams
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime date;
  final String mealType;
  final String? imageUrl;

  TrackedFood({
    this.id,
    required this.name,
    required this.amount,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.date,
    required this.mealType,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'date': date.toIso8601String(),
      'mealType': mealType,
      'imageUrl': imageUrl,
    };
  }

  factory TrackedFood.fromMap(Map<String, dynamic> map) {
    return TrackedFood(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      calories: map['calories'],
      protein: map['protein'],
      carbs: map['carbs'],
      fat: map['fat'],
      date: DateTime.parse(map['date']),
      mealType: map['mealType'],
      imageUrl: map['imageUrl'],
    );
  }

  // Helper method to calculate nutritional values based on amount
  static TrackedFood fromFood(
    Food food,
    double amount,
    DateTime date,
    String mealType,
  ) {
    final ratio = amount / 100; // Convert from per 100g to actual amount
    return TrackedFood(
      name: food.name,
      amount: amount,
      calories: (food.caloriesPer100g * ratio).round(),
      protein: food.proteinPer100g * ratio,
      carbs: food.carbsPer100g * ratio,
      fat: food.fatPer100g * ratio,
      date: date,
      mealType: mealType,
      imageUrl: food.imageUrl,
    );
  }
}
