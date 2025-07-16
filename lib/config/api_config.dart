import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class IApiConfig {
  String get baseUrl;
  String get endpoint;
  int get defaultPageSize;
  int get requestTimeout;
}

class ApiConfig implements IApiConfig {
  @override
  String get baseUrl =>
      dotenv.env['FOOD_API_BASE_URL'] ?? 'https://us.openfoodfacts.org';

  @override
  String get endpoint => dotenv.env['FOOD_API_ENDPOINT'] ?? '/cgi/search.pl';

  @override
  int get defaultPageSize =>
      int.tryParse(dotenv.env['DEFAULT_PAGE_SIZE'] ?? '20') ?? 20;

  @override
  int get requestTimeout =>
      int.tryParse(dotenv.env['REQUEST_TIMEOUT'] ?? '30000') ?? 30000;
}

class FoodApiException implements Exception {
  final String message;

  final int? statusCode;
  const FoodApiException(this.message, this.statusCode);

  @override
  String toString() =>
      'FoodApiException: $message ${statusCode != null ? '(Status: $statusCode)' : ''}';
}

class NetworkException extends FoodApiException {
  const NetworkException(String message) : super(message, null);
}

class ParseException extends FoodApiException {
  const ParseException(String message) : super(message, null);
}
