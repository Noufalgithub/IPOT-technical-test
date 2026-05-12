import 'package:equatable/equatable.dart';
import 'customization_model.dart';

class MenuItemModel extends Equatable {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isAvailable;
  final List<CustomizationGroup> customizations;
  final String? allergens;
  final int? estimatedPrepTime; // in minutes

  const MenuItemModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
    required this.customizations,
    this.allergens,
    this.estimatedPrepTime,
  });

  bool get hasCustomizations => customizations.isNotEmpty;

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['image_url'] ?? '',
      isAvailable: json['is_available'] ?? true,
      customizations: (json['customizations'] as List<dynamic>? ?? [])
          .map((c) => CustomizationGroup.fromJson(c as Map<String, dynamic>))
          .toList(),
      allergens: json['allergens'],
      estimatedPrepTime: json['estimated_prep_time'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category_id': categoryId,
        'name': name,
        'description': description,
        'price': price,
        'image_url': imageUrl,
        'is_available': isAvailable,
        'customizations': customizations.map((c) => c.toJson()).toList(),
        'allergens': allergens,
        'estimated_prep_time': estimatedPrepTime,
      };

  @override
  List<Object?> get props => [id, categoryId, name, price, isAvailable];
}
