import 'package:app/model/Gender.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearByFlirt {
  String? userId;
  String? flirtId;
  LatLng? latLng;
  RelationShip? relationShip;
  SexAlternative? sexAlternative;
  Gender? genderInterest;

  NearByFlirt(this.userId, this.flirtId, this.latLng, this.relationShip,
      this.sexAlternative, this.genderInterest);
  NearByFlirt.empty();
  factory NearByFlirt.fromJson(Map<String, dynamic> json) {
    try {
      String userId = json["user_id"];
      String flirtId = json["flirt_id"];
      LatLng latLng = LatLng(json["location"][0], json["location"][1]);
      // RelationShip relationShip =
      //     RelationShip.load(json["user_interests"]["relationship"]);
      // SexAlternative sexAlternative =
      //     SexAlternative.load(json["user_interests"]["sex_alternative"]);
      // Gender genderInterest =
      //     Gender.fromJson(json["user_interests"]["gender_interest"]);
      return NearByFlirt(userId, flirtId, latLng, null, null, null);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return NearByFlirt.empty();
  }
}
