import 'package:calorie_tracker_app/config/api_config.dart';
import 'package:calorie_tracker_app/data/repository/food_repository.dart';
import 'package:calorie_tracker_app/data/repository/tracked_food_repository.dart';
import 'package:calorie_tracker_app/data/services/db_helper.dart';
import 'package:calorie_tracker_app/data/services/food_api_service.dart';
import 'package:calorie_tracker_app/data/services/tracked_food_service.dart';
import 'package:calorie_tracker_app/domain/use_cases/calorie_tracking_usecase.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  try {
    // Clear any existing registrations (helpful for hot reload)
    if (getIt.isRegistered<IFoodRepository>()) {
      getIt.unregister<IFoodRepository>();
    }
    if (getIt.isRegistered<IFoodApiService>()) {
      getIt.unregister<IFoodApiService>();
    }
    if (getIt.isRegistered<IHttpClient>()) {
      getIt.unregister<IHttpClient>();
    }
    if (getIt.isRegistered<IApiConfig>()) {
      getIt.unregister<IApiConfig>();
    }
    if (getIt.isRegistered<IFoodMapper>()) {
      getIt.unregister<IFoodMapper>();
    }
    if (getIt.isRegistered<Dio>()) {
      getIt.unregister<Dio>();
    }
    // Register database helper
    getIt.registerLazySingleton<DBHelper>(() => DBHelper());
    // Register tracked food service
    getIt.registerLazySingleton<TrackedFoodService>(
      () => TrackedFoodService(dbHelper: getIt<DBHelper>()),
    );

    // Register tracked food repository
    getIt.registerLazySingleton<ITrackedFoodRepository>(
      () => TrackedFoodRepository(service: getIt<TrackedFoodService>()),
    );

    // Register use case
    getIt.registerLazySingleton<CalorieTrackingUseCase>(
      () => CalorieTrackingUseCase(repository: getIt<ITrackedFoodRepository>()),
    );

    // Register Dio HTTP client
    getIt.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          connectTimeout: Duration(milliseconds: ApiConfig().requestTimeout),
          receiveTimeout: Duration(milliseconds: ApiConfig().requestTimeout),
        ),
      ),
    );

    // Register configuration
    getIt.registerLazySingleton<IApiConfig>(() => ApiConfig());

    // Register HTTP client
    getIt.registerLazySingleton<IHttpClient>(() => DioHttpClient(dio: getIt()));

    // Register mapper
    getIt.registerLazySingleton<IFoodMapper>(() => FoodMapper());

    // Register service
    getIt.registerLazySingleton<IFoodApiService>(
      () => FoodApiService(
        httpClient: getIt<IHttpClient>(),
        config: getIt<IApiConfig>(),
        mapper: getIt<IFoodMapper>(),
      ),
    );

    // Register repository
    getIt.registerLazySingleton<IFoodRepository>(
      () => FoodRepository(foodApiService: getIt<IFoodApiService>()),
    );
  } catch (e) {
    rethrow;
  }
}
