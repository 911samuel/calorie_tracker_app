import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/user.dart';
import '../../../data/repository/onboarding_repository.dart';

class OnboardingState {
  final User? user;
  final bool isLoading;
  final String? error;

  OnboardingState({this.user, this.isLoading = false, this.error});

  OnboardingState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class OnboardingViewModel extends StateNotifier<OnboardingState> {
  final OnboardingRepository _repository;

  OnboardingViewModel(this._repository) : super(OnboardingState());

  Future<void> loadUser() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _repository.loadUser();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
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

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  throw UnimplementedError();
});

final onboardingViewModelProvider =
    StateNotifierProvider<OnboardingViewModel, OnboardingState>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return OnboardingViewModel(repository);
});
