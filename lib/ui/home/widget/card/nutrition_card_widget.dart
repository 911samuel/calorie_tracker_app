import 'package:flutter/material.dart';
import 'package:calorie_tracker_app/core/theme/app_colors.dart';
import 'package:calorie_tracker_app/core/ui/custom_text.dart';

/// Collection of helper widgets for nutrition cards
class NutritionCardWidgets {
  /// Builds a consistent food image widget
  static Widget buildFoodImage(String? imagePath, double size) {
    ImageProvider? imageProvider;

    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
        imageProvider = NetworkImage(imagePath);
      } else {
        imageProvider = AssetImage(imagePath);
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: imageProvider == null ? AppColors.disabled : Colors.transparent,
        image: imageProvider != null
            ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
            : null,
      ),
      child: imageProvider == null
          ? const Icon(Icons.fastfood, color: AppColors.textGray)
          : null,
    );
  }

  /// Builds a meal icon with gradient background
  static Widget buildMealIcon(IconData? icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon ?? Icons.restaurant,
        color: AppColors.lightBackground,
        size: 20,
      ),
    );
  }

  /// Builds a nutrition item display (value + label)
  static Widget buildNutritionItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textGray),
        ),
      ],
    );
  }

  /// Builds a smaller nutrition item for summary displays
  static Widget buildSmallNutritionItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 8, color: AppColors.textGray),
        ),
      ],
    );
  }

  /// Builds a horizontal row of nutrition information
  static Widget buildNutritionRow(double carbs, double protein, double fat) {
    return Row(
      children: [
        buildNutritionItem('${carbs.toInt()}g', 'Carbs'),
        const SizedBox(width: 16),
        buildNutritionItem('${protein.toInt()}g', 'Protein'),
        const SizedBox(width: 16),
        buildNutritionItem('${fat.toInt()}g', 'Fat'),
      ],
    );
  }

  /// Builds a summary row for nutrition info
  static Widget buildNutritionSummaryRow(
    double carbs,
    double protein,
    double fat,
  ) {
    return Row(
      children: [
        buildSmallNutritionItem('${carbs.toInt()}g', 'Carbs'),
        const SizedBox(width: 8),
        buildSmallNutritionItem('${protein.toInt()}g', 'Protein'),
        const SizedBox(width: 8),
        buildSmallNutritionItem('${fat.toInt()}g', 'Fat'),
      ],
    );
  }

  /// Builds an input row for weight input
  static Widget buildInputRow({
    required TextEditingController controller,
    required VoidCallback onSave,
    Function(String)? onInputChanged,
    Function(String)? onInputSubmitted,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IntrinsicWidth(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 120),
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.textLightGray,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.primaryNeon,
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                        ),
                        onChanged: onInputChanged,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: CustomText(label: 'g'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.primaryNeon),
            onPressed: () {
              onInputSubmitted?.call(controller.text);
              onSave();
            },
          ),
        ],
      ),
    );
  }
}
