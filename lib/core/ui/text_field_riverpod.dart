import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/core/viewmodels/text_field_view_model.dart';

class CustomTextFieldRiverpod extends ConsumerWidget {
  final String? label;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? errorText;
  final bool enabled;
  final String? suffixText;
  final Color? suffixTextColor;
  final Function(String)? onChanged;

  const CustomTextFieldRiverpod({
    super.key,
    this.label,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.errorText,
    this.enabled = true,
    this.suffixText,
    this.suffixTextColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(textFieldViewModelProvider);
    return TextFormField(
      controller: viewModel.controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
      onChanged: (value) {
        viewModel.setError(null); // Or your validation logic
        if (onChanged != null) onChanged!(value);
      },
      onTap: () => viewModel.setFocus(true),
      onEditingComplete: () => viewModel.setFocus(false),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        errorText: viewModel.errorText ?? errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? IconButton(
          icon: Icon(suffixIcon),
          onPressed: onSuffixTap,
        ) : null,
        suffixText: suffixText,
        suffixStyle: TextStyle(color: suffixTextColor),
      ),
    );
  }
}
