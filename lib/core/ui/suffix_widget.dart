import 'package:calorie_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SuffixWidget extends StatelessWidget {
  const SuffixWidget({
    super.key,
    this.suffixIcon,
    this.suffixText,
    this.onSuffixTap,
    this.isFocused = false,
    this.suffixTextColor,
  });

  final IconData? suffixIcon;
  final String? suffixText;
  final VoidCallback? onSuffixTap;
  final bool isFocused;
  final Color? suffixTextColor;

  Color _getSuffixIconColor() {
    return isFocused ? AppColors.primaryNeon : AppColors.textLightGray;
  }

  Color _getSuffixTextColor() {
    return isFocused ? AppColors.primaryNeon : AppColors.textBlack;
  }

  @override
  Widget build(BuildContext context) {
    if (suffixIcon != null) {
      return GestureDetector(
        onTap: onSuffixTap,
        child: Icon(
          suffixIcon,
          color: suffixTextColor ?? _getSuffixIconColor(),
        ),
      );
    }

    if (suffixText != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Center(
          widthFactor: 1.0,
          child: Text(
            suffixText!,
            style: TextStyle(
              color: suffixTextColor ?? _getSuffixTextColor(),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
