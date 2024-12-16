import 'package:app/model/Gender.dart';
import 'package:app/model/SecureStorage.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/utils/Log.dart';

enum ConfigError {
  genderRequired,
  qrRequired,
  profileImageRequired,
  sexOrientationRequired,
  relationshipRequired,
  lookingForGenderRequired,
  biographyRequired,
  hobbiesRequired,
  firstLogin,

  noError
}

class ConfigService {
  User user;

  ConfigService(this.user);

  bool _checkGender() {
    if (user.gender.color != null) {
      return true;
    }
    return false;
  }

  bool _checkSexOrientation() {
    if (user.sexAlternatives != SexAlternative.empty()) {
      return true;
    }
    return false;
  }

  bool _checkRelationShip() {
    if (user.relationShip != RelationShip.empty()) {
      return true;
    }
    return false;
  }

  bool _checkLookingGender() {
    if (user.gender != Gender.empty()) {
      return true;
    }
    return false;
  }

  bool _checkQr() {
    if (user.qrValues.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool _checkImageProfile() {
    if (user.userProfileImageId.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool _checkBiography() {
    if (user.biography.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool _checkHobbies() {
    if (user.hobbies.isNotEmpty) {
      return true;
    }
    return false;
  }

  ConfigError checkConfiguration() {
    Log.d("Starts checkConfiguration");
    try {} catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
      if (!_checkGender()) return ConfigError.genderRequired;
      if (!_checkQr()) return ConfigError.qrRequired;
      if (!_checkImageProfile()) return ConfigError.profileImageRequired;
      if (!_checkSexOrientation()) return ConfigError.sexOrientationRequired;
      if (!_checkRelationShip()) return ConfigError.relationshipRequired;
      if (!_checkLookingGender()) return ConfigError.lookingForGenderRequired;
      if (!_checkBiography()) return ConfigError.biographyRequired;
      if (!_checkHobbies()) return ConfigError.hobbiesRequired;
    }
    return ConfigError.noError;
  }

  Future<bool> isFirstLogin() async{
    SecureStorage secureStorage = SecureStorage();
    String? value = await secureStorage.getSecureData("first_login");
    return value == null; 
  }
  

}
