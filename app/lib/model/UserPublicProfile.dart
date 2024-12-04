

import 'package:app/model/Gender.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/utils/Log.dart';

import 'package:flutter/services.dart';

class UserPublicProfile {
  String? id;
  RelationShip? relationShip;
  SexAlternative? sexAlternative;
  Gender? gender;
  String? biography;
  String? profileImage;
  List<dynamic>? hobbies;

  UserPublicProfile(this.id, this.relationShip, this.sexAlternative,
      this.gender, this.hobbies, this.biography, this.profileImage);
  UserPublicProfile.empty();

  factory UserPublicProfile.fromJson(Map<String, dynamic> json) {
    Log.d("Starts UserPublicProfile.fromJson");
    try {
      var id = json["id"];
      var relationShip =
          RelationShip.load(json["user_interest"]["relationship"]);
      var sexAlternative =
          SexAlternative.load(json["user_interest"]["sex_alternative"]);
      var gender = Gender.fromJson(json["gender"]);
      var biography = json["biography"];
      var hobbies = json["hobbies"];
      var profileImage= json["profile_image_file_id"];

      // if (json.containsKey("profile_image")) {
      //   Uint8List buffer = base64Decode(json["profile_image"]);
      //   profileImage = MemoryImage(buffer);
      // }
      return UserPublicProfile(id, relationShip, sexAlternative, gender, hobbies, biography, profileImage);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }

    return UserPublicProfile.empty();
  }
}
