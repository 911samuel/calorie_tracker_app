import 'package:calorie_tracker_app/domain/models/enums/nutrition_card_types.dart';
import 'package:calorie_tracker_app/domain/models/nutrition_data.dart';
import 'package:calorie_tracker_app/ui/home/widget/card/base_nutrition_card.dart';
import 'package:calorie_tracker_app/ui/home/widget/card/nutrition_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:calorie_tracker_app/core/theme/app_colors.dart';

class SearchResultCard extends StatefulWidget {
  final String title;
  final String? imagePath;
  final NutritionData? nutritionData;
  final Function(String)? onInputChanged;
  final Function(String)? onInputSubmitted;
  final Function()? onSave;

  const SearchResultCard({
    super.key,
    required this.title,
    this.imagePath,
    this.nutritionData,
    this.onInputChanged,
    this.onInputSubmitted,
    this.onSave,
  });

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  final TextEditingController _controller = TextEditingController();
  bool _showInputField = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseNutritionCard(
      type: NutritionCardType.searchResult,
      title: widget.title,
      imagePath: widget.imagePath,
      nutritionData: widget.nutritionData,
      onInputChanged: widget.onInputChanged,
      onInputSubmitted: widget.onInputSubmitted,
      onSave: widget.onSave,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _showInputField = !_showInputField;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Food image
                  NutritionCardWidgets.buildFoodImage(widget.imagePath, 60),
                  const SizedBox(width: 16),
                  // Main content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Food name
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBlack,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Weight and calories row
                        if (widget.nutritionData != null) ...[
                          Row(
                            children: [
                              Text(
                                widget.nutritionData!.weight ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textGray,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.nutritionData!.calories}kcal',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '/ 100g',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textGray,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Nutrition info row with labels below values
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${widget.nutritionData!.carbs.toInt()}g',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Carbs',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${widget.nutritionData!.protein.toInt()}g',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Protein',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${widget.nutritionData!.fat.toInt()}g',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Fat',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showInputField) ...[
            const Divider(height: 1, color: AppColors.disabled),
            Padding(
              padding: const EdgeInsets.all(16),
              child: NutritionCardWidgets.buildInputRow(
                controller: _controller,
                onSave: widget.onSave ?? () {},
                onInputChanged: widget.onInputChanged,
                onInputSubmitted: widget.onInputSubmitted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
