// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRequestModel _$OrderRequestModelFromJson(Map<String, dynamic> json) =>
    OrderRequestModel(
      deliveryMethodId: json['deliveryMethodId'] as String?,
      basketId: json['basketId'] as String?,
      shippingAddress:
          json['shippingAddress'] == null
              ? null
              : ShippingAddress.fromJson(
                json['shippingAddress'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$OrderRequestModelToJson(OrderRequestModel instance) =>
    <String, dynamic>{
      'deliveryMethodId': instance.deliveryMethodId,
      'basketId': instance.basketId,
      'shippingAddress': instance.shippingAddress,
    };
