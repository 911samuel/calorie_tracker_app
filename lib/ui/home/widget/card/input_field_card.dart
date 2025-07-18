import 'package:calorie_tracker_app/domain/models/enums/nutrition_card_types.dart';
import 'package:calorie_tracker_app/domain/models/nutrition_data.dart';
import 'package:calorie_tracker_app/ui/home/widget/card/base_nutrition_card.dart';
import 'package:calorie_tracker_app/ui/home/widget/card/nutrition_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:calorie_tracker_app/core/theme/app_colors.dart';

class InputFieldCard extends StatefulWidget {
  final String title;
  final String? imagePath;
  final NutritionData? nutritionData;
  final String? nutritionInfo;
  final Function(String)? onInputChanged;
  final Function(String)? onInputSubmitted;
  final Function()? onSave;

  const InputFieldCard({
    super.key,
    required this.title,
    this.imagePath,
    this.nutritionData,
    this.nutritionInfo,
    this.onInputChanged,
    this.onInputSubmitted,
    this.onSave,
  });

  @override
  State<InputFieldCard> createState() => _InputFieldCardState();
}

class _InputFieldCardState extends State<InputFieldCard> {
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
      type: NutritionCardType.inputField,
      title: widget.title,
      imagePath: widget.imagePath,
      nutritionData: widget.nutritionData,
      nutritionInfo: widget.nutritionInfo,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NutritionCardWidgets.buildFoodImage(widget.imagePath, 50),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBlack,
                          ),
                        ),
                        if (widget.nutritionInfo != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.nutritionInfo!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                        if (widget.nutritionData != null) ...[
                          const SizedBox(height: 6),
                          NutritionCardWidgets.buildNutritionRow(
                            widget.nutritionData!.carbs,
                            widget.nutritionData!.protein,
                            widget.nutritionData!.fat,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _showInputField
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textGray,
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
