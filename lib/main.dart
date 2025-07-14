import 'package:calorie_tracker_app/ui/tabs/view/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

void main() {
  runApp(const ProviderScope(child: FitTrackApp()));
}

class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: AppTheme.lightTheme,
      home: const TabsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
