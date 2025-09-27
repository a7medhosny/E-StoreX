import 'package:json_annotation/json_annotation.dart';
import 'basket_item_model.dart';

part 'basket_request_model.g.dart';

@JsonSerializable()
class BasketRequestModel {
  final String? basketId;
  final BasketItemModel? basketItem;

  BasketRequestModel({required this.basketId, required this.basketItem});

  factory BasketRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BasketRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$BasketRequestModelToJson(this);
}
