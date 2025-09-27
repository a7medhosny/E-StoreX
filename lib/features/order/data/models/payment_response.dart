import 'package:json_annotation/json_annotation.dart';

part 'payment_response.g.dart';
@JsonSerializable()
class PaymentResponse {

  final String? paymentIntentId;
  final String? clientSecret;


  PaymentResponse({
    required this.paymentIntentId,
    required this.clientSecret,
 
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentResponseToJson(this);

}

