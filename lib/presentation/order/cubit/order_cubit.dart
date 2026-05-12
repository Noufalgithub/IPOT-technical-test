import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';

// States
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderPlacing extends OrderState {}

class OrderPlaced extends OrderState {
  final OrderModel order;

  const OrderPlaced(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderTracking extends OrderState {
  final OrderModel order;
  final bool isPolling;

  const OrderTracking({required this.order, this.isPolling = false});

  @override
  List<Object?> get props => [order, isPolling];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;
  Timer? _pollingTimer;

  OrderCubit(this._orderRepository) : super(OrderInitial());

  Future<void> placeOrder({
    required String tableId,
    required List<CartItem> items,
    String? customerNote,
  }) async {
    emit(OrderPlacing());
    try {
      final order = await _orderRepository.placeOrder(
        tableId: tableId,
        items: items,
        customerNote: customerNote,
      );
      emit(OrderPlaced(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> startTracking(String orderId) async {
    final currentState = state;
    if (currentState is OrderPlaced) {
      emit(OrderTracking(order: currentState.order, isPolling: true));
      _startPolling(orderId);
    }
  }

  void _startPolling(String orderId) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final order = await _orderRepository.getOrderStatus(orderId);
        emit(OrderTracking(order: order, isPolling: true));

        // Stop polling if order is served or cancelled
        if (order.status == OrderStatus.served ||
            order.status == OrderStatus.cancelled) {
          _stopPolling();
        }
      } catch (e) {
        // Continue polling even on error
      }
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    final currentState = state;
    if (currentState is OrderTracking) {
      emit(OrderTracking(order: currentState.order, isPolling: false));
    }
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
