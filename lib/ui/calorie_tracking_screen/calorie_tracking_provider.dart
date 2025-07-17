import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/ui/calorie_tracking_screen/view_model/calorie_tracking_view_model.dart';
import 'package:calorie_tracker_app/data/repository/food_repository.dart';
import 'package:calorie_tracker_app/domain/use_cases/calorie_tracking_usecase.dart';
import 'package:calorie_tracker_app/config/service_locator.dart';

final calorieTrackingProvider =
    ChangeNotifierProvider<CalorieTrackingViewModel>((ref) {
      return CalorieTrackingViewModel(
        useCase: getIt<CalorieTrackingUseCase>(),
        foodRepository: getIt<IFoodRepository>(),
      )..loadDailySummary();
    });
