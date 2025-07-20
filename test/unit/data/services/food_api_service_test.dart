import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:calorie_tracker_app/domain/models/food_api_models.dart';

import 'package:calorie_tracker_app/domain/models/food.dart';
import 'package:calorie_tracker_app/data/services/food_api_service.dart';
import 'package:calorie_tracker_app/config/api_config.dart';

import 'food_api_service_test.mocks.dart';

@GenerateMocks([IHttpClient, IFoodMapper, IApiConfig])
void main() {
  late MockIHttpClient mockHttpClient;
  late MockIFoodMapper mockMapper;
  late MockIApiConfig mockConfig;
  late FoodApiService foodApiService;

  setUp(() {
    mockHttpClient = MockIHttpClient();
    mockMapper = MockIFoodMapper();
    mockConfig = MockIApiConfig();

    when(mockConfig.baseUrl).thenReturn('https://fake.api.com/');
    when(mockConfig.endpoint).thenReturn('search');
    when(mockConfig.defaultPageSize).thenReturn(10);

    foodApiService = FoodApiService(
      httpClient: mockHttpClient,
      config: mockConfig,
      mapper: mockMapper,
    );
  });

  test('returns list of Food when API call succeeds', () async {
    final mockProductDtos = [
      ProductDto(
        productName: 'Banana',
        nutriments: NutrimentsDto(
          energyKcal100g: 89,
          proteins100g: 1.1,
          carbohydrates100g: 23.0,
          fat100g: 0.3,
        ),
        imageFrontThumbUrl: 'https://example.com/image.jpg',
      ),
    ];

    final response = Response(
      requestOptions: RequestOptions(path: ''),
      data: {'products': mockProductDtos.map((e) => e.toJson()).toList()},
      statusCode: 200,
    );

    when(
      mockHttpClient.get(any, queryParameters: anyNamed('queryParameters')),
    ).thenAnswer((_) async => response);

    final mappedFoods = [
      Food(
        id: '123',
        name: 'Banana',
        caloriesPer100g: 89,
        proteinPer100g: 1.1,
        carbsPer100g: 23,
        fatPer100g: 0.3,
        imageUrl: 'https://example.com/image.jpg',
      ),
    ];

    when(mockMapper.mapToFoodList(any)).thenReturn(mappedFoods);

    final result = await foodApiService.searchFoods(searchTerm: 'banana');

    expect(result, isA<List<Food>>());
    expect(result.length, 1);
    expect(result.first.name, 'Banana');
  });

  test('throws FoodApiException on non-200 response', () async {
    final response = Response(
      requestOptions: RequestOptions(path: ''),
      statusCode: 404,
      data: {},
    );

    when(
      mockHttpClient.get(any, queryParameters: anyNamed('queryParameters')),
    ).thenAnswer((_) async => response);

    expect(
      () => foodApiService.searchFoods(searchTerm: 'banana'),
      throwsA(isA<FoodApiException>()),
    );
  });

  test('throws NetworkException on Dio timeout error', () async {
    when(
      mockHttpClient.get(any, queryParameters: anyNamed('queryParameters')),
    ).thenThrow(
      DioException(
        type: DioExceptionType.receiveTimeout,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    expect(
      () => foodApiService.searchFoods(searchTerm: 'banana'),
      throwsA(isA<NetworkException>()),
    );
  });

  test('throws FoodApiException on unknown error', () async {
    when(
      mockHttpClient.get(any, queryParameters: anyNamed('queryParameters')),
    ).thenThrow(Exception('Unexpected error'));

    expect(
      () => foodApiService.searchFoods(searchTerm: 'banana'),
      throwsA(isA<FoodApiException>()),
    );
  });
}
