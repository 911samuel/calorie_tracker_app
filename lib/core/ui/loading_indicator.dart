import 'dart:ui';

import 'package:calorie_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum LoadingVariant { circular, linear }

class LoadingIndicator extends StatelessWidget {
  final LoadingVariant variant;
  final double? value;
  final Color? color;
  final double size;
  final double strokeWidth;

  const LoadingIndicator({
    super.key,
    this.variant = LoadingVariant.circular,
    this.value,
    this.color,
    this.size = 24,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? AppColors.primaryNeon;

    switch (variant) {
      case LoadingVariant.circular:
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: value,
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          ),
        );
      case LoadingVariant.linear:
        return LinearProgressIndicator(
          value: value,
          backgroundColor: AppColors.cardWhite,
          valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
        );
    }
  }
}
