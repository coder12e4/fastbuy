import 'package:equatable/equatable.dart';

class ShopRegDetails {
  String email;
  String password;
  String name;
  bool seller;
  String address;
  String contact;
  String deliveryVehicleNo;
  String shopAddress;
  String userId;

  ShopRegDetails(
      this.email,
      this.password,
      this.name,
      this.seller,
      this.address,
      this.contact,
      this.deliveryVehicleNo,
      this.shopAddress,
      this.userId);
}

class Person {
  String id;
  Person(this.id);
}

class shopModel extends Equatable {
  final String? address;
  final String? contact;
  final String? deliveryVehicleNo;
  final String? email;
  final String? name;
  final bool? seller;
  final String? sellerfcm;
  final String? shopAddress;
  final String? userId;

  shopModel(
      {this.address,
      this.contact,
      this.deliveryVehicleNo,
      this.email,
      this.name,
      this.seller,
      this.shopAddress,
      this.sellerfcm,
      this.userId});

  shopModel.fromJson(Map<String, dynamic> json)
      : address = json['address'],
        contact = json['contact'],
        deliveryVehicleNo = json['deliveryVehicleNo'],
        email = json['email'],
        name = json['name'],
        seller = json['seller'],
        shopAddress = json['shop address'],
        sellerfcm = json['sellerfcm'],
        userId = json['userId'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['contact'] = this.contact;
    data['deliveryVehicleNo'] = this.deliveryVehicleNo;
    data['email'] = this.email;
    data['name'] = this.name;
    data['seller'] = this.seller;
    data['shop address'] = this.shopAddress;
    data['sellerfcm'] = this.sellerfcm;
    data['userId'] = this.userId;
    return data;
  }

  shopModel.fromMap(Map<String, dynamic> map, String id)
      : address = map['address'],
        contact = map['contact'],
        deliveryVehicleNo = map['deliveryVehicleNo'],
        email = map['email'],
        name = map['name'],
        seller = map['seller'],
        shopAddress = map['shop address'],
        sellerfcm = map["sellerfcm"],
        userId = map['userId'];

  @override
  List<Object?> get props => [
        address,
        contact,
        deliveryVehicleNo,
        email,
        name,
        seller,
        shopAddress,
        sellerfcm,
        userId,
      ];
}
