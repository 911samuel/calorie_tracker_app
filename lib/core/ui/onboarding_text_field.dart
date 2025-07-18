import 'package:flutter/material.dart';
import 'package:calorie_tracker_app/core/theme/app_colors.dart';

class OnboardingTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final Function(String)? onChanged;
  final String? hintText;
  final String? errorText;
  final String? suffixText;
  final Color? suffixTextColor;

  const OnboardingTextField({
    super.key,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.onChanged,
    this.hintText,
    this.errorText,
    this.suffixText,
    this.suffixTextColor,
  });

  @override
  State<OnboardingTextField> createState() => _OnboardingTextFieldState();
}

class _OnboardingTextFieldState extends State<OnboardingTextField> {
  bool _isFocused = false;
  late final TextEditingController _internalController = widget.controller ?? TextEditingController();

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  Color _getBorderColor() {
    if (widget.errorText != null && widget.errorText!.isNotEmpty) {
      return AppColors.error;
    }
    return _isFocused ? AppColors.primaryNeon : Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
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
                  controller: _internalController,
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _getBorderColor(), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _getBorderColor(), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _getBorderColor(), width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _getBorderColor(), width: 2),
                    ),
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
        if (widget.errorText != null && widget.errorText!.isNotEmpty) ...[
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
}
