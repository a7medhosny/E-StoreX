import 'package:json_annotation/json_annotation.dart';
part 'shipping_address.g.dart';

@JsonSerializable()
class ShippingAddress {
  final String? firstName;
  final String? lastName;
  final String? city;
  final String? zipCode;
  final String? street;
  final String? state;

  ShippingAddress({
    this.firstName,
    this.lastName,
    this.city,
    this.zipCode,
    this.street,
    this.state,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);
}