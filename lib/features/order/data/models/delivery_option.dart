import 'package:json_annotation/json_annotation.dart';

part 'delivery_option.g.dart';

@JsonSerializable()
class DeliveryOption {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final String? deliveryTime;

  DeliveryOption({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.deliveryTime,
  });

  factory DeliveryOption.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOptionFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryOptionToJson(this);
}
