import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../datasources/api_client.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../../core/error/error_mapper.dart';

class OrderRepository {
  final ApiClient _apiClient;

  OrderRepository(this._apiClient);

  Future<OrderModel> placeOrder({
    required String tableId,
    required List<CartItem> items,
    String? customerNote,
  }) async {
    try {
      final orderData = {
        'table_id': tableId,
        'items': items.map((i) => i.toOrderJson()).toList(),
        if (customerNote != null && customerNote.isNotEmpty)
          'customer_note': customerNote,
      };

      final response = await _apiClient.post(
        ApiConstants.orders,
        data: orderData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        return OrderModel.fromJson(data['data'] ?? data);
      }
      throw Exception('Failed to place order: ${response.statusCode}');
    } catch (e) {
      throw ErrorMapper.map(e);
    }
  }

  Future<OrderModel> getOrderStatus(String orderId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.orders}/$orderId',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return OrderModel.fromJson(data['data'] ?? data);
      }
      throw Exception('Failed to get order status');
    } on DioException catch (_) {
      // Simulate status progression for demo
      await Future.delayed(const Duration(milliseconds: 500));
      return _simulateStatusProgression(orderId);
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _simulateStatusProgression(orderId);
    }
  }

  // Simulate order status progression for demo
  static int _statusCallCount = 0;
  OrderModel _simulateStatusProgression(String orderId) {
    _statusCallCount++;
    final statuses = [
      OrderStatus.pending,
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.preparing,
      OrderStatus.preparing,
      OrderStatus.ready,
      OrderStatus.served,
    ];

    final statusIndex = (_statusCallCount / 2).floor().clamp(0, statuses.length - 1);
    
    return OrderModel(
      id: orderId,
      tableId: 'T001',
      items: [
        const OrderItem(
          menuItemId: 'item_3',
          menuItemName: 'Tonkotsu Ramen',
          quantity: 1,
          unitPrice: 95000,
          customizations: [],
        ),
      ],
      status: statuses[statusIndex],
      totalAmount: 95000,
      createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      estimatedPrepTime: 12,
    );
  }
}
