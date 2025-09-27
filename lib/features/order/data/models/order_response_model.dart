import 'package:ecommerce/features/order/data/models/shipping_address.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_response_model.g.dart';

@JsonSerializable()
class OrderResponseModel {
  final String? id;
  final String? buyerEmail;
  final DateTime? orderDate;
  final String? status;
  final num? subTotal;
  final num? total;
  final String? paymentIntentId;
  final ShippingAddress? shippingAddress;
  final String? deliveryMethod;
  final List<OrderItem>? orderItems;

  OrderResponseModel({
    this.id,
    this.buyerEmail,
    this.orderDate,
    this.status,
    this.subTotal,
    this.total,
    this.paymentIntentId,
    this.shippingAddress,
    this.deliveryMethod,
    this.orderItems,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseModelToJson(this);
}



@JsonSerializable()
class OrderItem {
  final String? productItemId;
  final String? productName;
  final String? mainImage;
  final num? price;
  final int? quantity;

  OrderItem({
    this.productItemId,
    this.productName,
    this.mainImage,
    this.price,
    this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
