class NutritionData {
  final int calories;
  final double carbs;
  final double protein;
  final double fat;
  final String? weight;

  NutritionData({
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.weight,
  });

  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      calories: json['calories'] ?? 0,
      carbs: (json['carbs'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'weight': weight,
    };
  }

  NutritionData copyWith({
    int? calories,
    double? carbs,
    double? protein,
    double? fat,
    String? weight,
  }) {
    return NutritionData(
      calories: calories ?? this.calories,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      weight: weight ?? this.weight,
    );
  }
}
