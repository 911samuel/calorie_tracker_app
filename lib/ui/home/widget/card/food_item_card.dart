import 'package:calorie_tracker_app/domain/models/enums/nutrition_card_types.dart';
import 'package:calorie_tracker_app/domain/models/nutrition_data.dart';
import 'package:calorie_tracker_app/ui/home/widget/card/base_nutrition_card.dart';
import 'package:calorie_tracker_app/ui/home/widget/card/nutrition_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:calorie_tracker_app/core/theme/app_colors.dart';

class FoodItemCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imagePath;
  final NutritionData? nutritionData;
  final VoidCallback? onRemove;

  const FoodItemCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imagePath,
    this.nutritionData,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return BaseNutritionCard(
      type: NutritionCardType.foodItem,
      title: title,
      subtitle: subtitle,
      imagePath: imagePath,
      nutritionData: nutritionData,
      onRemove: onRemove,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NutritionCardWidgets.buildFoodImage(imagePath, 50),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                  if (nutritionData != null) ...[
                    const SizedBox(height: 6),
                    NutritionCardWidgets.buildNutritionRow(
                      nutritionData!.carbs,
                      nutritionData!.protein,
                      nutritionData!.fat,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (onRemove != null)
              IconButton(
                onPressed: onRemove,
                icon: const Icon(
                  Icons.close,
                  color: AppColors.textGray,
                  size: 20,
                ),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
          ],
        ),
      ),
    );
  }
}
