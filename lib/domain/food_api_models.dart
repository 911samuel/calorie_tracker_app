import 'package:calorie_tracker_app/config/api_config.dart';

class FoodApiResponse {
  final int count;
  final int page;
  final int pageCount;
  final int pageSize;
  final List<ProductDto> products;
  final int skip;

  const FoodApiResponse({
    required this.count,
    required this.page,
    required this.pageCount,
    required this.pageSize,
    required this.products,
    required this.skip,
  });

  factory FoodApiResponse.fromJson(Map<String, dynamic> json) {
    try {
      return FoodApiResponse(
        count: json['count'] as int? ?? 0,
        page: json['page'] as int? ?? 1,
        pageCount: json['page_count'] as int? ?? 0,
        pageSize: json['page_size'] as int? ?? 20,
        products: (json['products'] as List<dynamic>? ?? [])
            .map(
              (product) => ProductDto.fromJson(product as Map<String, dynamic>),
            )
            .toList(),
        skip: json['skip'] as int? ?? 0,
      );
    } catch (e) {
      throw ParseException('Failed to parse API response: $e');
    }
  }
}

// Product DTO for API response
class ProductDto {
  final String? productName;
  final String? imageFrontThumbUrl;
  final NutrimentsDto? nutriments;

  const ProductDto({
    this.productName,
    this.imageFrontThumbUrl,
    this.nutriments,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      productName: json['product_name'] as String?,
      imageFrontThumbUrl: json['image_front_thumb_url'] as String?,
      nutriments: json['nutriments'] != null
          ? NutrimentsDto.fromJson(json['nutriments'] as Map<String, dynamic>)
          : null,
    );
  }
}

// Nutriments DTO
class NutrimentsDto {
  final double? energyKcal100g;
  final double? proteins100g;
  final double? carbohydrates100g;
  final double? fat100g;

  const NutrimentsDto({
    this.energyKcal100g,
    this.proteins100g,
    this.carbohydrates100g,
    this.fat100g,
  });

  factory NutrimentsDto.fromJson(Map<String, dynamic> json) {
    return NutrimentsDto(
      energyKcal100g: _parseDouble(json['energy-kcal_100g']),
      proteins100g: _parseDouble(json['proteins_100g']),
      carbohydrates100g: _parseDouble(json['carbohydrates_100g']),
      fat100g: _parseDouble(json['fat_100g']),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
