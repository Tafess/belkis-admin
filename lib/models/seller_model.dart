import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  Seller({
    this.approved,
    this.buisnessName,
    this.city,
    this.region,
    this.country,
    this.email,
    this.landmark,
    this.logo,
    this.shopImage,
    this.mobile,
    this.pincode,
    this.taxRegistered,
    this.time,
    this.tinNumber,
    this.uid,
  });

  Seller.fromJson(Map<String, Object?> json)
      : this(
          approved: json['approved']! as bool,
          buisnessName: json['buisnessName']! as String,
          city: json['city']! as String,
          region: json['region']! as String,
          country: json['country']! as String,
          email: json['email']! as String,
          landmark: json['landmark']! as String,
          logo: json['logo']! as String,
          shopImage: json['buisnessName']! as String,
          mobile: json['mobile']! as String,
          pincode: json['pincode']! as String,
          taxRegistered: json['taxRegistered']! as String,
          time: json['time']! as Timestamp,
          tinNumber: json['tinNumber']! as String,
          uid: json['uid']! as String,
        );

  final bool? approved;
  final String? buisnessName;
  final String? city;
  final String? region;
  final String? country;
  final String? email;
  final String? landmark;
  final String? logo;
  final String? shopImage;
  final String? mobile;
  final String? pincode;
  final String? taxRegistered;
  final Timestamp? time;
  final String? tinNumber;
  final String? uid;

  Map<String, Object?> toJson() {
    return {
      'approved': approved,
      'buisnessName': buisnessName,
      'city': city,
      'region': region,
      'country': country,
      'email': email,
      'landmark': landmark,
      'logo': logo,
      'shopImage': shopImage,
      'mobile': mobile,
      'pincode': pincode,
      'taxRegistered': taxRegistered,
      'time': time,
      'tinNumber': tinNumber,
      'uid': uid,
    };
  }
}
