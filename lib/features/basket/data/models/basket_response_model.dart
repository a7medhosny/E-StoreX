import 'package:json_annotation/json_annotation.dart';
import 'basket_item_model.dart';

part 'basket_response_model.g.dart';

@JsonSerializable()
class BasketResponseModel {
  final String? id;
  final List<BasketItemModel>? basketItems;
  final double? discountValue;
  final double? percentage;
  final double? total;

  BasketResponseModel({
    required this.id,
    required this.basketItems,
    required this.discountValue,
    required this.percentage,
    required this.total,
  });

  factory BasketResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BasketResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$BasketResponseModelToJson(this);
}
