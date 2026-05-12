import 'package:equatable/equatable.dart';
import 'menu_item_model.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final int sortOrder;
  final List<MenuItemModel> items;

  const CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.sortOrder,
    required this.items,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image_url'],
      sortOrder: json['sort_order'] ?? 0,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((i) => MenuItemModel.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, name, sortOrder];
}
