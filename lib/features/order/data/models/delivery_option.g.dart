// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryOption _$DeliveryOptionFromJson(Map<String, dynamic> json) =>
    DeliveryOption(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      deliveryTime: json['deliveryTime'] as String?,
    );

Map<String, dynamic> _$DeliveryOptionToJson(DeliveryOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'deliveryTime': instance.deliveryTime,
    };
