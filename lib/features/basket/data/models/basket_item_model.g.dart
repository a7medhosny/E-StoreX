// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasketItemModel _$BasketItemModelFromJson(Map<String, dynamic> json) =>
    BasketItemModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      qunatity: (json['qunatity'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      category: json['category'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$BasketItemModelToJson(BasketItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'qunatity': instance.qunatity,
      'price': instance.price,
      'category': instance.category,
      'image': instance.image,
    };
