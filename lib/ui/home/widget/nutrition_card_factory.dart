import 'package:calorie_tracker_app/domain/models/enums/nutrition_card_types.dart';
import 'package:calorie_tracker_app/domain/models/food_item.dart';
import 'package:calorie_tracker_app/domain/models/nutrition_data.dart';
import 'package:calorie_tracker_app/ui/home/widget/card/add_button_card.dart';
import 'package:calorie_tracker_app/ui/home/widget/card/food_item_card.dart';
import 'package:calorie_tracker_app/ui/home/widget/card/input_field_card.dart';
import 'package:calorie_tracker_app/ui/home/widget/card/meal_selector_card.dart';
import 'package:calorie_tracker_app/ui/home/widget/card/search_result_card.dart';
import 'package:flutter/material.dart';

/// Factory class to create different types of nutrition cards
class NutritionCardFactory {
  static Widget create({
    required NutritionCardType type,
    required String title,
    String? subtitle,
    String? imagePath,
    IconData? icon,
    NutritionData? nutritionData,
    VoidCallback? onTap,
    VoidCallback? onRemove,
    Function(String)? onInputChanged,
    Function(String)? onInputSubmitted,
    Function()? onSave,
    bool isExpanded = false,
    List<String>? dropdownItems,
    List<FoodItem>? foodItems,
    Function(String)? onDropdownChanged,
    Function(FoodItem)? onFoodItemRemoved,
    String? inputHint,
    String? inputSuffix,
    String? nutritionInfo,
    String? caloriesPerServing,
  }) {
    switch (type) {
      case NutritionCardType.searchResult:
        return SearchResultCard(
          title: title,
          imagePath: imagePath,
          nutritionData: nutritionData,
          onInputChanged: onInputChanged,
          onInputSubmitted: onInputSubmitted,
          onSave: onSave,
        );

      case NutritionCardType.mealSelector:
        return MealSelectorCard(
          title: title,
          imagePath: imagePath,
          icon: icon,
          nutritionData: nutritionData,
          onTap: onTap,
          isExpanded: isExpanded,
          foodItems: foodItems,
          onFoodItemRemoved: onFoodItemRemoved,
          onInputChanged: onInputChanged,
          onInputSubmitted: onInputSubmitted,
          onSave: onSave,
        );

      case NutritionCardType.foodItem:
        return FoodItemCard(
          title: title,
          subtitle: subtitle,
          imagePath: imagePath,
          nutritionData: nutritionData,
          onRemove: onRemove,
        );

      case NutritionCardType.addButton:
        return AddButtonCard(title: title, onTap: onTap);

      case NutritionCardType.inputField:
        return InputFieldCard(
          title: title,
          imagePath: imagePath,
          nutritionData: nutritionData,
          nutritionInfo: nutritionInfo,
          onInputChanged: onInputChanged,
          onInputSubmitted: onInputSubmitted,
          onSave: onSave,
        );
    }
  }
}
