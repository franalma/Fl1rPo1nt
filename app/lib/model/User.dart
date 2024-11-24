
import 'package:app/comms/model/response/auth/HostLoginResponse.dart';
import 'package:app/model/QrValue.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/utils/Log.dart';

class User {
  late String userId;
  late String name;
  late String phone;
  late String email;
  late String city;
  late String country;
  late String token;
  late List<QrValue> qrValues;
  late RelationShip relationShip;
  late SexAlternative sexAlternatives;
  late List<SocialNetwork> networks;
  late int exploringMaxRadion;
  bool isFlirting = false;
  late String biography;
  late String refreshToken;
  late List<dynamic> hobbies = [];
  late String userProfileImageId;
  late int nScanned; 
  late int nScansPerformed; 

  User(
      this.userId,
      this.name,
      this.phone,
      this.email,
      this.city,
      this.country,
      this.token,
      this.refreshToken,
      this.networks,
      this.qrValues,
      this.relationShip,
      this.sexAlternatives,
      this.biography,
      this.hobbies,
      this.userProfileImageId, 
      this.nScanned, 
      this.nScansPerformed);

  User.empty();
  factory User.fromHost(HostLoginResponse response) {
    Log.d("User starts fromHost");
    try {
      List<SocialNetwork> networks = [];
      List<QrValue> qrValues = [];
      SexAlternative sexAlternatives;
      RelationShip relationShip;
      String userProfileImageId =""; 

      if (response.networks.isNotEmpty) {
        networks = response.networks.map((e) => SocialNetwork.load(e)).toList();
      }

      if (response.qrValues.isNotEmpty) {
        qrValues = response.qrValues.map((e) => QrValue.load(e)).toList();
      }

      if (response.relationShip.isNotEmpty) {
        relationShip = RelationShip.load(response.relationShip);
      } else {
        relationShip = RelationShip.empty();
      }

      if (response.sexAlternatives.isNotEmpty) {
        sexAlternatives = SexAlternative.load(response.sexAlternatives);
      } else {
        sexAlternatives = SexAlternative.empty();
      }

      if (response.userProfileImageId.isNotEmpty) {
        userProfileImageId = response.userProfileImageId;
      } 

  
      return User(
          response.userId,
          response.name,
          response.phone,
          response.mail,
          "",
          "",
          response.token,
          response.resfreshToken,
          networks,
          qrValues,
          relationShip,
          sexAlternatives,
          response.biography,
          response.hobbies,
          userProfileImageId,
          response.nScanned, 
          response.nScansPerformed);
    } catch (error) {
      Log.d(error.toString());
    }
    return User.empty();
  }
}
