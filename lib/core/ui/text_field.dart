import 'package:calorie_tracker_app/core/ui/defaulty_styles.dart';
import 'package:calorie_tracker_app/core/ui/onboarding_text_field.dart';
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
  late final TextEditingController _internalController = widget.controller ?? TextEditingController();

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOnboarding) {
      return OnboardingTextField(
        controller: _internalController,
        validator: widget.validator,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        hintText: widget.hintText,
        errorText: widget.errorText,
        suffixText: widget.suffixText,
        suffixTextColor: widget.suffixTextColor,
      );
    }
    return DefaultyStyles(
      validator: widget.validator,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      onSuffixTap: widget.onSuffixTap,
      validationState: widget.validationState,
      errorText: widget.errorText,
      enabled: widget.enabled,
      suffixText: widget.suffixText,
      suffixTextColor: widget.suffixTextColor,
      onChanged: widget.onChanged,
      controller: _internalController,
    );
  }
}
