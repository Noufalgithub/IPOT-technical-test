import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../router.dart';
import 'cubit/order_cubit.dart';
import 'package:ipot_technical_test/l10n/app_localizations.dart';
class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  final String tableId;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
    required this.tableId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          final order = state is OrderPlaced ? state.order : null;

          return Scaffold(
            backgroundColor: AppTheme.surfaceDark,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Spacer(),
                    // Success animation
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                      builder: (_, value, child) =>
                          Transform.scale(scale: value, child: child),
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.successColor, Color(0xFF27AE60)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.successColor.withValues(alpha: 0.4),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 60),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      AppLocalizations.of(context)!.orderSuccessTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.orderSuccessMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 15),
                    ),
                    const SizedBox(height: 32),

                    // Order ID Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.surfaceLight),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.orderId, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.warningColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.statusWaiting,
                                  style: TextStyle(color: AppTheme.warningColor, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            orderId,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Divider(color: AppTheme.surfaceLight, height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.tableLabel, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                              Text(tableId, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          if (order?.estimatedPrepTime != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppLocalizations.of(context)!.estimatedTime, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                                Row(
                                  children: [
                                    const Icon(Icons.schedule, color: AppTheme.accentColor, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '~${AppLocalizations.of(context)!.mins(order!.estimatedPrepTime!)}',
                                      style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                          if (order != null) ...[
                            Divider(color: AppTheme.surfaceLight, height: 24),
                            ...order.items.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  Text('${item.quantity}x', style: const TextStyle(color: AppTheme.accentColor, fontSize: 13, fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(item.menuItemName, style: const TextStyle(color: Colors.white, fontSize: 13))),
                                  Text(Formatters.formatCurrency(item.totalPrice), style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                                ],
                              ),
                            )),
                            Divider(color: AppTheme.surfaceLight, height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppLocalizations.of(context)!.total, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                Text(
                                  Formatters.formatCurrency(order.totalAmount),
                                  style: const TextStyle(color: AppTheme.accentColor, fontSize: 16, fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Buttons
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.read<OrderCubit>().startTracking(orderId);
                              context.push(
                                AppRouter.orderTracking,
                                extra: {'orderId': orderId},
                              );
                            },
                            icon: const Icon(Icons.track_changes),
                            label: Text(AppLocalizations.of(context)!.trackOrder),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              context.go('${AppRouter.menu}?tableId=$tableId');
                            },
                            icon: const Icon(Icons.add_shopping_cart),
                            label: Text(AppLocalizations.of(context)!.orderMore),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }
}
