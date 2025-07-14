import 'package:calorie_tracker_app/core/theme/app_colors.dart';
import 'package:calorie_tracker_app/core/ui/button.dart';
import 'package:calorie_tracker_app/core/ui/text_field.dart';
import 'package:flutter/material.dart';

enum NutritionCardType {
  mealSelector, // For breakfast/lunch/dinner with dropdown
  foodItem, // Individual food items with remove option
  addButton, // Add new item button
  inputField, // For manual nutrition input
}

class NutritionData {
  final int calories;
  final double carbs;
  final double protein;
  final double fat;
  final String? weight;

  NutritionData({
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.weight,
  });
}

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
}

class NutritionCard extends StatefulWidget {
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
  final bool isExpanded;
  final List<String>? dropdownItems;
  final List<FoodItem>? foodItems;
  final Function(String)? onDropdownChanged;
  final Function(FoodItem)? onFoodItemRemoved;
  final String? inputHint;
  final String? inputSuffix;
  final String? nutritionInfo;

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
    this.isExpanded = false,
    this.dropdownItems,
    this.foodItems,
    this.onDropdownChanged,
    this.onFoodItemRemoved,
    this.inputHint,
    this.inputSuffix,
    this.nutritionInfo,
  });

  @override
  State<NutritionCard> createState() => _NutritionCardState();
}

class _NutritionCardState extends State<NutritionCard> {
  final TextEditingController _controller = TextEditingController();
  bool _isExpanded = false;
  bool _showInputField = false;

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
      child: _buildCardContent(),
    );
  }

  Widget _buildCardContent() {
    switch (widget.type) {
      case NutritionCardType.mealSelector:
        return _buildMealSelectorCard();
      case NutritionCardType.foodItem:
        return _buildFoodItemCard();
      case NutritionCardType.addButton:
        return _buildAddButtonCard();
      case NutritionCardType.inputField:
        return _buildInputFieldCard();
    }
  }

  Widget _buildMealSelectorCard() {
    return Column(
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
                _buildMealIcon(),
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
                            _buildNutritionSummaryRow(),
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
                _buildFoodImage(foodItem.imagePath, 50),
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
                    _buildNutritionRow(
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
            child: _buildInputRow(context),
          ),
      ],
    );
  }

  Widget _buildFoodItemCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFoodImage(widget.imagePath, 50),
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
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
                if (widget.nutritionData != null) ...[
                  const SizedBox(height: 6),
                  _buildNutritionRow(
                    widget.nutritionData!.carbs,
                    widget.nutritionData!.protein,
                    widget.nutritionData!.fat,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (widget.onRemove != null)
            IconButton(
              onPressed: widget.onRemove,
              icon: const Icon(
                Icons.close,
                color: AppColors.textGray,
                size: 20,
              ),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ],
      ),
    );
  }

  Widget _buildAddButtonCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomButton(
        text: widget.title,
        icon: Icons.add,
        variant: ButtonVariant.outline,
        width: double.infinity,
        height: 48,
        onPressed: widget.onTap,
      ),
    );
  }

  Widget _buildInputFieldCard() {
    return Column(
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
                _buildFoodImage(widget.imagePath, 50),
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
                        _buildNutritionRow(
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
            child: _buildInputRow(context),
          ),
        ],
      ],
    );
  }

  // Helper method to build consistent food images
  Widget _buildFoodImage(String? imagePath, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: imagePath == null ? AppColors.disabled : null,
        image: imagePath != null
            ? DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover)
            : null,
      ),
      child: imagePath == null
          ? const Icon(Icons.fastfood, color: AppColors.textGray)
          : null,
    );
  }

  // Helper method to build consistent nutrition rows
  Widget _buildNutritionRow(double carbs, double protein, double fat) {
    return Row(
      children: [
        _buildNutritionItem('${carbs.toInt()}g', 'Carbs'),
        const SizedBox(width: 16),
        _buildNutritionItem('${protein.toInt()}g', 'Protein'),
        const SizedBox(width: 16),
        _buildNutritionItem('${fat.toInt()}g', 'Fat'),
      ],
    );
  }

  // Updated input row using CustomTextField
  Widget _buildInputRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: _controller,
            hintText: widget.inputHint ?? 'Enter amount',
            keyboardType: TextInputType.number,
            suffixText: widget.inputSuffix ?? 'g',
            suffixTextColor: AppColors.textGray,
            onChanged: (value) => widget.onInputChanged?.call(value),
            // onSubmitted: (value) {
            //   widget.onInputSubmitted?.call(value);
            //   setState(() {
            //     _showInputField = false;
            //   });
            // },
          ),
        ),
        const SizedBox(width: 12),
        CustomButton(
          text: '',
          icon: Icons.check,
          variant: ButtonVariant.primary,
          width: 44,
          height: 44,
          borderRadius: 8,
          onPressed: () {
            widget.onInputSubmitted?.call(_controller.text);
            setState(() {
              _showInputField = false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildMealIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        widget.icon ?? Icons.restaurant,
        color: AppColors.lightBackground,
        size: 20,
      ),
    );
  }

  Widget _buildNutritionSummaryRow() {
    final nutrition = widget.nutritionData!;
    return Row(
      children: [
        _buildSmallNutritionItem('${nutrition.carbs.toInt()}g', 'Carbs'),
        const SizedBox(width: 8),
        _buildSmallNutritionItem('${nutrition.protein.toInt()}g', 'Protein'),
        const SizedBox(width: 8),
        _buildSmallNutritionItem('${nutrition.fat.toInt()}g', 'Fat'),
      ],
    );
  }

  Widget _buildNutritionItem(String value, String label) {
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

  Widget _buildSmallNutritionItem(String value, String label) {
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
}
