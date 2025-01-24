import '../../admin/adminModels/regmodel.dart';

class UserModel {
  String? userName;
  String? password;
  String? houseName;
  String? homeNo;
  String? location;
  String? district;
  shopModel? shopmo;
  String? pin;
  String? whatsAppNo;
  String? contactNo2;
  String? street;
  String? place;
  String? locality;
  String? country;
  String? latitude;
  String? longitude;

  UserModel(
    this.userName,
    this.password,
    this.houseName,
    this.homeNo,
    this.location,
    this.district,
    this.shopmo,
    this.pin,
    this.whatsAppNo,
    this.contactNo2,
    this.street,
    this.place,
    this.locality,
    this.country,
    this.latitude,
    this.longitude,
  );

  // From JSON
  UserModel.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        password = json['password'],
        houseName = json['houseName'],
        homeNo = json['homeNo'],
        location = json['location'],
        district = json['district'],
        shopmo = json['selectedSeller'] != null
            ? shopModel.fromJson(json['selectedSeller'])
            : null,
        pin = json['pin'],
        whatsAppNo = json['whatsAppNo'],
        contactNo2 = json['contactNo2'],
        street = json['street'],
        place = json['place'],
        locality = json['locality'],
        //  country = json['country'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  // To JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['password'] = password;
    data['houseName'] = houseName;
    data['homeNo'] = homeNo;
    data['location'] = location;
    data['district'] = district;
    data['selectedSeller'] = shopmo?.toJson();
    data['pin'] = pin;
    data['whatsAppNo'] = whatsAppNo;
    data['contactNo2'] = contactNo2;
    //data['street'] = street;
    //data['place'] = place;
    // data['locality'] = locality;
    //data['country'] = country;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
