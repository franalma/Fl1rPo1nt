import 'package:app/model/Gender.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/utils/Log.dart';

class UserPublicProfile{
  String? id; 
  RelationShip? relationShip; 
  SexAlternative? sexAlternative; 
  Gender? gender; 
  String? profileImage; 

  UserPublicProfile(this.id, this.relationShip, this.sexAlternative, this.gender, this.profileImage);
  UserPublicProfile.empty(); 

  factory UserPublicProfile.fromJson(Map<String, dynamic>json){
    Log.d("Starts UserPublicProfile.fromJson");
    try{

    }catch(error, stackTrace){
      Log.d("$error, $stackTrace");
    }
    return UserPublicProfile.empty();
  }
}