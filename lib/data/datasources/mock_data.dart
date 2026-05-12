import '../models/category_model.dart';
import '../models/menu_item_model.dart';
import '../models/customization_model.dart';
import '../models/order_model.dart';

class MockData {
  MockData._();

  static List<CategoryModel> getMenuCategories() {
    return [
      CategoryModel(
        id: 'cat_1',
        name: 'Makanan Pembuka',
        sortOrder: 1,
        items: [
          MenuItemModel(
            id: 'item_1',
            categoryId: 'cat_1',
            name: 'Edamame',
            description: 'Kedelai Jepang rebus dengan taburan garam laut',
            price: 25000,
            imageUrl: 'https://images.unsplash.com/photo-1564671165093-20688ff1fffa?w=400',
            isAvailable: true,
            customizations: [
              CustomizationGroup(
                id: 'cg_1',
                name: 'Rasa',
                type: 'single',
                required: false,
                options: [
                  const CustomizationOption(id: 'co_1', name: 'Original', priceModifier: 0),
                  const CustomizationOption(id: 'co_2', name: 'Pedas', priceModifier: 0),
                  const CustomizationOption(id: 'co_3', name: 'Garlic Butter', priceModifier: 5000),
                ],
              ),
            ],
          ),
          MenuItemModel(
            id: 'item_2',
            categoryId: 'cat_1',
            name: 'Gyoza (6 pcs)',
            description: 'Pangsit goreng isi daging babi & sayuran, disajikan dengan saus ponzu',
            price: 55000,
            imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
            isAvailable: true,
            customizations: [
              CustomizationGroup(
                id: 'cg_2',
                name: 'Cara Masak',
                type: 'single',
                required: true,
                options: [
                  const CustomizationOption(id: 'co_4', name: 'Goreng (Pan-fried)', priceModifier: 0),
                  const CustomizationOption(id: 'co_5', name: 'Kukus (Steamed)', priceModifier: 0),
                ],
              ),
              CustomizationGroup(
                id: 'cg_3',
                name: 'Tambahan',
                type: 'multiple',
                required: false,
                options: [
                  const CustomizationOption(id: 'co_6', name: 'Extra Saus', priceModifier: 5000),
                  const CustomizationOption(id: 'co_7', name: 'Extra Cabai', priceModifier: 0),
                ],
              ),
            ],
          ),
        ],
      ),
      CategoryModel(
        id: 'cat_2',
        name: 'Ramen',
        sortOrder: 2,
        items: [
          MenuItemModel(
            id: 'item_3',
            categoryId: 'cat_2',
            name: 'Tonkotsu Ramen',
            description: 'Kuah kaldu babi kental dengan chashu, telur ajitsuke, nori, dan acar bambu',
            price: 95000,
            imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400',
            isAvailable: true,
            estimatedPrepTime: 12,
            customizations: [
              CustomizationGroup(
                id: 'cg_4',
                name: 'Tingkat Kepedasan',
                type: 'single',
                required: false,
                options: [
                  const CustomizationOption(id: 'co_8', name: 'Tidak Pedas', priceModifier: 0),
                  const CustomizationOption(id: 'co_9', name: 'Sedang', priceModifier: 0),
                  const CustomizationOption(id: 'co_10', name: 'Pedas', priceModifier: 0),
                  const CustomizationOption(id: 'co_11', name: 'Extra Pedas', priceModifier: 0),
                ],
              ),
              CustomizationGroup(
                id: 'cg_5',
                name: 'Topping Tambahan',
                type: 'multiple',
                required: false,
                options: [
                  const CustomizationOption(id: 'co_12', name: 'Extra Chashu', priceModifier: 20000),
                  const CustomizationOption(id: 'co_13', name: 'Extra Telur', priceModifier: 12000),
                  const CustomizationOption(id: 'co_14', name: 'Corn Butter', priceModifier: 8000),
                  const CustomizationOption(id: 'co_15', name: 'Extra Nori', priceModifier: 5000),
                ],
              ),
            ],
          ),
          MenuItemModel(
            id: 'item_4',
            categoryId: 'cat_2',
            name: 'Shoyu Ramen',
            description: 'Kuah kaldu ayam berbumbu kecap asin dengan ayam panggang, daun bawang, dan bamboo shoot',
            price: 85000,
            imageUrl: 'https://images.unsplash.com/photo-1591814468924-caf88d1232e1?w=400',
            isAvailable: true,
            estimatedPrepTime: 10,
            customizations: [
              CustomizationGroup(
                id: 'cg_6',
                name: 'Ketebalan Mie',
                type: 'single',
                required: false,
                options: [
                  const CustomizationOption(id: 'co_16', name: 'Tipis', priceModifier: 0),
                  const CustomizationOption(id: 'co_17', name: 'Sedang', priceModifier: 0),
                  const CustomizationOption(id: 'co_18', name: 'Tebal', priceModifier: 0),
                ],
              ),
              CustomizationGroup(
                id: 'cg_7',
                name: 'Topping Tambahan',
                type: 'multiple',
                required: false,
                options: [
                  const CustomizationOption(id: 'co_19', name: 'Extra Ayam', priceModifier: 20000),
                  const CustomizationOption(id: 'co_20', name: 'Extra Telur', priceModifier: 12000),
                  const CustomizationOption(id: 'co_21', name: 'Extra Nori', priceModifier: 5000),
                ],
              ),
            ],
          ),
          MenuItemModel(
            id: 'item_5',
            categoryId: 'cat_2',
            name: 'Miso Ramen',
            description: 'Kuah kaldu berbumbu miso dengan corn, mentega, dan topping sayuran segar',
            price: 88000,
            imageUrl: 'https://images.unsplash.com/photo-1614563368073-a5d7c478d481?w=400',
            isAvailable: false,
            estimatedPrepTime: 10,
            customizations: [],
          ),
        ],
      ),
      CategoryModel(
        id: 'cat_3',
        name: 'Nasi & Donburi',
        sortOrder: 3,
        items: [
          MenuItemModel(
            id: 'item_6',
            categoryId: 'cat_3',
            name: 'Chashu Don',
            description: 'Nasi Jepang dengan irisan chashu babi, telur onsen, dan saus tare',
            price: 78000,
            imageUrl: 'https://images.unsplash.com/photo-1547592180-85f173990554?w=400',
            isAvailable: true,
            estimatedPrepTime: 8,
            customizations: [
              CustomizationGroup(
                id: 'cg_8',
                name: 'Ukuran',
                type: 'single',
                required: true,
                options: [
                  const CustomizationOption(id: 'co_22', name: 'Regular', priceModifier: 0),
                  const CustomizationOption(id: 'co_23', name: 'Large', priceModifier: 15000),
                ],
              ),
            ],
          ),
          MenuItemModel(
            id: 'item_7',
            categoryId: 'cat_3',
            name: 'Karaage Don',
            description: 'Nasi dengan ayam goreng gaya Jepang yang renyah, disajikan dengan saus tartar',
            price: 72000,
            imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
            isAvailable: true,
            estimatedPrepTime: 10,
            customizations: [
              CustomizationGroup(
                id: 'cg_9',
                name: 'Tingkat Kepedasan',
                type: 'single',
                required: false,
                options: [
                  const CustomizationOption(id: 'co_24', name: 'Original', priceModifier: 0),
                  const CustomizationOption(id: 'co_25', name: 'Spicy', priceModifier: 0),
                ],
              ),
            ],
          ),
        ],
      ),
      CategoryModel(
        id: 'cat_4',
        name: 'Minuman',
        sortOrder: 4,
        items: [
          MenuItemModel(
            id: 'item_8',
            categoryId: 'cat_4',
            name: 'Matcha Latte',
            description: 'Matcha premium Uji dengan susu oat yang creamy',
            price: 45000,
            imageUrl: 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=400',
            isAvailable: true,
            customizations: [
              CustomizationGroup(
                id: 'cg_10',
                name: 'Tingkat Kemanisan',
                type: 'single',
                required: false,
                options: [
                  const CustomizationOption(id: 'co_26', name: '100% (Normal)', priceModifier: 0),
                  const CustomizationOption(id: 'co_27', name: '70%', priceModifier: 0),
                  const CustomizationOption(id: 'co_28', name: '50%', priceModifier: 0),
                  const CustomizationOption(id: 'co_29', name: 'Tanpa Gula', priceModifier: 0),
                ],
              ),
              CustomizationGroup(
                id: 'cg_11',
                name: 'Jenis Susu',
                type: 'single',
                required: false,
                options: [
                  const CustomizationOption(id: 'co_30', name: 'Full Cream', priceModifier: 0),
                  const CustomizationOption(id: 'co_31', name: 'Oat Milk', priceModifier: 8000),
                  const CustomizationOption(id: 'co_32', name: 'Almond Milk', priceModifier: 10000),
                ],
              ),
            ],
          ),
          MenuItemModel(
            id: 'item_9',
            categoryId: 'cat_4',
            name: 'Yuzu Lemonade',
            description: 'Minuman segar dengan jeruk yuzu Jepang, lemon, dan soda',
            price: 38000,
            imageUrl: 'https://images.unsplash.com/photo-1523677011781-c91d1bbe2f9e?w=400',
            isAvailable: true,
            customizations: [
              CustomizationGroup(
                id: 'cg_12',
                name: 'Tingkat Kemanisan',
                type: 'single',
                required: false,
                options: [
                  const CustomizationOption(id: 'co_33', name: 'Normal', priceModifier: 0),
                  const CustomizationOption(id: 'co_34', name: 'Kurang Manis', priceModifier: 0),
                  const CustomizationOption(id: 'co_35', name: 'Tanpa Gula', priceModifier: 0),
                ],
              ),
            ],
          ),
          MenuItemModel(
            id: 'item_10',
            categoryId: 'cat_4',
            name: 'Ocha (Green Tea)',
            description: 'Teh hijau Jepang panas atau dingin',
            price: 28000,
            imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
            isAvailable: true,
            customizations: [
              CustomizationGroup(
                id: 'cg_13',
                name: 'Suhu',
                type: 'single',
                required: true,
                options: [
                  const CustomizationOption(id: 'co_36', name: 'Panas', priceModifier: 0),
                  const CustomizationOption(id: 'co_37', name: 'Dingin', priceModifier: 0),
                ],
              ),
            ],
          ),
        ],
      ),
      CategoryModel(
        id: 'cat_5',
        name: 'Dessert',
        sortOrder: 5,
        items: [
          MenuItemModel(
            id: 'item_11',
            categoryId: 'cat_5',
            name: 'Matcha Ice Cream',
            description: 'Es krim matcha premium dengan topping mochi dan azuki bean',
            price: 42000,
            imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400',
            isAvailable: true,
            customizations: [
              CustomizationGroup(
                id: 'cg_14',
                name: 'Topping',
                type: 'multiple',
                required: false,
                options: [
                  const CustomizationOption(id: 'co_38', name: 'Mochi', priceModifier: 8000),
                  const CustomizationOption(id: 'co_39', name: 'Azuki Bean', priceModifier: 5000),
                  const CustomizationOption(id: 'co_40', name: 'Wafer', priceModifier: 3000),
                ],
              ),
            ],
          ),
        ],
      ),
    ];
  }

  static OrderModel getMockOrder(String tableId) {
    return OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      tableId: tableId,
      items: [
        const OrderItem(
          menuItemId: 'item_3',
          menuItemName: 'Tonkotsu Ramen',
          quantity: 1,
          unitPrice: 95000,
          customizations: [],
        ),
      ],
      status: OrderStatus.pending,
      totalAmount: 95000,
      createdAt: DateTime.now(),
      estimatedPrepTime: 12,
    );
  }
}
