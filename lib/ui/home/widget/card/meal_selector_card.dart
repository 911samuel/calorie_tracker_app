import 'package:calorie_tracker_app/domain/models/enums/nutrition_card_types.dart';
import 'package:calorie_tracker_app/domain/models/food_item.dart';
import 'package:calorie_tracker_app/domain/models/nutrition_data.dart';
import 'package:calorie_tracker_app/ui/home/widget/card/base_nutrition_card.dart';
import 'package:calorie_tracker_app/ui/home/widget/card/nutrition_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:calorie_tracker_app/core/theme/app_colors.dart';
import 'package:calorie_tracker_app/core/ui/button.dart';

class MealSelectorCard extends StatefulWidget {
  final String title;
  final String? imagePath;
  final IconData? icon;
  final NutritionData? nutritionData;
  final VoidCallback? onTap;
  final bool isExpanded;
  final List<FoodItem>? foodItems;
  final Function(FoodItem)? onFoodItemRemoved;
  final Function(String)? onInputChanged;
  final Function(String)? onInputSubmitted;
  final Function()? onSave;

  const MealSelectorCard({
    super.key,
    required this.title,
    this.imagePath,
    this.icon,
    this.nutritionData,
    this.onTap,
    this.isExpanded = false,
    this.foodItems,
    this.onFoodItemRemoved,
    this.onInputChanged,
    this.onInputSubmitted,
    this.onSave,
  });

  @override
  State<MealSelectorCard> createState() => _MealSelectorCardState();
}

class _MealSelectorCardState extends State<MealSelectorCard> {
  final TextEditingController _controller = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseNutritionCard(
      type: NutritionCardType.mealSelector,
      title: widget.title,
      imagePath: widget.imagePath,
      icon: widget.icon,
      nutritionData: widget.nutritionData,
      onTap: widget.onTap,
      isExpanded: _isExpanded,
      foodItems: widget.foodItems,
      onFoodItemRemoved: widget.onFoodItemRemoved,
      onInputChanged: widget.onInputChanged,
      onInputSubmitted: widget.onInputSubmitted,
      onSave: widget.onSave,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  NutritionCardWidgets.buildFoodImage(widget.imagePath, 80),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                          ),
                        ),
                        if (widget.nutritionData != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '${widget.nutritionData!.calories}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'kcal',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textGray,
                                ),
                              ),
                              const Spacer(),
                              NutritionCardWidgets.buildNutritionSummaryRow(
                                widget.nutritionData!.carbs,
                                widget.nutritionData!.protein,
                                widget.nutritionData!.fat,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textGray,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1, color: AppColors.disabled),
            _buildExpandedContent(),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      children: [
        if (widget.foodItems != null && widget.foodItems!.isNotEmpty) ...[
          ...widget.foodItems!.map(
            (foodItem) => _buildFoodItemInList(foodItem),
          ),
        ],
        Padding(
          padding: const EdgeInsets.all(16),
          child: CustomButton(
            text: 'Add ${widget.title}',
            icon: Icons.add,
            variant: ButtonVariant.outline,
            width: double.infinity,
            height: 48,
            onPressed: widget.onTap,
          ),
        ),
      ],
    );
  }

  Widget _buildFoodItemInList(FoodItem foodItem) {
    bool isCurrentItemExpanded =
        _isExpanded && _controller.text == foodItem.name;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !isCurrentItemExpanded;
              _controller.text = foodItem.name;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with consistent sizing
                NutritionCardWidgets.buildFoodImage(foodItem.imagePath, 50),
                const SizedBox(width: 12),
                // Info section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodItem.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${foodItem.weight} • ${foodItem.calories} kcal',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Nutrition column on the right
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    NutritionCardWidgets.buildNutritionRow(
                      foodItem.carbs,
                      foodItem.protein,
                      foodItem.fat,
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => widget.onFoodItemRemoved?.call(foodItem),
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: AppColors.textGray,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Input field on expand
        if (isCurrentItemExpanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: NutritionCardWidgets.buildInputRow(
              controller: _controller,
              onSave: widget.onSave ?? () {},
              onInputChanged: widget.onInputChanged,
              onInputSubmitted: widget.onInputSubmitted,
            ),
          ),
      ],
    );
  }
}
