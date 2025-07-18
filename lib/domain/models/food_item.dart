class FoodItem {
  final String name;
  final String weight;
  final int calories;
  final double carbs;
  final double protein;
  final double fat;
  final String? imagePath;

  FoodItem({
    required this.name,
    required this.weight,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.imagePath,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] ?? '',
      weight: json['weight'] ?? '',
      calories: json['calories'] ?? 0,
      carbs: (json['carbs'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weight': weight,
      'calories': calories,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'imagePath': imagePath,
    };
  }

  FoodItem copyWith({
    String? name,
    String? weight,
    int? calories,
    double? carbs,
    double? protein,
    double? fat,
    String? imagePath,
  }) {
    return FoodItem(
      name: name ?? this.name,
      weight: weight ?? this.weight,
      calories: calories ?? this.calories,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
