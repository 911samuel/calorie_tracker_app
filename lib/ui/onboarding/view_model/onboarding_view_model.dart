import 'package:calorie_tracker_app/data/services/shared_prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/user.dart';
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
    if (age <= 0 || age > 120) {
      state = state.copyWith(error: "Please enter a valid age between 1 and 120.");
    } else {
      state = state.copyWith(user: state.user?.copyWith(age: age), error: null);
    }
  }

  void updateHeight(double height) {
    if (height <= 0 || height > 300) {
      state = state.copyWith(error: "Please enter a valid height in cm.");
    } else {
      state = state.copyWith(user: state.user?.copyWith(height: height), error: null);
    }
  }

  void updateWeight(double weight) {
    if (weight <= 0 || weight > 500) {
      state = state.copyWith(error: "Please enter a valid weight in kg.");
    } else {
      state = state.copyWith(user: state.user?.copyWith(weight: weight), error: null);
    }
  }

  void updateCarbsGoal(double carbs) {
    if (carbs < 0 || carbs > 100) {
      state = state.copyWith(error: "Please enter a valid carbs percentage (0-100).");
    } else {
      state = state.copyWith(user: state.user?.copyWith(carbPercentage: carbs), error: null);
    }
  }

  void updateProteinGoal(double protein) {
    if (protein < 0 || protein > 100) {
      state = state.copyWith(error: "Please enter a valid protein percentage (0-100).");
    } else {
      state = state.copyWith(user: state.user?.copyWith(proteinPercentage: protein), error: null);
    }
  }

  void updateFatGoal(double fat) {
    if (fat < 0 || fat > 100) {
      state = state.copyWith(error: "Please enter a valid fat percentage (0-100).");
    } else {
      state = state.copyWith(user: state.user?.copyWith(fatPercentage: fat), error: null);
    }
  }

  bool get isFormValid {
    final user = state.user;
    if (user == null) return false;
    if (user.age == null || user.age! <= 0 || user.age! > 120) return false;
    if (user.height == null || user.height! <= 0 || user.height! > 300) return false;
    if (user.weight == null || user.weight! <= 0 || user.weight! > 500) return false;
    if (user.carbPercentage == null || user.carbPercentage! < 0 || user.carbPercentage! > 100) return false;
    if (user.proteinPercentage == null || user.proteinPercentage! < 0 || user.proteinPercentage! > 100) return false;
    if (user.fatPercentage == null || user.fatPercentage! < 0 || user.fatPercentage! > 100) return false;
    return true;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void updateActivityLevel(ActivityLevel level) {
    state = state.copyWith(user: state.user?.copyWith(activityLevel: level));
  }
  void updateGoal(Goal goal) {
    state = state.copyWith(user: state.user?.copyWith(goal: goal));
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
