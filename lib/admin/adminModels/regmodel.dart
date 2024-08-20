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
