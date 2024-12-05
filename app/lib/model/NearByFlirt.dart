import 'package:app/ui/utils/Log.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearByFlirt {
  String? userId;
  String? flirtId;
  LatLng? latLng;
  String? relationShipName;

  NearByFlirt(this.userId, this.flirtId, this.latLng, this.relationShipName);
  NearByFlirt.empty();
  factory NearByFlirt.fromJson(Map<String, dynamic> json) {
    try {
      String userId = json["user_id"];
      String flirtId = json["flirt_id"];
      LatLng latLng = LatLng(json["location"][0], json["location"][1]);
      String relationShipName = json["relationship_name"];
      return NearByFlirt(userId, flirtId, latLng, relationShipName);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return NearByFlirt.empty();
  }
}
