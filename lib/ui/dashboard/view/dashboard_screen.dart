import 'package:calorie_tracker_app/core/theme/app_colors.dart';
import 'package:calorie_tracker_app/core/theme/app_dimensions.dart';
import 'package:calorie_tracker_app/core/theme/app_text_styles.dart';
import 'package:calorie_tracker_app/ui/dashboard/widget/program_icons.dart';
import 'package:calorie_tracker_app/ui/dashboard/widget/program_list.dart';
import 'package:calorie_tracker_app/ui/dashboard/widget/stats_row.dart';
import 'package:calorie_tracker_app/ui/dashboard/widget/work_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                'https://picsum.photos/id/237/200/300',
              ),
            ),
            const SizedBox(width: AppDimensions.spaceM),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Welcome Back!!!', style: AppTextStyles.subtitle),
                Text('Mr.Fugazi', style: AppTextStyles.h4),
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.emoji_events, color: AppColors.primaryGreen),
          SizedBox(width: AppDimensions.spaceS),
          Icon(Icons.notifications, color: AppColors.primaryGreen),
          SizedBox(width: AppDimensions.spaceM),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WorkProgress(),
            const SizedBox(height: AppDimensions.spaceL),
            StatsRow(),
            const SizedBox(height: AppDimensions.spaceL),
            const Text('Programs', style: AppTextStyles.h4),
            const SizedBox(height: AppDimensions.spaceM),
            ProgramIcons(),
            const SizedBox(height: AppDimensions.spaceL),
            ProgramList(),
          ],
        ),
      ),
    );
  }
}
