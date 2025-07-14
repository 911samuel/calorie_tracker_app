import 'package:calorie_tracker_app/core/theme/app_colors.dart';
import 'package:calorie_tracker_app/core/theme/app_dimensions.dart';
import 'package:calorie_tracker_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProgramIcon extends StatelessWidget {
  const ProgramIcon({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: AppDimensions.spaceM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icon, color: AppColors.primaryNeon),
          const SizedBox(height: AppDimensions.spaceS),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
