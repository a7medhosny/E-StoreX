// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingAddress _$ShippingAddressFromJson(Map<String, dynamic> json) =>
    ShippingAddress(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      city: json['city'] as String?,
      zipCode: json['zipCode'] as String?,
      street: json['street'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$ShippingAddressToJson(ShippingAddress instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'city': instance.city,
      'zipCode': instance.zipCode,
      'street': instance.street,
      'state': instance.state,
    };
