import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:ipot_technical_test/data/models/menu_item_model.dart';
import 'package:ipot_technical_test/data/models/cart_item_model.dart';
import 'package:ipot_technical_test/data/models/customization_model.dart';
import 'package:ipot_technical_test/presentation/cart/cubit/cart_cubit.dart';

final _mockMenuItem = MenuItemModel(
  id: 'item_1',
  categoryId: 'cat_1',
  name: 'Tonkotsu Ramen',
  description: 'Delicious ramen',
  price: 95000,
  imageUrl: '',
  isAvailable: true,
  customizations: [],
);

final _spicyCustomization = SelectedCustomization(
  group: CustomizationGroup(
    id: 'spice',
    name: 'Spice Level',
    type: 'single',
    required: true,
    options: [
      const CustomizationOption(id: 'sp1', name: 'Mild', priceModifier: 0),
      const CustomizationOption(id: 'sp2', name: 'Spicy', priceModifier: 5000),
    ],
  ),
  selectedOptions: const [
    CustomizationOption(id: 'sp2', name: 'Spicy', priceModifier: 5000),
  ],
);

void main() {
  group('CartCubit Tests', () {
    late CartCubit cartCubit;

    setUp(() {
      cartCubit = CartCubit();
    });

    tearDown(() {
      cartCubit.close();
    });

    test('initial state is CartEmpty', () {
      expect(cartCubit.state, isA<CartEmpty>());
    });

    blocTest<CartCubit, CartState>(
      'adds item to empty cart',
      build: () => CartCubit(),
      act: (cubit) => cubit.addItem(menuItem: _mockMenuItem),
      expect: () => [
        isA<CartUpdated>().having((s) => (s).totalItems, 'totalItems', 1),
      ],
    );

    blocTest<CartCubit, CartState>(
      'adds item with quantity',
      build: () => CartCubit(),
      act: (cubit) => cubit.addItem(menuItem: _mockMenuItem, quantity: 3),
      expect: () => [
        isA<CartUpdated>().having((s) => (s).totalItems, 'totalItems', 3),
      ],
    );

    blocTest<CartCubit, CartState>(
      'calculates total price correctly without customizations',
      build: () => CartCubit(),
      act: (cubit) => cubit.addItem(menuItem: _mockMenuItem, quantity: 2),
      verify: (cubit) {
        final state = cubit.state as CartUpdated;
        expect(state.totalPrice, 95000 * 2);
      },
    );

    blocTest<CartCubit, CartState>(
      'calculates total price correctly with customization modifiers',
      build: () => CartCubit(),
      act: (cubit) => cubit.addItem(
        menuItem: _mockMenuItem,
        quantity: 1,
        customizations: [_spicyCustomization],
      ),
      verify: (cubit) {
        final state = cubit.state as CartUpdated;
        // Base price 95000 + spicy modifier 5000 = 100000
        expect(state.totalPrice, 100000);
      },
    );

    blocTest<CartCubit, CartState>(
      'merges identical items',
      build: () => CartCubit(),
      act: (cubit) {
        cubit.addItem(menuItem: _mockMenuItem);
        cubit.addItem(menuItem: _mockMenuItem);
      },
      verify: (cubit) {
        final state = cubit.state as CartUpdated;
        expect(state.items.length, 1); // Should be merged
        expect(state.totalItems, 2);
      },
    );

    blocTest<CartCubit, CartState>(
      'keeps different customization combinations separate',
      build: () => CartCubit(),
      act: (cubit) {
        cubit.addItem(menuItem: _mockMenuItem);
        cubit.addItem(
          menuItem: _mockMenuItem,
          customizations: [_spicyCustomization],
        );
      },
      verify: (cubit) {
        final state = cubit.state as CartUpdated;
        expect(
          state.items.length,
          2,
        ); // Different customizations = separate items
      },
    );

    blocTest<CartCubit, CartState>(
      'increments quantity',
      build: () => CartCubit(),
      seed: () {
        final cubit = CartCubit();
        cubit.addItem(menuItem: _mockMenuItem);
        return cubit.state;
      },
      act: (cubit) {
        final state = cubit.state as CartUpdated;
        cubit.incrementQuantity(state.items.first.cartItemId);
      },
      verify: (cubit) {
        final state = cubit.state as CartUpdated;
        expect(state.items.first.quantity, 2);
      },
    );

    blocTest<CartCubit, CartState>(
      'decrements quantity to 1',
      build: () {
        final cubit = CartCubit();
        cubit.addItem(menuItem: _mockMenuItem, quantity: 2);
        return cubit;
      },
      act: (cubit) {
        final state = cubit.state as CartUpdated;
        cubit.decrementQuantity(state.items.first.cartItemId);
      },
      verify: (cubit) {
        final state = cubit.state as CartUpdated;
        expect(state.items.first.quantity, 1);
      },
    );

    blocTest<CartCubit, CartState>(
      'removes item when quantity decremented to 0',
      build: () {
        final cubit = CartCubit();
        cubit.addItem(menuItem: _mockMenuItem, quantity: 1);
        return cubit;
      },
      act: (cubit) {
        final state = cubit.state as CartUpdated;
        cubit.decrementQuantity(state.items.first.cartItemId);
      },
      expect: () => [isA<CartEmpty>()],
    );

    blocTest<CartCubit, CartState>(
      'removes item directly',
      build: () {
        final cubit = CartCubit();
        cubit.addItem(menuItem: _mockMenuItem);
        return cubit;
      },
      act: (cubit) {
        final state = cubit.state as CartUpdated;
        cubit.removeItem(state.items.first.cartItemId);
      },
      expect: () => [isA<CartEmpty>()],
    );

    blocTest<CartCubit, CartState>(
      'clears cart',
      build: () {
        final cubit = CartCubit();
        cubit.addItem(menuItem: _mockMenuItem, quantity: 5);
        return cubit;
      },
      act: (cubit) => cubit.clearCart(),
      expect: () => [isA<CartEmpty>()],
    );

    blocTest<CartCubit, CartState>(
      'updates customer note',
      build: () {
        final cubit = CartCubit();
        cubit.addItem(menuItem: _mockMenuItem);
        return cubit;
      },
      act: (cubit) => cubit.updateNote('No onions please'),
      verify: (cubit) {
        final state = cubit.state as CartUpdated;
        expect(state.customerNote, 'No onions please');
      },
    );
  });

  group('CartItem model tests', () {
    test('calculates unitPrice with customization modifier', () {
      final item = CartItem(
        cartItemId: 'test_id',
        menuItem: _mockMenuItem,
        quantity: 2,
        customizations: [_spicyCustomization],
      );

      expect(item.unitPrice, 100000); // 95000 + 5000
      expect(item.totalPrice, 200000); // 100000 * 2
    });

    test('generates customizations summary', () {
      final item = CartItem(
        cartItemId: 'test_id',
        menuItem: _mockMenuItem,
        quantity: 1,
        customizations: [_spicyCustomization],
      );

      expect(item.customizationsSummary, 'Spicy');
    });

    test('empty customizations summary is empty string', () {
      final item = CartItem(
        cartItemId: 'test_id',
        menuItem: _mockMenuItem,
        quantity: 1,
        customizations: const [],
      );

      expect(item.customizationsSummary, '');
    });

    test('toOrderJson contains correct structure', () {
      final item = CartItem(
        cartItemId: 'test_id',
        menuItem: _mockMenuItem,
        quantity: 2,
        customizations: [_spicyCustomization],
      );

      final json = item.toOrderJson();
      expect(json['menu_item_id'], 'item_1');
      expect(json['quantity'], 2);
      expect(json['customizations'], isA<List>());
    });
  });
}
