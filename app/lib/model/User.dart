import 'dart:ui';

import 'package:app/comms/model/request/flirt/HostGetUserFlirtsRequest.dart';
import 'package:app/comms/model/request/user/profile/HostUpdateUserRadioVisibilityRequest.dart';
import 'package:app/model/Flirt.dart';
import 'package:app/model/Gender.dart';
import 'package:app/model/Hobby.dart';
import 'package:app/model/QrValue.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/model/Subscription.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/utils/CommonUtils.dart';
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
  late List<Hobby> hobbies = [];
  late String userProfileImageId;
  late int nScanned;
  late int nScansPerformed;
  late String qrDefaultId;
  late double radioVisibility;
  late Gender gender;
  late Gender genderInterest;
  late int bornDate; 
  late int age; 
  late Subscription subscription; 

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
      this.nScansPerformed,
      this.qrDefaultId,
      this.radioVisibility,
      this.gender,
      this.genderInterest,
      this.bornDate,
      this.age,
      this.subscription
      
      );

  User.empty();

  factory User.fromHost(Map<String, dynamic> json) {
    Log.d("Starts User.fromHost");
    try {
      var userId = json['user_id'];
      var name = json['name'];
      var phone = "";
      var biography = "";
      var city = "";
      var country = "";
      var mail = json['email'];
      var token = json['token'];
      var refreshToken = json['refresh_token'];
      List<SocialNetwork> networks = [];
      List<QrValue> qrValues = [];
      List<Hobby> hobbies = [];
      var userProfileImageId = "";
      int nScans = 0;
      int nScansPerformed = 0;
      String qrDefaultId = "";
      double radioVisibility = (json["radio_visibility"] as num).toDouble();
      Gender gender = Gender.empty();
      var relationShip = RelationShip.empty();
      SexAlternative sexAlternatives = SexAlternative.empty();
      Gender genderInterest = Gender.empty();
      var bornDate = json["born_date"];
      var age = DateTime.now().year - DateTime.fromMillisecondsSinceEpoch(bornDate).year;
      Subscription subscription = Subscription.fromJson(json["subscription"]);

      if (json["user_interests"]["relationship"] is Map) {
        relationShip =
            RelationShip.load(json["user_interests"]["relationship"]);
      }
      if (json["user_interests"]["sex_alternative"] is Map) {
        sexAlternatives =
            SexAlternative.load(json["user_interests"]["sex_alternative"]);
      }

      if (json["user_interests"]["gender_preference"] is Map) {
        genderInterest =
            Gender.fromJson(json["user_interests"]["gender_preference"]);
      }

      if (json.containsKey("networks")) {
        networks = (json["networks"] as List)
            .map((e) => SocialNetwork.load(e))
            .toList();
      }

      if (json.containsKey("qr_values")) {
        qrValues =
            (json["qr_values"] as List).map((e) => QrValue.load(e)).toList();
      }

      if (json.containsKey("hobbies")) {
        hobbies =
            (json["hobbies"] as List).map((e) => Hobby.fromHost(e)).toList();
      }

      if (json.containsKey("phone")) {
        phone = json['phone'].toString();
      }

      if (json.containsKey("biography")) {
        biography = json['biography'].toString();
      }

      if (json.containsKey("profile_image_id")) {
        userProfileImageId = json['profile_image_id'];
      }

      if (json.containsKey("scanned_count")) {
        nScans = json['scanned_count'];
      }

      if (json.containsKey("scans_performed")) {
        nScansPerformed = json['scans_performed'];
      }

      if (json.containsKey("default_qr_id")) {
        qrDefaultId = json['default_qr_id'];
      }

      if (json.containsKey("gender")) {
        gender = Gender.fromJson(json["gender"]);
      }

      User user = User(
          userId,
          name,
          phone,
          mail,
          city,
          country,
          token,
          refreshToken,
          networks,
          qrValues,
          relationShip,
          sexAlternatives,
          biography,
          hobbies,
          userProfileImageId,
          nScans,
          nScansPerformed,
          qrDefaultId,
          radioVisibility,
          gender,
          genderInterest,
          bornDate,
          age,
          subscription);      

      return user;
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }

    return User.empty();
  }

  Future<Flirt?> getUserActiveFlirt() async {
    try {
      var response = await HostGetUserFlirtsRequest().run(userId, 1);
      if (response.flirts != null && response.flirts!.isNotEmpty) {
        return response.flirts![0];
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return null;
  }

  Future<bool> updateUserVisibility(double value) async {
    try {
      if (radioVisibility != value) {
        var result = HostUpdateUserRadioVisibilityRequest().run(userId, value);
        return result;
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return false;
  }

  Future<Flirt?> getActiveFlirtByUserId() async {
    try {
      var response = await HostGetUserFlirtsRequest().run(userId, 1);

      if (response.flirts != null && response.flirts!.isNotEmpty) {
        return response.flirts![0];
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return null;
  }

  Color getSexAlternativeColor() {
    return Color(CommonUtils.colorToInt(sexAlternatives.color));
  }

  Color getRelationshipColor() {
    return Color(CommonUtils.colorToInt(relationShip.color));
  }

   Color getLookingForGenderColor() {
    return Color(CommonUtils.colorToInt(genderInterest.color!));
  }

   Color getGenderColor() {
    return Color(CommonUtils.colorToInt(gender.color!));
  }
}
