import 'package:equatable/equatable.dart';
import 'customization_model.dart';
import 'menu_item_model.dart';

class SelectedCustomization extends Equatable {
  final CustomizationGroup group;
  final List<CustomizationOption> selectedOptions;

  const SelectedCustomization({
    required this.group,
    required this.selectedOptions,
  });

  double get totalModifier =>
      selectedOptions.fold(0.0, (sum, opt) => sum + opt.priceModifier);

  Map<String, dynamic> toJson() => {
        'customization_id': group.id,
        'option_ids': selectedOptions.map((o) => o.id).toList(),
      };

  SelectedCustomization copyWith({
    CustomizationGroup? group,
    List<CustomizationOption>? selectedOptions,
  }) {
    return SelectedCustomization(
      group: group ?? this.group,
      selectedOptions: selectedOptions ?? this.selectedOptions,
    );
  }

  @override
  List<Object?> get props => [group, selectedOptions];
}

class CartItem extends Equatable {
  final String cartItemId;
  final MenuItemModel menuItem;
  final int quantity;
  final List<SelectedCustomization> customizations;
  final String? note;

  const CartItem({
    required this.cartItemId,
    required this.menuItem,
    required this.quantity,
    required this.customizations,
    this.note,
  });

  double get unitPrice {
    final modifiers =
        customizations.fold(0.0, (sum, c) => sum + c.totalModifier);
    return menuItem.price + modifiers;
  }

  double get totalPrice => unitPrice * quantity;

  String get customizationsSummary {
    if (customizations.isEmpty) return '';
    final parts = <String>[];
    for (final c in customizations) {
      if (c.selectedOptions.isNotEmpty) {
        parts.add(c.selectedOptions.map((o) => o.name).join(', '));
      }
    }
    return parts.join(' · ');
  }

  CartItem copyWith({
    int? quantity,
    List<SelectedCustomization>? customizations,
    String? note,
  }) {
    return CartItem(
      cartItemId: cartItemId,
      menuItem: menuItem,
      quantity: quantity ?? this.quantity,
      customizations: customizations ?? this.customizations,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toOrderJson() => {
        'menu_item_id': menuItem.id,
        'quantity': quantity,
        'customizations':
            customizations.map((c) => c.toJson()).toList(),
        if (note != null && note!.isNotEmpty) 'note': note,
      };

  @override
  List<Object?> get props => [cartItemId, menuItem, quantity, customizations];
}
