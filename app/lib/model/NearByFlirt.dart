import 'dart:convert';
import 'dart:ui';

import 'package:app/model/Gender.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearByFlirt {
  String? name; 
  String? userId;
  String? flirtId;
  LatLng? latLng;
  RelationShip? relationShip;
  SexAlternative? sexAlternative;
  Gender? genderInterest;
  Gender? gender;
  int? age;
  double? distance; 

  NearByFlirt(this.userId, this.flirtId, this.latLng, this.relationShip,
      this.sexAlternative, this.genderInterest, this.gender, this.age, this.name, this.distance);
  NearByFlirt.empty();
  factory NearByFlirt.fromJson(Map<String, dynamic> json) {
    try {
      Log.d("Starts NearByFlirt.fromJson ${jsonEncode(json)}");
      String userId = json["user_id"];
      String flirtId = json["flirt_id"];
      LatLng latLng = LatLng(json["location"][0], json["location"][1]);
      RelationShip relationShip =
          RelationShip.load(json["user_interests"]["relationship"]);
      SexAlternative sexAlternative =
          SexAlternative.load(json["user_interests"]["sex_alternative"]);
      Gender genderInterest =
          Gender.fromJson(json["user_interests"]["gender_interest"]);
      Gender gender = Gender.fromJson(json["gender"]);
      int age = json["age"];
      String name = json["name"];
      double distance = json["distance"];
      

      return NearByFlirt(userId, flirtId, latLng, relationShip, sexAlternative,
          genderInterest, gender, age, name, distance);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return NearByFlirt.empty();
  }

  Color getSexAlternativeColor() {
    return Color(CommonUtils.colorToInt(sexAlternative!.color));
  }

  Color getRelationshipColor() {
    return Color(CommonUtils.colorToInt(relationShip!.color));
  }
}
