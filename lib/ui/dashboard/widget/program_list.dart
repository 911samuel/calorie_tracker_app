import 'package:calorie_tracker_app/core/theme/app_dimensions.dart';
import 'package:calorie_tracker_app/ui/dashboard/widget/program_card.dart';
import 'package:flutter/material.dart';

class ProgramList extends StatelessWidget {
  const ProgramList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProgramCard(
          title: 'Morning Routine',
          imageUrl: 'https://picsum.photos/200/300',
          progress: 0.3,
        ),
        const SizedBox(height: AppDimensions.spaceM),
        ProgramCard(title: 'Cardio Run', imageUrl: 'https://picsum.photos/200/301', progress: 0.6),
      ],
    );
  }
}