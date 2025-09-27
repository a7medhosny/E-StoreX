import 'package:json_annotation/json_annotation.dart';

part 'basket_item_model.g.dart';

@JsonSerializable()
class BasketItemModel {
  final String? id;
  final String? name;
  final String? description;
  final int? qunatity;
  final double? price;
  final String? category;
  final String? image;

  BasketItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.qunatity,
    required this.price,
    required this.category,
    required this.image,
  });

  factory BasketItemModel.fromJson(Map<String, dynamic> json) => _$BasketItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$BasketItemModelToJson(this);
}
