import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/ui/food_search/view_model/food_search_view_model.dart';
import 'package:calorie_tracker_app/data/repository/food_repository.dart';
import 'package:calorie_tracker_app/config/service_locator.dart';

final foodSearchProvider = ChangeNotifierProvider<FoodSearchViewModel>((ref) {
  return FoodSearchViewModel(foodRepository: getIt<IFoodRepository>());
});
