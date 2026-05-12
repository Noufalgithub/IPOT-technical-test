import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  served,
  cancelled;

  static OrderStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready':
        return OrderStatus.ready;
      case 'served':
        return OrderStatus.served;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}

class OrderItem extends Equatable {
  final String menuItemId;
  final String menuItemName;
  final int quantity;
  final double unitPrice;
  final List<Map<String, dynamic>> customizations;

  const OrderItem({
    required this.menuItemId,
    required this.menuItemName,
    required this.quantity,
    required this.unitPrice,
    required this.customizations,
  });

  double get totalPrice => unitPrice * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItemId: json['menu_item_id']?.toString() ?? '',
      menuItemName: json['menu_item_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unit_price'] ?? 0.0).toDouble(),
      customizations: List<Map<String, dynamic>>.from(
          json['customizations'] ?? []),
    );
  }

  @override
  List<Object?> get props => [menuItemId, quantity, unitPrice];
}

class OrderModel extends Equatable {
  final String id;
  final String tableId;
  final List<OrderItem> items;
  final OrderStatus status;
  final double totalAmount;
  final String? customerNote;
  final DateTime createdAt;
  final int? estimatedPrepTime; // minutes

  const OrderModel({
    required this.id,
    required this.tableId,
    required this.items,
    required this.status,
    required this.totalAmount,
    this.customerNote,
    required this.createdAt,
    this.estimatedPrepTime,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      tableId: json['table_id']?.toString() ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((i) => OrderItem.fromJson(i as Map<String, dynamic>))
          .toList(),
      status: OrderStatus.fromString(json['status'] ?? 'pending'),
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
      customerNote: json['customer_note'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      estimatedPrepTime: json['estimated_prep_time'],
    );
  }

  @override
  List<Object?> get props => [id, tableId, status, totalAmount];
}
