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
  final String? suffixText;
  final Color? suffixTextColor;
  final Function(String)? onChanged;
  final bool isOnboarding; // New parameter for onboarding style

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
    this.suffixText,
    this.suffixTextColor,
    this.onChanged,
    this.isOnboarding = false, // Default to false
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isOnboarding) {
      return _buildOnboardingStyle();
    }
    return _buildDefaultStyle();
  }

  Widget _buildOnboardingStyle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Focus(
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
                  onChanged: widget.onChanged,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ),
            if (widget.suffixText != null) ...[
              const SizedBox(width: 8),
              Text(
                widget.suffixText!,
                style: TextStyle(
                  color: widget.suffixTextColor ?? Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultStyle() {
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
            onChanged: widget.onChanged,
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
    return _isFocused ? AppColors.primaryNeon : AppColors.textBlack;
  }
}
