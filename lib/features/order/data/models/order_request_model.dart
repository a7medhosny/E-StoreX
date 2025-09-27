import 'package:ecommerce/features/order/data/models/shipping_address.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_request_model.g.dart';

@JsonSerializable()
class OrderRequestModel {
  final String? deliveryMethodId;
  final String? basketId;
  final ShippingAddress? shippingAddress;

  OrderRequestModel({
    this.deliveryMethodId,
    this.basketId,
    this.shippingAddress,
  });

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OrderRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderRequestModelToJson(this);
}


