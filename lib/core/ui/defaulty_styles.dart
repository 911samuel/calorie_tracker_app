import 'package:calorie_tracker_app/core/theme/app_colors.dart';
import 'package:calorie_tracker_app/core/ui/suffix_widget.dart';
import 'package:calorie_tracker_app/core/ui/text_field.dart';
import 'package:flutter/material.dart';

class DefaultyStyles extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? errorText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? suffixText;
  final VoidCallback? onSuffixTap;
  final Color? suffixTextColor;

  const DefaultyStyles({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
    this.onSuffixTap,
    this.suffixTextColor, required ValidationState validationState,
  });

  @override
  State<DefaultyStyles> createState() => _DefaultyStylesState();
}

class _DefaultyStylesState extends State<DefaultyStyles> {
  bool _isFocused = false;

  Color _getPrefixIconColor() {
    return _isFocused ? AppColors.primaryNeon : AppColors.textLightGray;
  }

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
              suffixIcon: SuffixWidget(
                suffixIcon: widget.suffixIcon,
                suffixText: widget.suffixText,
                onSuffixTap: widget.onSuffixTap,
                suffixTextColor: widget.suffixTextColor,
                isFocused: _isFocused,
              ),
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
                borderSide: BorderSide(color: _getPrefixIconColor(), width: 2),
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
}
