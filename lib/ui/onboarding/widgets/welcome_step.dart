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
        const Text("Hello! Let's find out more about you :)"),
        const SizedBox(height: 24),
        CustomButton(
          text: "Let's go",
          onPressed: onNext,
        ),
      ],
    );
  }
}
