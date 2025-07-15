import 'package:calorie_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum ValidationState { none, error, success }

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final ValidationState validationState;
  final String? errorText;
  final bool enabled;
  final String? suffixText; // New parameter for suffix text
  final Color? suffixTextColor; // Color for suffix text

  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.validationState = ValidationState.none,
    this.errorText,
    this.enabled = true,
    this.suffixText, // Add suffix text parameter
    this.suffixTextColor, // Add suffix text color parameter
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              color: AppColors.textBlack,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isFocused = hasFocus;
            });
          },
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            enabled: widget.enabled,
            style: const TextStyle(color: AppColors.textBlack, fontSize: 16),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: AppColors.textLightGray,
                fontSize: 16,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: _getPrefixIconColor())
                  : null,
              suffixIcon: _buildSuffixWidget(),
              filled: true,
              fillColor: widget.enabled
                  ? AppColors.cardWhite
                  : AppColors.disabled,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _getBorderColor(), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryNeon,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.error, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: const TextStyle(color: AppColors.error, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixWidget() {
    // If both suffix icon and suffix text are provided, prioritize icon
    if (widget.suffixIcon != null) {
      return GestureDetector(
        onTap: widget.onSuffixTap,
        child: Icon(widget.suffixIcon, color: _getSuffixIconColor()),
      );
    }

    // If only suffix text is provided
    if (widget.suffixText != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Center(
          widthFactor: 1.0,
          child: Text(
            widget.suffixText!,
            style: TextStyle(
              color: widget.suffixTextColor ?? _getSuffixTextColor(),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return null;
  }

  Color _getBorderColor() {
    switch (widget.validationState) {
      case ValidationState.error:
        return AppColors.error;
      case ValidationState.success:
        return AppColors.success;
      case ValidationState.none:
        return _isFocused ? AppColors.primaryNeon : Colors.transparent;
    }
  }

  Color _getPrefixIconColor() {
    return _isFocused ? AppColors.primaryNeon : AppColors.textLightGray;
  }

  Color _getSuffixIconColor() {
    return _isFocused ? AppColors.primaryNeon : AppColors.textLightGray;
  }

  Color _getSuffixTextColor() {
    return _isFocused ? AppColors.primaryNeon : AppColors.textLightGray;
  }
}
