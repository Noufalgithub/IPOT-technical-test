import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/customization_model.dart';
import '../../../data/models/menu_item_model.dart';
import 'package:ipot_technical_test/l10n/app_localizations.dart';

class CustomizationBottomSheet extends StatefulWidget {
  final MenuItemModel item;
  final Function(int quantity, List<SelectedCustomization> customizations) onAddToCart;

  const CustomizationBottomSheet({
    super.key,
    required this.item,
    required this.onAddToCart,
  });

  @override
  State<CustomizationBottomSheet> createState() =>
      _CustomizationBottomSheetState();
}

class _CustomizationBottomSheetState extends State<CustomizationBottomSheet> {
  int _quantity = 1;
  late Map<String, List<String>> _selectedOptions;

  @override
  void initState() {
    super.initState();
    _selectedOptions = {};
    // Pre-select first option for required single-select groups
    for (final group in widget.item.customizations) {
      if (group.required && group.isSingleSelect && group.options.isNotEmpty) {
        _selectedOptions[group.id] = [group.options.first.id];
      }
    }
  }

  double get _totalPrice {
    double modifier = 0;
    for (final group in widget.item.customizations) {
      final selectedIds = _selectedOptions[group.id] ?? [];
      for (final option in group.options) {
        if (selectedIds.contains(option.id)) {
          modifier += option.priceModifier;
        }
      }
    }
    return (widget.item.price + modifier) * _quantity;
  }

  bool get _isValid {
    for (final group in widget.item.customizations) {
      if (group.required) {
        final selected = _selectedOptions[group.id] ?? [];
        if (selected.isEmpty) return false;
      }
    }
    return true;
  }

  void _onSingleOptionChanged(String groupId, String optionId) {
    setState(() => _selectedOptions[groupId] = [optionId]);
  }

  void _onMultiOptionChanged(String groupId, String optionId, bool selected) {
    final current = List<String>.from(_selectedOptions[groupId] ?? []);
    if (selected) {
      current.add(optionId);
    } else {
      current.remove(optionId);
    }
    setState(() => _selectedOptions[groupId] = current);
  }

  void _onAddToCart() {
    if (!_isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseSelectAllRequired)),
      );
      return;
    }

    final selectedCustomizations = <SelectedCustomization>[];
    for (final group in widget.item.customizations) {
      final selectedIds = _selectedOptions[group.id] ?? [];
      if (selectedIds.isEmpty) continue;
      final selectedOpts = group.options
          .where((o) => selectedIds.contains(o.id))
          .toList();
      if (selectedOpts.isNotEmpty) {
        selectedCustomizations.add(SelectedCustomization(
          group: group,
          selectedOptions: selectedOpts,
        ));
      }
    }

    widget.onAddToCart(_quantity, selectedCustomizations);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppTheme.successColor),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.addedToCart(widget.item.name)),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: widget.item.customizations.isNotEmpty ? 0.85 : 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surfaceMedium,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.textHint,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item header
                      _buildItemHeader(),
                      const SizedBox(height: 20),

                      // Customization groups
                      ...widget.item.customizations
                          .map((g) => _buildCustomizationGroup(g)),
                      const SizedBox(height: 80), // Space for bottom bar
                    ],
                  ),
                ),
              ),

              // Bottom bar
              _buildBottomBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            widget.item.imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, url, error) => Container(
              width: 80,
              height: 80,
              color: AppTheme.surfaceLight,
              child: const Icon(Icons.restaurant, color: AppTheme.textHint),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.item.description,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                Formatters.formatCurrency(widget.item.price),
                style: const TextStyle(
                  color: AppTheme.accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomizationGroup(CustomizationGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: AppTheme.surfaceLight, height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                group.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (group.required)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  AppLocalizations.of(context)!.required,
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (!group.required)
              Text(
                AppLocalizations.of(context)!.optional,
                style: TextStyle(color: AppTheme.textHint, fontSize: 12),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...group.options.map((option) {
          if (group.isSingleSelect) {
            return _buildRadioOption(group, option);
          } else {
            return _buildCheckboxOption(group, option);
          }
        }),
      ],
    );
  }

  Widget _buildRadioOption(CustomizationGroup group, CustomizationOption option) {
    final isSelected = (_selectedOptions[group.id] ?? []).contains(option.id);
    return GestureDetector(
      onTap: () => _onSingleOptionChanged(group.id, option.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentColor.withValues(alpha: 0.1)
              : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.accentColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppTheme.accentColor : AppTheme.textHint,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppTheme.accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option.name,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (option.priceModifier != 0)
              Text(
                Formatters.formatPrice(option.priceModifier, context),
                style: TextStyle(
                  color: isSelected ? AppTheme.accentColor : AppTheme.textHint,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxOption(CustomizationGroup group, CustomizationOption option) {
    final isSelected = (_selectedOptions[group.id] ?? []).contains(option.id);
    return GestureDetector(
      onTap: () => _onMultiOptionChanged(group.id, option.id, !isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentColor.withValues(alpha: 0.1)
              : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.accentColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.accentColor : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isSelected ? AppTheme.accentColor : AppTheme.textHint,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option.name,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (option.priceModifier != 0)
              Text(
                Formatters.formatPrice(option.priceModifier, context),
                style: TextStyle(
                  color: isSelected ? AppTheme.accentColor : AppTheme.textHint,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMedium,
        border: Border(top: BorderSide(color: AppTheme.surfaceLight)),
      ),
      child: Row(
        children: [
          // Quantity selector
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _QtyButton(
                  icon: Icons.remove,
                  onTap: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '$_quantity',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _QtyButton(
                  icon: Icons.add,
                  onTap: () => setState(() => _quantity++),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isValid ? _onAddToCart : null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: AppTheme.surfaceLight,
              ),
              child: Text(
                '${AppLocalizations.of(context)!.add} • ${Formatters.formatCurrency(_totalPrice)}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: onTap != null ? AppTheme.accentColor : AppTheme.textHint,
          size: 18,
        ),
      ),
    );
  }
}
