import 'package:app/model/ContactInfo.dart';
import 'package:app/model/SharingInfo.dart';
import 'package:app/ui/utils/Log.dart';

class UserMatch {
  String? matchId;
  String? flirtId;
  ContactInfo? contactInfo;
  SharingInfo? sharing;

  UserMatch(this.matchId, this.flirtId, this.contactInfo, this.sharing);
  UserMatch.empty();

  factory UserMatch.fromJson(Map<String, dynamic> map) {
    Log.d("Starts  UserMatch.fromJson ");
    try {
      String matchId =  map["match_id"];
      String flirtId=  map["flirt_id"];       
      ContactInfo contactInfo = ContactInfo.fromJson(map["contact"]);      
      SharingInfo sharing =  SharingInfo.fromJson(map["sharing"]); 
      return UserMatch(matchId, flirtId, contactInfo, sharing);
    } catch (error, stackTrace) {
      Log.d("${error.toString()}  ${stackTrace.toString()}");
    }
    return UserMatch.empty();
  }
}
