import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';
import '../datasources/api_client.dart';
import '../datasources/mock_data.dart';
import '../models/category_model.dart';

class MenuRepository {
  final ApiClient _apiClient;

  MenuRepository(this._apiClient);

  Future<List<CategoryModel>> getMenu(String tableId) async {
    final cacheKey = '${ApiConstants.menuCacheKey}$tableId';
    
    try {
      final response = await _apiClient.get(
        ApiConstants.menu,
        queryParameters: {'table_id': tableId},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> categoriesJson =
            data['data']?['categories'] ?? data['categories'] ?? [];
            
        // Save to cache
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(cacheKey, jsonEncode(categoriesJson));

        return categoriesJson
            .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Failed to load menu: ${response.statusCode}');
    } catch (e) {
      // For menu loading, we still want to try fallback to keep app usable
      // but we could also throw ErrorMapper.map(e) if we wanted to show error screen
      return _getFallbackData(cacheKey);
    }
  }
  
  Future<List<CategoryModel>> _getFallbackData(String cacheKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(cacheKey);
      
      if (cachedData != null) {
        final List<dynamic> decodedData = jsonDecode(cachedData);
        return decodedData
            .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // If parsing cache fails, ignore and use mock data
    }
    
    // Simulate load time if falling back to mock data
    await Future.delayed(const Duration(milliseconds: 800));
    return MockData.getMenuCategories();
  }
}
