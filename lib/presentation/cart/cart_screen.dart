import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../injection_container.dart';
import '../../router.dart';
import '../cart/cubit/cart_cubit.dart';
import '../order/cubit/order_cubit.dart';
import '../../data/models/cart_item_model.dart';
import 'package:ipot_technical_test/l10n/app_localizations.dart';
class CartScreen extends StatefulWidget {
  final String tableId;

  const CartScreen({super.key, required this.tableId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<CartCubit>()),
        BlocProvider(create: (_) => sl<OrderCubit>()),
      ],
      child: BlocListener<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderPlaced) {
            sl<CartCubit>().clearCart();
            context.pushReplacement(
              AppRouter.orderConfirmation,
              extra: {
                'orderId': state.order.id,
                'tableId': widget.tableId,
              },
            );
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.failedCreateOrder(state.message)),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        child: _CartView(tableId: widget.tableId, noteController: _noteController),
      ),
    );
  }
}

class _CartView extends StatelessWidget {
  final String tableId;
  final TextEditingController noteController;

  const _CartView({required this.tableId, required this.noteController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            final count = state is CartUpdated ? state.totalItems : 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.cart, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                Text(AppLocalizations.of(context)!.itemCount(count), style: const TextStyle(color: AppTheme.accentColor, fontSize: 12)),
              ],
            );
          },
        ),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is! CartUpdated) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => _showClearDialog(context),
                child: Text(AppLocalizations.of(context)!.clearAll, style: const TextStyle(color: AppTheme.errorColor, fontSize: 13)),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartEmpty) return _buildEmpty(context);
          if (state is CartUpdated) return _buildCart(context, state);
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_cart_outlined, color: AppTheme.textHint, size: 50),
          ),
          const SizedBox(height: 24),
          Text(AppLocalizations.of(context)!.emptyCart, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(AppLocalizations.of(context)!.addFavoriteMenu, style: const TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.restaurant_menu),
            label: Text(AppLocalizations.of(context)!.viewMenu),
          ),
        ],
      ),
    );
  }

  Widget _buildCart(BuildContext context, CartUpdated state) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Meja Info
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.surfaceLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.table_restaurant, color: AppTheme.accentColor, size: 20),
                    const SizedBox(width: 10),
                      Text(AppLocalizations.of(context)!.tableLabel,
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 13)),
                    const Spacer(),
                    Text(
                      tableId,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ],
                ),
              ),

              // Cart items
              ...state.items.map((item) => _CartItemTile(item: item)),

              const SizedBox(height: 16),

              // Customer note
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.surfaceLight),
                ),
                child: TextField(
                  controller: noteController,
                  onChanged: (v) => context.read<CartCubit>().updateNote(v),
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.kitchenNoteHint,
                    hintStyle: TextStyle(color: AppTheme.textHint, fontSize: 13),
                    border: InputBorder.none,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.all(12),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8, top: 12),
                      child: Icon(Icons.edit_note, color: AppTheme.textHint, size: 20),
                    ),
                    prefixIconConstraints: const BoxConstraints(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Order summary
              _buildSummary(context, state),
            ],
          ),
        ),

        // Bottom bar
        _buildBottomBar(context, state),
      ],
    );
  }

  Widget _buildSummary(BuildContext context, CartUpdated state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceLight),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.subtotal(state.totalItems),
                  style: const TextStyle(color: AppTheme.textSecondary)),
              Text(Formatters.formatCurrency(state.totalPrice),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: AppTheme.surfaceLight),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.total, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              Text(
                Formatters.formatCurrency(state.totalPrice),
                style: const TextStyle(
                  color: AppTheme.accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CartUpdated state) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, orderState) {
        final isLoading = orderState is OrderPlacing;
        return Container(
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceMedium,
            border: Border(top: BorderSide(color: AppTheme.surfaceLight)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => _placeOrder(context, state),
              child: isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(AppLocalizations.of(context)!.processingOrder),
                      ],
                    )
                  : Text(
                      '${AppLocalizations.of(context)!.orderNow} • ${Formatters.formatCurrency(state.totalPrice)}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        );
      },
    );
  }

  void _placeOrder(BuildContext context, CartUpdated state) {
    context.read<OrderCubit>().placeOrder(
          tableId: tableId,
          items: state.items,
          customerNote: noteController.text.trim().isNotEmpty
              ? noteController.text.trim()
              : null,
        );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceMedium,
        title: Text(AppLocalizations.of(context)!.clearCartTitle, style: const TextStyle(color: Colors.white)),
        content: Text(AppLocalizations.of(context)!.clearCartContent,
            style: const TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<CartCubit>().clearCart();
            },
            child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuItem.name,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                if (item.customizationsSummary.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.customizationsSummary,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
                if (item.note != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${AppLocalizations.of(context)!.note}: ${item.note}',
                    style: TextStyle(color: AppTheme.textHint, fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  Formatters.formatCurrency(item.totalPrice),
                  style: const TextStyle(color: AppTheme.accentColor, fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Quantity controls
          Row(
            children: [
              _SmallButton(
                icon: Icons.remove,
                onTap: () => context.read<CartCubit>().decrementQuantity(item.cartItemId),
                isDestructive: item.quantity <= 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              _SmallButton(
                icon: Icons.add,
                onTap: () => context.read<CartCubit>().incrementQuantity(item.cartItemId),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SmallButton({
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isDestructive
              ? AppTheme.errorColor.withValues(alpha: 0.15)
              : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isDestructive ? AppTheme.errorColor : AppTheme.accentColor,
        ),
      ),
    );
  }
}
