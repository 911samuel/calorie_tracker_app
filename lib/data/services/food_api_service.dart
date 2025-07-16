import 'package:calorie_tracker_app/config/api_config.dart';
import 'package:calorie_tracker_app/domain/food.dart';
import 'package:calorie_tracker_app/domain/food_api_models.dart';
import 'package:dio/dio.dart';

abstract class IFoodApiService {
  Future<List<Food>> searchFoods({
    required String searchTerm,
    int page = 1,
    int? pageSize,
  });
}

abstract class IFoodMapper {
  Food mapToFood(ProductDto productDto);
  List<Food> mapToFoodList(List<ProductDto> productDtos);
}

// HTTP client abstractions
abstract class IHttpClient {
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters});
}

class DioHttpClient implements IHttpClient {
  final Dio _dio;

  DioHttpClient({required Dio dio}) : _dio = dio;

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }
}

class FoodMapper implements IFoodMapper {
  @override
  Food mapToFood(ProductDto productDto) {
    // Generate a unique ID from product name and image URL
    final id = _generateId(
      productDto.productName,
      productDto.imageFrontThumbUrl,
    );

    return Food(
      id: id,
      name: productDto.productName ?? 'Unknown Food',
      caloriesPer100g: productDto.nutriments?.energyKcal100g?.round() ?? 0,
      proteinPer100g: productDto.nutriments?.proteins100g ?? 0.0,
      carbsPer100g: productDto.nutriments?.carbohydrates100g ?? 0.0,
      fatPer100g: productDto.nutriments?.fat100g ?? 0.0,
      imageUrl: productDto.imageFrontThumbUrl,
    );
  }

  @override
  List<Food> mapToFoodList(List<ProductDto> productDtos) {
    return productDtos
        .where((dto) => dto.productName != null && dto.productName!.isNotEmpty)
        .map(mapToFood)
        .toList();
  }

  String _generateId(String? productName, String? imageUrl) {
    final hashCode = '$productName$imageUrl'.hashCode;
    return hashCode.abs().toString();
  }
}

class FoodApiService implements IFoodApiService {
  final IHttpClient _httpClient;
  final IApiConfig _config;
  final IFoodMapper _mapper;

  FoodApiService({
    required IHttpClient httpClient,
    required IApiConfig config,
    required IFoodMapper mapper,
  }) : _httpClient = httpClient,
       _config = config,
       _mapper = mapper;

  @override
  Future<List<Food>> searchFoods({
    required String searchTerm,
    int page = 1,
    int? pageSize,
  }) async {
    try {
      final queryParameters = _buildQueryParameters(
        searchTerm: searchTerm,
        page: page,
        pageSize: pageSize ?? _config.defaultPageSize,
      );

      final response = await _httpClient.get(
        '${_config.baseUrl}${_config.endpoint}',
        queryParameters: queryParameters,
      );

      if (response.statusCode != 200) {
        throw FoodApiException(
          'API request failed with status: ${response.statusCode}',
          response.statusCode,
        );
      }

      final apiResponse = FoodApiResponse.fromJson(response.data);
      return _mapper.mapToFoodList(apiResponse.products);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } on FoodApiException {
      rethrow;
    } catch (e) {
      throw FoodApiException('Unexpected error occurred: $e', 500);
    }
  }

  // Pure function for building query parameters
  Map<String, dynamic> _buildQueryParameters({
    required String searchTerm,
    required int page,
    required int pageSize,
  }) {
    return {
      'search_simple': '1',
      'json': '1',
      'action': 'process',
      'fields': 'product_name,nutriments,image_front_thumb_url',
      'search_terms': searchTerm,
      'page': page.toString(),
      'page_size': pageSize.toString(),
    };
  }

  // Pure function for handling Dio exceptions
  FoodApiException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          'Request timeout. Please check your internet connection.',
        );
      case DioExceptionType.connectionError:
        return const NetworkException(
          'Connection error. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        return FoodApiException(
          'Server error: ${e.response?.statusMessage ?? 'Unknown error'}',
          e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return const FoodApiException('Request was cancelled', 500);
      case DioExceptionType.unknown:
        return FoodApiException('Network error: ${e.message}', 500);
      default:
        return FoodApiException('Unexpected error: ${e.message}', 500);
    }
  }
}

// Factory class for dependency injection
class FoodApiServiceFactory {
  static FoodApiService create() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: Duration(milliseconds: ApiConfig().requestTimeout),
        receiveTimeout: Duration(milliseconds: ApiConfig().requestTimeout),
      ),
    );

    return FoodApiService(
      httpClient: DioHttpClient(dio: dio),
      config: ApiConfig(),
      mapper: FoodMapper(),
    );
  }
}
