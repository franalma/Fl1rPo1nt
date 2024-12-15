import 'dart:convert';

import 'package:app/model/ContactInfo.dart';
import 'package:app/model/SharingInfo.dart';
import 'package:app/ui/utils/Log.dart';

class UserMatch {
  String? matchId;
  String? flirtId;
  ContactInfo? contactInfo;
  SharingInfo? sharing;
  String? profileImage;
  int? pendingMessges; 


  UserMatch(this.matchId, this.flirtId, this.contactInfo, this.sharing,
      this.profileImage, this.pendingMessges);
  UserMatch.empty();

  factory UserMatch.fromJson(Map<String, dynamic> map) {
    Log.d("Starts  UserMatch.fromJson ${jsonEncode(map)}");
    try {
      String matchId = map["match_id"];
      String flirtId = map["flirt_id"];
      ContactInfo contactInfo = ContactInfo.fromJson(map["contact"]);
      SharingInfo sharing = SharingInfo.fromJson(map["sharing"]);
      String profileImage = "";

      
      if (map.containsKey("profile_image") && map["profile_image"] is Map) {
        profileImage = map["profile_image"]["url"];
      }
      int pendingMessges = map["pending_messages"];
      return UserMatch(matchId, flirtId, contactInfo, sharing, profileImage, pendingMessges);
    } catch (error, stackTrace) {
      Log.d("${error.toString()}  ${stackTrace.toString()}");
    }
    return UserMatch.empty();
  }
}
