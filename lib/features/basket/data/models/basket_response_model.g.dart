// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasketResponseModel _$BasketResponseModelFromJson(Map<String, dynamic> json) =>
    BasketResponseModel(
      id: json['id'] as String?,
      basketItems:
          (json['basketItems'] as List<dynamic>?)
              ?.map((e) => BasketItemModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      discountValue: (json['discountValue'] as num?)?.toDouble(),
      percentage: (json['percentage'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BasketResponseModelToJson(
  BasketResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'basketItems': instance.basketItems,
  'discountValue': instance.discountValue,
  'percentage': instance.percentage,
  'total': instance.total,
};
