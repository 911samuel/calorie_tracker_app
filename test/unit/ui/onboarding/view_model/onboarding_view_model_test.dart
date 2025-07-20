import 'package:calorie_tracker_app/data/repository/onboarding_repository.dart';
import 'package:calorie_tracker_app/domain/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:calorie_tracker_app/ui/onboarding/view_model/onboarding_view_model.dart';

import 'onboarding_view_model_test.mocks.dart';

@GenerateMocks([OnboardingRepository])
void main() {
  late MockOnboardingRepository mockRepository;
  late OnboardingViewModel viewModel;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    viewModel = OnboardingViewModel(mockRepository);
  });

  test('initial state has default user and not loading', () {
    expect(viewModel.state.user, isA<User>());
    expect(viewModel.state.isLoading, isFalse);
    expect(viewModel.state.error, isNull);
  });

  test('updateGender updates state', () {
    viewModel.updateGender(Gender.female);
    expect(viewModel.state.user?.gender, Gender.female);
  });

  test('updateAge updates state', () {
    viewModel.updateAge(25);
    expect(viewModel.state.user?.age, 25);
  });

  test('updateHeight updates state', () {
    viewModel.updateHeight(180.5);
    expect(viewModel.state.user?.height, 180.5);
  });

  test('updateWeight updates state', () {
    viewModel.updateWeight(70.2);
    expect(viewModel.state.user?.weight, 70.2);
  });

  test('updateActivityLevel updates state', () {
    viewModel.updateActivityLevel(ActivityLevel.high);
    expect(viewModel.state.user?.activityLevel, ActivityLevel.high);
  });

  test('updateGoal updates state', () {
    viewModel.updateGoal(Goal.gain);
    expect(viewModel.state.user?.goal, Goal.gain);
  });

  test('updateCarbsGoal updates state', () {
    viewModel.updateCarbsGoal(55.0);
    expect(viewModel.state.user?.carbPercentage, 55.0);
  });

  test('updateProteinGoal updates state', () {
    viewModel.updateProteinGoal(25.0);
    expect(viewModel.state.user?.proteinPercentage, 25.0);
  });

  test('updateFatGoal updates state', () {
    viewModel.updateFatGoal(20.0);
    expect(viewModel.state.user?.fatPercentage, 20.0);
  });

  group('loadUser', () {
    test('loads user successfully', () async {
      final user = User(age: 30);
      when(mockRepository.loadUser()).thenAnswer((_) async => user);
      await viewModel.loadUser();
      expect(viewModel.state.user, user);
      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.error, isNull);
    });

    test('handles repository error', () async {
      when(mockRepository.loadUser()).thenThrow(Exception('fail'));
      await viewModel.loadUser();
      expect(viewModel.state.error, contains('fail'));
      expect(viewModel.state.isLoading, isFalse);
    });
  });

  group('saveUser', () {
    test('saves user successfully', () async {
      final user = User(age: 22);
      when(mockRepository.saveUser(user)).thenAnswer((_) async {});
      await viewModel.saveUser(user);
      expect(viewModel.state.user, user);
      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.error, isNull);
    });

    test('handles repository error', () async {
      final user = User(age: 22);
      when(mockRepository.saveUser(user)).thenThrow(Exception('save error'));
      await viewModel.saveUser(user);
      expect(viewModel.state.error, contains('save error'));
      expect(viewModel.state.isLoading, isFalse);
    });
  });

  group('save', () {
    test('calls saveUser if user is not null', () async {
      final user = User(age: 44);
      viewModel = OnboardingViewModel(mockRepository);
      viewModel.state = viewModel.state.copyWith(user: user);
      when(mockRepository.saveUser(user)).thenAnswer((_) async {});
      await viewModel.save();
      verify(mockRepository.saveUser(user)).called(1);
    });

    test('does nothing if user is null', () async {
      final viewModel = OnboardingViewModel(
        mockRepository,
      ); // create fresh instance
      viewModel.state = OnboardingState(user: null, isLoading: false);
      await viewModel.save();
      verifyNever(mockRepository.saveUser(any));
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.error, isNull);

    });

  });

  test('edge case: update with null user does not crash', () {
    viewModel.state = viewModel.state.copyWith(user: null);
    expect(() => viewModel.updateAge(20), returnsNormally);
    expect(() => viewModel.updateGender(Gender.male), returnsNormally);
    expect(() => viewModel.updateHeight(170), returnsNormally);
    expect(() => viewModel.updateWeight(60), returnsNormally);
    expect(
      () => viewModel.updateActivityLevel(ActivityLevel.low),
      returnsNormally,
    );
    expect(() => viewModel.updateGoal(Goal.keep), returnsNormally);
    expect(() => viewModel.updateCarbsGoal(50), returnsNormally);
    expect(() => viewModel.updateProteinGoal(20), returnsNormally);
    expect(() => viewModel.updateFatGoal(10), returnsNormally);
  });
}
