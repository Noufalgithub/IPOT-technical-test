import 'package:equatable/equatable.dart';

class CustomizationOption extends Equatable {
  final String id;
  final String name;
  final double priceModifier;

  const CustomizationOption({
    required this.id,
    required this.name,
    required this.priceModifier,
  });

  factory CustomizationOption.fromJson(Map<String, dynamic> json) {
    return CustomizationOption(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      priceModifier: (json['price_modifier'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price_modifier': priceModifier,
      };

  @override
  List<Object?> get props => [id, name, priceModifier];
}

class CustomizationGroup extends Equatable {
  final String id;
  final String name;
  final String type; // 'single' or 'multiple'
  final bool required;
  final List<CustomizationOption> options;

  const CustomizationGroup({
    required this.id,
    required this.name,
    required this.type,
    required this.required,
    required this.options,
  });

  bool get isSingleSelect => type == 'single';
  bool get isMultipleSelect => type == 'multiple';

  factory CustomizationGroup.fromJson(Map<String, dynamic> json) {
    return CustomizationGroup(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'single',
      required: json['required'] ?? false,
      options: (json['options'] as List<dynamic>? ?? [])
          .map((o) => CustomizationOption.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'required': required,
        'options': options.map((o) => o.toJson()).toList(),
      };

  @override
  List<Object?> get props => [id, name, type, required, options];
}
