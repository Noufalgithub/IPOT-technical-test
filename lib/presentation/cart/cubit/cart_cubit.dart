import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/menu_item_model.dart';

// States
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartEmpty extends CartState {}

class CartUpdated extends CartState {
  final List<CartItem> items;
  final String? customerNote;

  const CartUpdated({required this.items, this.customerNote});

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  @override
  List<Object?> get props => [items, customerNote];
}

// Cubit
class CartCubit extends Cubit<CartState> {
  final _uuid = const Uuid();

  CartCubit() : super(CartEmpty());

  List<CartItem> get _currentItems {
    final s = state;
    return s is CartUpdated ? List.from(s.items) : [];
  }

  String? get _currentNote {
    final s = state;
    return s is CartUpdated ? s.customerNote : null;
  }

  int get totalItems {
    final s = state;
    return s is CartUpdated ? s.totalItems : 0;
  }

  void addItem({
    required MenuItemModel menuItem,
    int quantity = 1,
    List<SelectedCustomization> customizations = const [],
    String? note,
  }) {
    final items = _currentItems;

    // Check if identical item (same menu item + same customizations) already in cart
    final existingIndex = items.indexWhere(
      (i) =>
          i.menuItem.id == menuItem.id &&
          _customizationsMatch(i.customizations, customizations),
    );

    if (existingIndex != -1) {
      // Increment quantity
      items[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + quantity,
      );
    } else {
      items.add(CartItem(
        cartItemId: _uuid.v4(),
        menuItem: menuItem,
        quantity: quantity,
        customizations: customizations,
        note: note,
      ));
    }

    _emitUpdated(items);
  }

  void removeItem(String cartItemId) {
    final items = _currentItems..removeWhere((i) => i.cartItemId == cartItemId);
    _emitUpdated(items);
  }

  void incrementQuantity(String cartItemId) {
    final items = _currentItems;
    final index = items.indexWhere((i) => i.cartItemId == cartItemId);
    if (index != -1) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
      _emitUpdated(items);
    }
  }

  void decrementQuantity(String cartItemId) {
    final items = _currentItems;
    final index = items.indexWhere((i) => i.cartItemId == cartItemId);
    if (index != -1) {
      if (items[index].quantity <= 1) {
        items.removeAt(index);
      } else {
        items[index] =
            items[index].copyWith(quantity: items[index].quantity - 1);
      }
      _emitUpdated(items);
    }
  }

  void updateNote(String note) {
    final items = _currentItems;
    _emitUpdated(items, note: note);
  }

  void clearCart() {
    emit(CartEmpty());
  }

  void _emitUpdated(List<CartItem> items, {String? note}) {
    if (items.isEmpty) {
      emit(CartEmpty());
    } else {
      emit(CartUpdated(items: items, customerNote: note ?? _currentNote));
    }
  }

  bool _customizationsMatch(
    List<SelectedCustomization> a,
    List<SelectedCustomization> b,
  ) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].group.id != b[i].group.id) return false;
      final aIds = a[i].selectedOptions.map((o) => o.id).toSet();
      final bIds = b[i].selectedOptions.map((o) => o.id).toSet();
      if (!aIds.containsAll(bIds) || !bIds.containsAll(aIds)) return false;
    }
    return true;
  }
}
