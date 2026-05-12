class ApiConstants {
  ApiConstants._();

  // Base URL - configure this to point to your actual backend
  // For development/testing, mock data will be used when this returns errors
  static const String baseUrl = 'https://api.ipot.app';

  // API Endpoints
  static const String menu = '/api/v1/menu';
  static const String categories = '/api/v1/categories';
  static const String orders = '/api/v1/orders';
  static const String tables = '/api/v1/tables';

  // Connection timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // Cache
  static const String menuCacheKey = 'cached_menu_';
  static const Duration menuCacheDuration = Duration(minutes: 30);
}
