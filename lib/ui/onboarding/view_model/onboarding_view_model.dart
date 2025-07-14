import 'package:calorie_tracker_app/data/services/shared_prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/user.dart';
import '../../../data/repository/onboarding_repository.dart';

class OnboardingState {
  final User? user;
  final bool isLoading;
  final String? error;

  OnboardingState({this.user, this.isLoading = false, this.error});

  OnboardingState copyWith({User? user, bool? isLoading, String? error}) {
    return OnboardingState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class OnboardingViewModel extends StateNotifier<OnboardingState> {
  final OnboardingRepository _repository;

  OnboardingViewModel(this._repository) : super(OnboardingState(user: User()));

  // --- field updaters ---

  void updateGender(Gender gender) {
    state = state.copyWith(user: state.user?.copyWith(gender: gender));
  }

  void updateAge(int age) {
    state = state.copyWith(user: state.user?.copyWith(age: age));
  }

  void updateHeight(double height) {
    state = state.copyWith(user: state.user?.copyWith(height: height));
  }

  void updateWeight(double weight) {
    state = state.copyWith(user: state.user?.copyWith(weight: weight));
  }

  void updateActivityLevel(ActivityLevel level) {
    state = state.copyWith(user: state.user?.copyWith(activityLevel: level));
  }

  void updateGoal(Goal goal) {
    state = state.copyWith(user: state.user?.copyWith(goal: goal));
  }

  void updateCarbsGoal(double carbs) {
    state = state.copyWith(user: state.user?.copyWith(carbPercentage: carbs));
  }

  void updateProteinGoal(double protein) {
    state = state.copyWith(
      user: state.user?.copyWith(proteinPercentage: protein),
    );
  }

  void updateFatGoal(double fat) {
    state = state.copyWith(user: state.user?.copyWith(fatPercentage: fat));
  }

  // --- persistence ---

  Future<void> loadUser() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _repository.loadUser();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> save() async {
    final user = state.user;
    if (user != null) {
      await saveUser(user);
    }
  }

  Future<void> saveUser(User user) async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.saveUser(user);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

// --- providers ---

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final sharedPrefsService = SharedPrefsService();
  return OnboardingRepository(sharedPrefsService);
});

final onboardingViewModelProvider =
    StateNotifierProvider<OnboardingViewModel, OnboardingState>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return OnboardingViewModel(repository);
});
