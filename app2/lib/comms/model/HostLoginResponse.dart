class HostLoginResponse {
  String id = "";
  String name = "";
  String mail = "";
  String phone = ""; 
  String token ="";
  String resfreshToken =""; 

  HostLoginResponse(this.id, this.name, this.phone, this.mail, this.token, this.resfreshToken);
  HostLoginResponse.empty();

  factory HostLoginResponse.fromJson(Map<String, dynamic> json) {
    var id = json['user_id'];
    var name = json['name'];
    // var phone = json['phone'];
    var mail = json['email'];
    var token = json['token'];
    var refreshToken = json['refresh_token'];
    return HostLoginResponse(id, name, "9393", mail, token, refreshToken);
  }
}
