import 'package:calorie_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, outline }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;
  final bool isSelected; // New property for selection state

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 48,
    this.borderRadius = 24,
    this.isSelected = false, // Default to not selected
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: _getForegroundColor(),
          elevation: _getElevation(),
          shadowColor: _getShadowColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: _getBorderSide(),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getForegroundColor(),
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _getForegroundColor(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return isSelected ? AppColors.primaryNeon : Colors.transparent;
      case ButtonVariant.secondary:
        return isSelected ? AppColors.darkGreen : Colors.transparent;
      case ButtonVariant.outline:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return isSelected ? AppColors.lightBackground : AppColors.primaryNeon;
      case ButtonVariant.secondary:
        return isSelected ? AppColors.textBlack : AppColors.darkGreen;
      case ButtonVariant.outline:
        return AppColors.primaryNeon;
    }
  }

  double _getElevation() {
    if (variant == ButtonVariant.outline) return 0;
    return isSelected ? 4 : 0;
  }

  Color? _getShadowColor() {
    if (variant == ButtonVariant.outline) return null;
    return isSelected ? AppColors.primaryShadow : null;
  }

  BorderSide _getBorderSide() {
    switch (variant) {
      case ButtonVariant.primary:
        return isSelected
            ? BorderSide.none
            : const BorderSide(color: AppColors.primaryNeon, width: 2);
      case ButtonVariant.secondary:
        return isSelected
            ? BorderSide.none
            : const BorderSide(color: AppColors.darkGreen, width: 2);
      case ButtonVariant.outline:
        return const BorderSide(color: AppColors.primaryNeon, width: 2);
    }
  }
}

// Usage example for toggle buttons like Male/Female selection
class ToggleButtonGroup extends StatefulWidget {
  final List<String> options;
  final int? selectedIndex;
  final Function(int)? onSelectionChanged;
  final ButtonVariant variant;
  final double spacing;

  const ToggleButtonGroup({
    super.key,
    required this.options,
    this.selectedIndex,
    this.onSelectionChanged,
    this.variant = ButtonVariant.primary,
    this.spacing = 16,
  });

  @override
  State<ToggleButtonGroup> createState() => _ToggleButtonGroupState();
}

class _ToggleButtonGroupState extends State<ToggleButtonGroup> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = _selectedIndex == index;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < widget.options.length - 1 ? widget.spacing : 0,
            ),
            child: CustomButton(
              text: option,
              isSelected: isSelected,
              variant: widget.variant,
              onPressed: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onSelectionChanged?.call(index);
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
