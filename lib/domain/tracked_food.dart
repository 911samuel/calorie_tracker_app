class TrackedFood {
  final int? id; // optional, since it will be auto-generated in SQLite
  final String name;
  final double amount; // in grams
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime date;
  final String mealType; // breakfast, lunch, etc.
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
}
