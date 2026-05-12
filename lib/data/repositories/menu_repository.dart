import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../datasources/api_client.dart';
import '../datasources/mock_data.dart';
import '../models/category_model.dart';

class MenuRepository {
  final ApiClient _apiClient;

  MenuRepository(this._apiClient);

  Future<List<CategoryModel>> getMenu(String tableId) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.menu,
        queryParameters: {'table_id': tableId},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> categoriesJson =
            data['data']?['categories'] ?? data['categories'] ?? [];
        return categoriesJson
            .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Failed to load menu: ${response.statusCode}');
    } on DioException catch (_) {
      // Fallback to mock data when API is unavailable
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate load
      return MockData.getMenuCategories();
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 800));
      return MockData.getMenuCategories();
    }
  }
}
