class HostLoginResponse {
  String userId = "";
  String name = "";
  String mail = "";
  String phone = ""; 
  String token ="";
  String resfreshToken =""; 

  HostLoginResponse(this.userId, this.name, this.phone, this.mail, this.token, this.resfreshToken);
  HostLoginResponse.empty();

  factory HostLoginResponse.fromJson(Map<String, dynamic> json) {
    var userId = json['user_id'];
    var name = json['name'];
    // var phone = json['phone'];
    var mail = json['email'];
    var token = json['token'];
    var refreshToken = json['refresh_token'];
    return HostLoginResponse(userId, name, "9393", mail, token, refreshToken);
  }
}
