// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentResponse _$PaymentResponseFromJson(Map<String, dynamic> json) =>
    PaymentResponse(
      paymentIntentId: json['paymentIntentId'] as String?,
      clientSecret: json['clientSecret'] as String?,
    );

Map<String, dynamic> _$PaymentResponseToJson(PaymentResponse instance) =>
    <String, dynamic>{
      'paymentIntentId': instance.paymentIntentId,
      'clientSecret': instance.clientSecret,
    };
