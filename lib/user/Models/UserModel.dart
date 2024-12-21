import '../../admin/adminModels/regmodel.dart';

class UserModel {
  String UserName;
  String Password;
  String HouseName;
  String HomeNo;
  String location;
  String District;
  shopModel shopmo;
  String pin;
  String whatsAppNo;
  String ContactNo2;

  String street;
  String place;
  String locality;
  String country;
  String latitude;
  String longitude;

  UserModel(
      this.UserName,
      this.Password,
      this.HouseName,
      this.HomeNo,
      this.location,
      this.District,
      this.shopmo,
      this.pin,
      this.whatsAppNo,
      this.ContactNo2,
      this.street,
      this.place,
      this.locality,
      this.country,
      this.latitude,
      this.longitude);
}
