import 'package:calorie_tracker_app/domain/models/enums/nutrition_card_types.dart';
import 'package:calorie_tracker_app/ui/home/widget/card/base_nutrition_card.dart';
import 'package:flutter/material.dart';
import 'package:calorie_tracker_app/core/ui/button.dart';

class AddButtonCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const AddButtonCard({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BaseNutritionCard(
      type: NutritionCardType.addButton,
      title: title,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          text: title,
          icon: Icons.add,
          variant: ButtonVariant.outline,
          width: double.infinity,
          height: 48,
          onPressed: onTap,
        ),
      ),
    );
  }
}
