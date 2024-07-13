// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductList _$ProductListFromJson(Map<String, dynamic> json) => ProductList(
      success: json['success'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductListToJson(ProductList instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data?.toJson(),
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      category: (json['category'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'category': instance.category,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      catid: (json['catid'] as num?)?.toInt(),
      name: json['name'] as String?,
      image: json['image'] as String?,
      productlist: (json['productlist'] as List<dynamic>?)
          ?.map((e) => Productlist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'catid': instance.catid,
      'name': instance.name,
      'image': instance.image,
      'productlist': instance.productlist,
    };

Productlist _$ProductlistFromJson(Map<String, dynamic> json) => Productlist(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      category: json['category'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      stock: (json['stock'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductlistToJson(Productlist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'category': instance.category,
      'description': instance.description,
      'image': instance.image,
      'stock': instance.stock,
    };
