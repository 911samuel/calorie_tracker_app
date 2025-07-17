import 'package:calorie_tracker_app/domain/models/enums/nutrition_card_types.dart';
import 'package:calorie_tracker_app/domain/models/food_item.dart';
import 'package:calorie_tracker_app/domain/models/nutrition_data.dart';
import 'package:calorie_tracker_app/ui/home/widget/nutrition_card_factory.dart';
import 'package:flutter/material.dart';

/// Main nutrition card widget that uses factory pattern to create different card types
class NutritionCard extends StatelessWidget {
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

  const NutritionCard({
    super.key,
    required this.type,
    required this.title,
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
    return NutritionCardFactory.create(
      type: type,
      title: title,
      subtitle: subtitle,
      imagePath: imagePath,
      icon: icon,
      nutritionData: nutritionData,
      onTap: onTap,
      onRemove: onRemove,
      onInputChanged: onInputChanged,
      onInputSubmitted: onInputSubmitted,
      onSave: onSave,
      isExpanded: isExpanded,
      dropdownItems: dropdownItems,
      foodItems: foodItems,
      onDropdownChanged: onDropdownChanged,
      onFoodItemRemoved: onFoodItemRemoved,
      inputHint: inputHint,
      inputSuffix: inputSuffix,
      nutritionInfo: nutritionInfo,
      caloriesPerServing: caloriesPerServing,
    );
  }
}
