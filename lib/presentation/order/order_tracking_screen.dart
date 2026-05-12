import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../router.dart';
import '../../data/models/order_model.dart';
import 'cubit/order_cubit.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
    // Start polling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderCubit>().startTracking(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        final order = state is OrderTracking ? state.order : null;
        final isPolling = state is OrderTracking ? state.isPolling : false;

        return Scaffold(
          backgroundColor: AppTheme.surfaceDark,
          appBar: AppBar(
            backgroundColor: AppTheme.surfaceDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              onPressed: () => context.pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Lacak Pesanan', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                if (isPolling)
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Text('Live Update', style: TextStyle(color: AppTheme.successColor, fontSize: 11)),
                    ],
                  ),
              ],
            ),
          ),
          body: order == null
              ? const Center(child: CircularProgressIndicator(color: AppTheme.accentColor))
              : _buildTracking(context, order),
        );
      },
    );
  }

  Widget _buildTracking(BuildContext context, OrderModel order) {
    final statuses = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.ready,
      OrderStatus.served,
    ];

    final currentIndex = statuses.indexOf(order.status);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID & Table info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.surfaceLight),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID Pesanan', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    Text(order.id, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  ],
                ),
                const Spacer(),
                _StatusBadge(status: order.status),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Status stepper
          const Text('Status Pesanan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),

          ...statuses.asMap().entries.map((entry) {
            final index = entry.key;
            final status = entry.value;
            final isDone = index <= currentIndex;
            final isActive = index == currentIndex;
            final isLast = index == statuses.length - 1;

            return _buildStepItem(
              status: status,
              isDone: isDone,
              isActive: isActive,
              isLast: isLast,
            );
          }),

          const SizedBox(height: 24),

          // Estimated time
          if (order.estimatedPrepTime != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: AppTheme.accentColor, size: 28),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Estimasi Waktu', style: TextStyle(color: AppTheme.accentColor, fontSize: 12)),
                      Text(
                        '~${order.estimatedPrepTime} menit',
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Order items
          const Text('Detail Pesanan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.surfaceLight),
            ),
            child: Column(
              children: [
                ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(item.menuItemName, style: const TextStyle(color: Colors.white, fontSize: 14))),
                    ],
                  ),
                )),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Done button
          if (order.status == OrderStatus.served || order.status == OrderStatus.cancelled)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go(AppRouter.scanner),
                child: const Text('Pesanan Selesai'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required OrderStatus status,
    required bool isDone,
    required bool isActive,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDone
                        ? isActive
                            ? AppTheme.accentColor
                            : AppTheme.successColor
                        : AppTheme.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone
                          ? isActive
                              ? AppTheme.accentColor
                              : AppTheme.successColor
                          : AppTheme.textHint,
                      width: 2,
                    ),
                  ),
                  child: isDone
                      ? Icon(
                          isActive ? _getStatusIcon(status) : Icons.check,
                          color: Colors.white,
                          size: 14,
                        )
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isDone && !isActive
                          ? AppTheme.successColor
                          : AppTheme.surfaceLight,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.label,
                  style: TextStyle(
                    color: isDone ? Colors.white : AppTheme.textHint,
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
                if (isActive) ...[
                  const SizedBox(height: 4),
                  Text(
                    _getStatusDescription(status),
                    style: TextStyle(color: AppTheme.accentColor, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.hourglass_top;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline;
      case OrderStatus.preparing:
        return Icons.restaurant;
      case OrderStatus.ready:
        return Icons.notifications_active;
      case OrderStatus.served:
        return Icons.dining;
      default:
        return Icons.close;
    }
  }

  String _getStatusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pesananmu menunggu konfirmasi kasir';
      case OrderStatus.confirmed:
        return 'Pesananmu sudah dikonfirmasi!';
      case OrderStatus.preparing:
        return 'Dapur sedang menyiapkan pesananmu...';
      case OrderStatus.ready:
        return 'Pesananmu siap! Akan segera disajikan';
      case OrderStatus.served:
        return 'Selamat menikmati!';
      default:
        return '';
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _StatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case OrderStatus.pending:
        return AppTheme.warningColor;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return AppTheme.accentColor;
      case OrderStatus.ready:
        return AppTheme.successColor;
      case OrderStatus.served:
        return AppTheme.successColor;
      case OrderStatus.cancelled:
        return AppTheme.errorColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: _color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
