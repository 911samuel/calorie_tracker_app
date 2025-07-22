import 'package:calorie_tracker_app/data/services/shared_prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/user.dart';
import '../../../data/repository/onboarding_repository.dart';

class OnboardingState {
  final User? user;
  final bool isLoading;
  final String? error;
  final Map<String, String> fieldErrors;

  OnboardingState({
    this.user, 
    this.isLoading = false, 
    this.error,
    this.fieldErrors = const {},
  });

  OnboardingState copyWith({
    User? user, 
    bool? isLoading, 
    String? error, 
    Map<String, String>? fieldErrors,
  }) {
    return OnboardingState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }
}

class OnboardingViewModel extends StateNotifier<OnboardingState> {
  final OnboardingRepository _repository;

  OnboardingViewModel(this._repository) : super(OnboardingState(user: User(), fieldErrors: {}));

  // --- field updaters ---

  void updateGender(Gender gender) {
    state = state.copyWith(user: state.user?.copyWith(gender: gender));
  }

  void updateAge(int age) {
    Map<String, String> errors = Map.from(state.fieldErrors);
    
    if (age <= 0 || age > 120) {
      errors['age'] = "Please enter a valid age between 1 and 120";
    } else {
      errors.remove('age');
    }
    
    state = state.copyWith(
      user: state.user?.copyWith(age: age),
      fieldErrors: errors,
      error: null,
    );
  }

  void updateHeight(double height) {
    Map<String, String> errors = Map.from(state.fieldErrors);
    
    if (height <= 0 || height > 300) {
      errors['height'] = "Please enter a valid height between 1-300 cm";
    } else {
      errors.remove('height');
    }
    
    state = state.copyWith(
      user: state.user?.copyWith(height: height),
      fieldErrors: errors,
      error: null,
    );
  }

  void updateWeight(double weight) {
    Map<String, String> errors = Map.from(state.fieldErrors);
    
    if (weight <= 0 || weight > 500) {
      errors['weight'] = "Please enter a valid weight between 1-500 kg";
    } else {
      errors.remove('weight');
    }
    
    state = state.copyWith(
      user: state.user?.copyWith(weight: weight),
      fieldErrors: errors,
      error: null,
    );
  }

  void updateCarbsGoal(double carbs) {
    Map<String, String> errors = Map.from(state.fieldErrors);
    
    if (carbs < 0 || carbs > 100) {
      errors['carbs'] = "Please enter a valid carbs percentage (0-100)";
    } else {
      errors.remove('carbs');
    }
    
    state = state.copyWith(
      user: state.user?.copyWith(carbPercentage: carbs),
      fieldErrors: errors,
      error: null,
    );
  }

  void updateProteinGoal(double protein) {
    Map<String, String> errors = Map.from(state.fieldErrors);
    
    if (protein < 0 || protein > 100) {
      errors['protein'] = "Please enter a valid protein percentage (0-100)";
    } else {
      errors.remove('protein');
    }
    
    state = state.copyWith(
      user: state.user?.copyWith(proteinPercentage: protein),
      fieldErrors: errors,
      error: null,
    );
  }

  void updateFatGoal(double fat) {
    Map<String, String> errors = Map.from(state.fieldErrors);
    
    if (fat < 0 || fat > 100) {
      errors['fat'] = "Please enter a valid fat percentage (0-100)";
    } else {
      errors.remove('fat');
    }
    
    state = state.copyWith(
      user: state.user?.copyWith(fatPercentage: fat),
      fieldErrors: errors,
      error: null,
    );
  }

  bool get isFormValid {
    final user = state.user;
    if (user == null) return false;
    
    // Check if there are any field errors
    if (state.fieldErrors.isNotEmpty) return false;
    
    // Check if all required fields are filled
    if (user.age == null || user.age! <= 0 || user.age! > 120) return false;
    if (user.height == null || user.height! <= 0 || user.height! > 300) return false;
    if (user.weight == null || user.weight! <= 0 || user.weight! > 500) return false;
    if (user.carbPercentage == null || user.carbPercentage! < 0 || user.carbPercentage! > 100) return false;
    if (user.proteinPercentage == null || user.proteinPercentage! < 0 || user.proteinPercentage! > 100) return false;
    if (user.fatPercentage == null || user.fatPercentage! < 0 || user.fatPercentage! > 100) return false;
    
    return true;
  }
  
  // Helper methods for step-specific validation
  bool isAgeValid() {
    final user = state.user;
    return user?.age != null && 
           user!.age! > 0 && 
           user.age! <= 120 && 
           !state.fieldErrors.containsKey('age');
  }
  
  bool isHeightValid() {
    final user = state.user;
    return user?.height != null && 
           user!.height! > 0 && 
           user.height! <= 300 && 
           !state.fieldErrors.containsKey('height');
  }
  
  bool isWeightValid() {
    final user = state.user;
    return user?.weight != null && 
           user!.weight! > 0 && 
           user.weight! <= 500 && 
           !state.fieldErrors.containsKey('weight');
  }
  
  bool areNutrientGoalsValid() {
    final user = state.user;
    return user?.carbPercentage != null &&
           user?.proteinPercentage != null &&
           user?.fatPercentage != null &&
           !state.fieldErrors.containsKey('carbs') &&
           !state.fieldErrors.containsKey('protein') &&
           !state.fieldErrors.containsKey('fat');
  }
  
  String? getFieldError(String fieldName) {
    return state.fieldErrors[fieldName];
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
  
  void clearFieldError(String fieldName) {
    Map<String, String> errors = Map.from(state.fieldErrors);
    errors.remove(fieldName);
    state = state.copyWith(fieldErrors: errors);
  }
  
  void clearAllFieldErrors() {
    state = state.copyWith(fieldErrors: {});
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
