import 'package:calorie_tracker_app/config/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/router.dart';
import 'routes/routes.dart';

import 'package:calorie_tracker_app/data/services/shared_prefs_service.dart';
import 'package:calorie_tracker_app/domain/user.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  FlutterNativeSplash.remove();
  await dotenv.load(fileName: '.env');
  setupServiceLocator();
  runApp(const ProviderScope(child: CalorieTrackerApp()));
}

class CalorieTrackerApp extends StatefulWidget {
  const CalorieTrackerApp({super.key});

  @override
  State<CalorieTrackerApp> createState() => _CalorieTrackerAppState();
}

class _CalorieTrackerAppState extends State<CalorieTrackerApp> {
  String? _initialRoute;
  final SharedPrefsService _prefsService = SharedPrefsService();

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    User? user = await _prefsService.loadUser();
    setState(() {
      if (user != null && user.age != null && user.age! > 0) {
        _initialRoute = AppRoutes.home;
      } else {
        _initialRoute = AppRoutes.onboarding;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_initialRoute == null) {
      return const Material(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return MaterialApp(
      title: 'Calorie Tracker App',
      debugShowCheckedModeBanner: false,
      initialRoute: _initialRoute!,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
