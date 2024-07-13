import 'package:json_annotation/json_annotation.dart';
part 'ProductList.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductList {
  String? success;
  Data? data;
  ProductList({this.success, this.data});

  factory ProductList.fromJson(Map<String, dynamic> json) =>
      _$ProductListFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListToJson(this);
}

@JsonSerializable()
class Data {
  List<Category>? category;

  Data({this.category});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Category {
  int? catid;
  String? name;
  String? image;
  List<Productlist>? productlist;

  Category({this.catid, this.name, this.image, this.productlist});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Productlist {
  int? id;
  String? name;
  double? price;
  String? category;
  String? description;
  String? image;
  int? stock;

  Productlist(
      {this.id,
      this.name,
      this.price,
      this.category,
      this.description,
      this.image,
      this.stock});

  factory Productlist.fromJson(Map<String, dynamic> json) =>
      _$ProductlistFromJson(json);

  Map<String, dynamic> toJson() => _$ProductlistToJson(this);
}
