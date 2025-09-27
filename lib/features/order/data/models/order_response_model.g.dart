// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponseModel _$OrderResponseModelFromJson(Map<String, dynamic> json) =>
    OrderResponseModel(
      id: json['id'] as String?,
      buyerEmail: json['buyerEmail'] as String?,
      orderDate:
          json['orderDate'] == null
              ? null
              : DateTime.parse(json['orderDate'] as String),
      status: json['status'] as String?,
      subTotal: json['subTotal'] as num?,
      total: json['total'] as num?,
      paymentIntentId: json['paymentIntentId'] as String?,
      shippingAddress:
          json['shippingAddress'] == null
              ? null
              : ShippingAddress.fromJson(
                json['shippingAddress'] as Map<String, dynamic>,
              ),
      deliveryMethod: json['deliveryMethod'] as String?,
      orderItems:
          (json['orderItems'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$OrderResponseModelToJson(OrderResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'buyerEmail': instance.buyerEmail,
      'orderDate': instance.orderDate?.toIso8601String(),
      'status': instance.status,
      'subTotal': instance.subTotal,
      'total': instance.total,
      'paymentIntentId': instance.paymentIntentId,
      'shippingAddress': instance.shippingAddress,
      'deliveryMethod': instance.deliveryMethod,
      'orderItems': instance.orderItems,
    };

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  productItemId: json['productItemId'] as String?,
  productName: json['productName'] as String?,
  mainImage: json['mainImage'] as String?,
  price: json['price'] as num?,
  quantity: (json['quantity'] as num?)?.toInt(),
);

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
  'productItemId': instance.productItemId,
  'productName': instance.productName,
  'mainImage': instance.mainImage,
  'price': instance.price,
  'quantity': instance.quantity,
};
