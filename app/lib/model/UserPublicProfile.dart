import 'package:app/model/Gender.dart';
import 'package:app/model/Hobby.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/utils/Log.dart';

import 'package:flutter/services.dart';

class UserPublicProfile {
  String? id;
  String? name;
  RelationShip? relationShip;
  SexAlternative? sexAlternative;
  Gender? genderInterest;
  Gender? gender;
  String? biography;
  String? profileImage;
  List<Hobby>? hobbies;
  String? defaultQrId;

  UserPublicProfile(
      this.id,
      this.name,
      this.relationShip,
      this.sexAlternative,
      this.genderInterest,
      this.gender,
      this.hobbies,
      this.biography,
      this.profileImage,
      this.defaultQrId);
  UserPublicProfile.empty();

  factory UserPublicProfile.fromJson(Map<String, dynamic> json) {
    Log.d("Starts UserPublicProfile.fromJson");
    try {
      var id = json["id"];
      var name = json["name"];
      var relationShip =
          RelationShip.load(json["user_interest"]["relationship"]);
      var sexAlternative =
          SexAlternative.load(json["user_interest"]["sex_alternative"]);

      var genderInterest =
          Gender.fromJson(json["user_interest"]["gender_preference"]);
      var gender = Gender.fromJson(json["gender"]);
      var biography = json["biography"];
      var hobbies =
          (json["hobbies"] as List).map((e) => Hobby.fromHost(e)).toList();
      var profileImage = json["profile_image"]["url"];

      var defaultQrId = json["default_qr_id"];

      return UserPublicProfile(
          id,
          name,
          relationShip,
          sexAlternative,
          genderInterest,
          gender,
          hobbies,
          biography,
          profileImage,
          defaultQrId);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }

    return UserPublicProfile.empty();
  }
}
