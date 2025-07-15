import 'package:calorie_tracker_app/domain/user.dart';
import 'package:calorie_tracker_app/ui/onboarding/view_model/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/welcome_step.dart';
import '../widgets/gender_step.dart';
import '../widgets/age_step.dart';
import '../widgets/height_step.dart';
import '../widgets/weight_step.dart';
import '../widgets/activity_level_step.dart';
import '../widgets/weight_goal_step.dart';
import '../widgets/nutrient_goals_step.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;

  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _carbsController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 7) {
      setState(() {
        _currentStep++;
      });
    } else {
      _saveUser();
    }
  }

  void _saveUser() {
    ref.read(onboardingViewModelProvider.notifier).save();
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingViewModelProvider);
    final user = state.user;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildStepContent(user),
        ),
      ),
    );
  }

  Widget _buildStepContent(User? user) {
    switch (_currentStep) {
      case 0:
        return WelcomeStep(onNext: _nextStep);
      case 1:
        return GenderStep(onNext: _nextStep);
      case 2:
        return AgeStep(onNext: _nextStep, ageController: _ageController);
      case 3:
        return HeightStep(onNext: _nextStep, heightController: _heightController);
      case 4:
        return WeightStep(onNext: _nextStep, weightController: _weightController);
      case 5:
        return ActivityLevelStep(onNext: _nextStep);
      case 6:
        return WeightGoalStep(onNext: _nextStep);
      case 7:
        return NutrientGoalsStep(
          onNext: _nextStep,
          carbsController: _carbsController,
          proteinController: _proteinController,
          fatController: _fatController,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
