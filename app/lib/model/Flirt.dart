import 'dart:convert';
import 'dart:ui';

import 'package:app/comms/model/request/flirt/HostDisableFlirtByFlirtIdUserId.dart';
import 'package:app/comms/model/request/flirt/HostPutFlirtByUserIdRequest.dart';
import 'package:app/comms/model/response/flirt/HostPutFlirtByUserIdResponse.dart';
import 'package:app/model/Gender.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';

class Flirt {
  String id = "";
  String? userId;
  RelationShip? relationShip;
  SexAlternative? sexAlternative;
  Location? location;
  Gender? gender;
  int? updatedAt;
  int? status;
  int? age; 

  Flirt(this.id, this.userId, this.relationShip, this.sexAlternative,
      this.gender, this.location, this.updatedAt, this.status, this.age);
  Flirt.empty();

  factory Flirt.fromHost(Map<String, dynamic> map) {
    try {
      Log.d("Starts Flirt.fromHost: ${jsonEncode(map)}");
      if (map.isNotEmpty) {
        var location = Location(map["location"][1], map["location"][0]);
        var relationShip =
            RelationShip.load(map["user_interests"]["relationship"]);
        var sexAlternative =
            SexAlternative.load(map["user_interests"]["sex_alternative"]);
        var gender = Gender.fromJson(map["gender"]);
        var flirtId = map["flirt_id"];
        var userId = map["user_id"];
        var updatedAt = map["updated_at"];
        var status = map["status"];
        var age = map["age"];
        return Flirt(flirtId, userId, relationShip, sexAlternative, gender,
            location, updatedAt, status,age);
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return Flirt.empty();
  }

  void startFlirt(User user, Location location,
      Function(bool, Flirt?) onFlirtStartResult) async {
    Log.d("Starts startFlirt");
    try {
      HostPutFlirtByUserIdResponse response =
          await HostPutFlirtByUserIdRequest().run(user, location);
      bool status = response.flirt != null;
      onFlirtStartResult(status, response.flirt);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }

  Future<bool> stopFlirt(User user) async {
    Log.d("Start  stopFlirt");
    try {
      bool result = await HostDisableFlirtByFlirtIdUserId().run(user, this);
      return result;
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return false;
  }

  
}
