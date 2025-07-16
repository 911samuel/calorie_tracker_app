import 'package:calorie_tracker_app/core/ui/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:calorie_tracker_app/core/ui/button.dart';

class WelcomeStep extends StatelessWidget {
  final VoidCallback onNext;

  const WelcomeStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(label: "Hello! Let's find out more about you :)", fontSize: 26, textAlign: TextAlign.center,),
        const SizedBox(height: 24),
        CustomButton(
          text: "Let's go",
          onPressed: onNext,
          variant: ButtonVariant.primary,
          isSelected: true,
        ),
      ],
    );
  }
}
