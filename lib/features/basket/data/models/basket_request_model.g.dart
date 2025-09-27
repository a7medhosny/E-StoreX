// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasketRequestModel _$BasketRequestModelFromJson(Map<String, dynamic> json) =>
    BasketRequestModel(
      basketId: json['basketId'] as String?,
      basketItem:
          json['basketItem'] == null
              ? null
              : BasketItemModel.fromJson(
                json['basketItem'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$BasketRequestModelToJson(BasketRequestModel instance) =>
    <String, dynamic>{
      'basketId': instance.basketId,
      'basketItem': instance.basketItem,
    };
