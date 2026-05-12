import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/menu_item_model.dart';
import '../../injection_container.dart';
import '../../router.dart';
import '../cart/cubit/cart_cubit.dart';
import 'cubit/menu_cubit.dart';
import 'widgets/customization_bottom_sheet.dart';
import 'package:ipot_technical_test/l10n/app_localizations.dart';
class MenuScreen extends StatelessWidget {
  final String tableId;

  const MenuScreen({super.key, required this.tableId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<MenuCubit>()..loadMenu(tableId),
        ),
        BlocProvider.value(value: sl<CartCubit>()),
      ],
      child: _MenuView(tableId: tableId),
    );
  }
}

class _MenuView extends StatefulWidget {
  final String tableId;

  const _MenuView({required this.tableId});

  @override
  State<_MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<_MenuView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      body: Stack(
        children: [
          BlocBuilder<MenuCubit, MenuState>(
            builder: (context, state) {
              if (state is MenuLoading) return _buildLoading();
              if (state is MenuError) return _buildError(state.message);
              if (state is MenuLoaded) return _buildMenu(context, state);
              return const SizedBox.shrink();
            },
          ),
          // Cart FAB overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: _CartFabWidget(tableId: widget.tableId),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppTheme.accentColor),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.loadingMenu, style: const TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppTheme.errorColor, size: 64),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.failedLoadMenu, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(color: AppTheme.textSecondary), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<MenuCubit>().loadMenu(widget.tableId),
            child: Text(AppLocalizations.of(context)!.tryAgain),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context, MenuLoaded state) {
    final categories = state.filteredCategories;

    // Initialize tab controller if needed
    if (_tabController == null || _tabController!.length != categories.length) {
      _tabController?.dispose();
      _tabController = TabController(
        length: categories.length,
        vsync: this,
      );
    }

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          pinned: true,
          floating: true,
          backgroundColor: AppTheme.surfaceDark,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => context.pop(),
          ),
          title: _isSearching
              ? _buildSearchField(context)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.menu, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                    Text(
                      '${AppLocalizations.of(context)!.table} ${widget.tableId}',
                      style: const TextStyle(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search,
                  color: Colors.white),
              onPressed: () {
                setState(() => _isSearching = !_isSearching);
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<MenuCubit>().clearSearch();
                }
              },
            ),
          ],
          bottom: categories.isNotEmpty
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: _buildTabBar(categories),
                )
              : null,
        ),
      ],
      body: categories.isEmpty
          ? _buildNoResults()
          : TabBarView(
              controller: _tabController,
              children: categories
                  .map((cat) => _buildCategoryTab(context, cat.items))
                  .toList(),
            ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.searchMenu,
        hintStyle: TextStyle(color: AppTheme.textHint),
        border: InputBorder.none,
        fillColor: Colors.transparent,
      ),
      onChanged: (q) => context.read<MenuCubit>().searchMenu(q),
    );
  }

  Widget _buildTabBar(List categories) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.surfaceLight, width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: AppTheme.accentColor,
        unselectedLabelColor: AppTheme.textSecondary,
        indicatorColor: AppTheme.accentColor,
        indicatorWeight: 2.5,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        tabs: categories
            .map((cat) => Tab(text: cat.name))
            .toList(),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, color: AppTheme.textHint, size: 64),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.noMenuFound, style: const TextStyle(color: Colors.white, fontSize: 18)),
          TextButton(
            onPressed: () {
              _searchController.clear();
              context.read<MenuCubit>().clearSearch();
            },
            child: Text(AppLocalizations.of(context)!.clearSearch),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(BuildContext context, List<MenuItemModel> items) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 120),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _MenuItemCard(
          item: items[index],
          tableId: widget.tableId,
        );
      },
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItemModel item;
  final String tableId;

  const _MenuItemCard({required this.item, required this.tableId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceLight, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: item.isAvailable ? () => _showItemDetail(context) : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      fit: BoxFit.cover,
                      width: 110,
                      height: 110,
                      placeholder: (context, url) => Container(
                        color: AppTheme.surfaceLight,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.accentColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.surfaceLight,
                        child: const Icon(Icons.restaurant, color: AppTheme.textHint, size: 32),
                      ),
                    ),
                    if (!item.isAvailable)
                      Container(
                        color: Colors.black54,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.outOfStock,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Item details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        color: item.isAvailable ? Colors.white : AppTheme.textHint,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Formatters.formatCurrency(item.price),
                          style: const TextStyle(
                            color: AppTheme.accentColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (item.isAvailable)
                          BlocBuilder<CartCubit, CartState>(
                            builder: (context, cartState) {
                              final qty = _getItemQty(cartState, item.id);
                              return qty > 0
                                  ? _buildQtyBadge(context, qty)
                                  : _buildAddButton(context);
                            },
                          ),
                      ],
                    ),
                    if (item.estimatedPrepTime != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule, size: 12, color: AppTheme.textHint),
                            const SizedBox(width: 4),
                            Text(
                              '~${AppLocalizations.of(context)!.mins(item.estimatedPrepTime!)}',
                              style: const TextStyle(color: AppTheme.textHint, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getItemQty(CartState cartState, String itemId) {
    if (cartState is CartUpdated) {
      return cartState.items
          .where((i) => i.menuItem.id == itemId)
          .fold(0, (sum, i) => sum + i.quantity);
    }
    return 0;
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showItemDetail(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.accentColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(AppLocalizations.of(context)!.add, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyBadge(BuildContext context, int qty) {
    return GestureDetector(
      onTap: () => _showItemDetail(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.accentColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_cart_outlined, color: AppTheme.accentColor, size: 14),
            const SizedBox(width: 4),
            Text(
              '$qty',
              style: const TextStyle(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CartCubit>(),
        child: CustomizationBottomSheet(
          item: item,
          onAddToCart: (qty, customizations) {
            context.read<CartCubit>().addItem(
                  menuItem: item,
                  quantity: qty,
                  customizations: customizations,
                );
          },
        ),
      ),
    );
  }
}

class _CartFabWidget extends StatelessWidget {
  final String tableId;

  const _CartFabWidget({required this.tableId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is! CartUpdated) return const SizedBox.shrink();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GestureDetector(
              onTap: () => context.push('${AppRouter.cart}?tableId=$tableId'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentColor, Color(0xFFD4870A)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentColor.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${state.totalItems}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.viewCart,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      Formatters.formatCurrency(state.totalPrice),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
