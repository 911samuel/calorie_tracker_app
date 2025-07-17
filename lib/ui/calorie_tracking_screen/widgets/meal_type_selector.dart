import 'package:calorie_tracker_app/domain/models/meal_type.dart';
import 'package:flutter/material.dart';

class MealTypeSelector extends StatelessWidget {
  final String selectedMealType;
  final Function(String) onMealTypeChanged;

  const MealTypeSelector({
    super.key,
    required this.selectedMealType,
    required this.onMealTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: MealType.all.length,
        itemBuilder: (context, index) {
          final mealType = MealType.all[index];
          final isSelected = mealType == selectedMealType;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(mealType.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onMealTypeChanged(mealType);
                }
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          );
        },
      ),
    );
  }
}
