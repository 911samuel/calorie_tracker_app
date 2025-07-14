import 'package:calorie_tracker_app/core/theme/app_colors.dart';
import 'package:calorie_tracker_app/core/theme/app_dimensions.dart';
import 'package:calorie_tracker_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class WorkProgress extends StatelessWidget {
  const WorkProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Workout Progress !', style: AppTextStyles.h4),
              SizedBox(height: AppDimensions.spaceS),
              Text('14 Exercise left', style: AppTextStyles.subtitle),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  value: 0.75,
                  color: AppColors.primaryNeon,
                  backgroundColor: AppColors.cardGray,
                  strokeWidth: 5,
                ),
              ),
              const Text('75%', style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
  }