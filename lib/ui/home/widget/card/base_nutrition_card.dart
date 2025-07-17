import 'package:calorie_tracker_app/domain/models/enums/nutrition_card_types.dart';
import 'package:calorie_tracker_app/domain/models/food_item.dart';
import 'package:calorie_tracker_app/domain/models/nutrition_data.dart';
import 'package:flutter/material.dart';
import 'package:calorie_tracker_app/core/theme/app_colors.dart';

/// Base widget for all nutrition cards with common styling
class BaseNutritionCard extends StatelessWidget {
  final NutritionCardType type;
  final String title;
  final String? subtitle;
  final String? imagePath;
  final IconData? icon;
  final NutritionData? nutritionData;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final Function(String)? onInputChanged;
  final Function(String)? onInputSubmitted;
  final Function()? onSave;
  final bool isExpanded;
  final List<String>? dropdownItems;
  final List<FoodItem>? foodItems;
  final Function(String)? onDropdownChanged;
  final Function(FoodItem)? onFoodItemRemoved;
  final String? inputHint;
  final String? inputSuffix;
  final String? nutritionInfo;
  final String? caloriesPerServing;
  final Widget child;

  const BaseNutritionCard({
    super.key,
    required this.type,
    required this.title,
    required this.child,
    this.subtitle,
    this.imagePath,
    this.icon,
    this.nutritionData,
    this.onTap,
    this.onRemove,
    this.onInputChanged,
    this.onInputSubmitted,
    this.onSave,
    this.isExpanded = false,
    this.dropdownItems,
    this.foodItems,
    this.onDropdownChanged,
    this.onFoodItemRemoved,
    this.inputHint,
    this.inputSuffix,
    this.nutritionInfo,
    this.caloriesPerServing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
