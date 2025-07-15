import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'routes/router.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  FlutterNativeSplash.remove();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    List<FoodItem> breakfastItems = [
      FoodItem(
        name: 'Apple Juice',
        weight: '250g',
        calories: 115,
        carbs: 28,
        protein: 0,
        fat: 3,
        imagePath: 'assets/apple_juice.png',
      ),
      FoodItem(
        name: 'Cornflake Chocolate Chip',
        weight: '120g',
        calories: 522,
        carbs: 78,
        protein: 8,
        fat: 18,
        imagePath: 'assets/cornflake.png',
      ),
    ];
    return MaterialApp(
      title: 'Calorie Tracker App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.onboarding,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
