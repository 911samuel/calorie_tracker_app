import 'package:calorie_tracker_app/core/ui/custom_text.dart';
import 'package:calorie_tracker_app/ui/food_search/view_model/calorie_tracking_view_model.dart';
import 'package:calorie_tracker_app/ui/food_search/view_model/food_search_view_model.dart';
import 'package:calorie_tracker_app/ui/food_search/widget/food_search_body.dart';
import 'package:calorie_tracker_app/ui/food_search/widget/food_search_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  final String mealType;
  final DateTime selectedDate;

  const FoodSearchScreen({
    super.key,
    required this.mealType,
    required this.selectedDate,
  });

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(calorieTrackingProvider).setSelectedMealType(widget.mealType);
      ref.read(calorieTrackingProvider).setSelectedDate(widget.selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText(
          label: 'Add to ${widget.mealType}',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          FoodSearchSearchBar(
            onSubmitted: (query) =>
                ref.read(foodSearchViewModelProvider).searchFoods(query),
          ),
          Expanded(
            child: FoodSearchBody(
              mealType: widget.mealType,
              selectedDate: widget.selectedDate,
            ),
          ),
        ],
      ),
    );
  }
}
