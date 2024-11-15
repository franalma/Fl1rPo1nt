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
  List<dynamic>qrValues = [];

  HostLoginResponse(this.userId, this.name, this.phone, this.mail, this.token,
      this.resfreshToken, this.networks, this.relationShip, this.sexAlternatives, this.qrValues);
  HostLoginResponse.empty();

  factory HostLoginResponse.fromJson(Map<String, dynamic> json) {
    try {
      var userId = json['user_id'];
      var name = json['name'];
      var phone = "";
      var mail = json['email'];
      var token = json['token'];
      var refreshToken = json['refresh_token'];
      var networks = json["networks"];
      var relationShip = json["user_interests"]["relationship"];
      var sexAlternatives = json["user_interests"]["sex_alternative"];
      var qrValues = json["qr_values"];

      if (json.containsKey("phone")) {
        phone = json['phone'].toString();
      }

      HostLoginResponse response = HostLoginResponse(userId, name, phone, mail,
          token, refreshToken, networks,relationShip, sexAlternatives,qrValues);
      return response;
    } catch (error, stackTrace) {
      Log.d("$stackTrace error $error");
    }
    return HostLoginResponse.empty();
  }
}
