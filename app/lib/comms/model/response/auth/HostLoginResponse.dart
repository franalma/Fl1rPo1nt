import 'package:app/ui/utils/Log.dart';

class HostLoginResponse {
  String userId = "";
  String name = "";
  String mail = "";
  String phone = "";
  String token = "";
  String resfreshToken = "";
  List<dynamic> networks = [];
  Map<String, dynamic> relationShip = {};
  Map<String, dynamic> sexAlternatives = {};
  List<dynamic> qrValues = [];
  String biography = "";
  List<dynamic> hobbies = [];
  String userProfileImageId = "";
  int nScanned = 0;
  int nScansPerformed = 0;

  HostLoginResponse(
      this.userId,
      this.name,
      this.phone,
      this.mail,
      this.token,
      this.resfreshToken,
      this.networks,
      this.relationShip,
      this.sexAlternatives,
      this.qrValues,
      this.biography,
      this.hobbies,
      this.userProfileImageId,
      this.nScanned,
      this.nScansPerformed);
  HostLoginResponse.empty();

  factory HostLoginResponse.fromJson(Map<String, dynamic> json) {
    try {
      var userId = json['user_id'];
      var name = json['name'];
      var phone = "";
      var biography = "";
      var mail = json['email'];
      var token = json['token'];
      var refreshToken = json['refresh_token'];
      var networks = json["networks"];
      var relationShip = json["user_interests"]["relationship"];
      var sexAlternatives = json["user_interests"]["sex_alternative"];
      var qrValues = json["qr_values"];
      List<dynamic> hobbies = [];
      var userProfileImageId = "";
      int nScans = 0;
      int nScansPerformed = 0;

      if (json.containsKey("phone")) {
        phone = json['phone'].toString();
      }
      if (json.containsKey("biography")) {
        biography = json['biography'].toString();
      }

      if (json.containsKey("hobbies")) {
        hobbies = json['hobbies'];
      }

      if (json.containsKey("profile_image_file_id")) {
        userProfileImageId = json['profile_image_file_id'];
      }

      if (json.containsKey("scanned_count")) {
        nScans = json['scanned_count'];
      }

      if (json.containsKey("scans_performed")) {
        nScansPerformed = json['scans_performed'];
      }

      HostLoginResponse response = HostLoginResponse(
          userId,
          name,
          phone,
          mail,
          token,
          refreshToken,
          networks,
          relationShip,
          sexAlternatives,
          qrValues,
          biography,
          hobbies,
          userProfileImageId,
          nScans, 
          nScansPerformed);
      return response;
    } catch (error, stackTrace) {
      Log.d("$stackTrace error $error");
    }
    return HostLoginResponse.empty();
  }
}
