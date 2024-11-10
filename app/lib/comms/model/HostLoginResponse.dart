class HostLoginResponse {
  String id = "";
  String name = "";
  String mail = "";
  String token ="";
  String resfreshToken =""; 

  HostLoginResponse(this.id, this.name, this.mail, this.token, this.resfreshToken);
  HostLoginResponse.empty();

  factory HostLoginResponse.fromJson(Map<String, dynamic> json) {
    var id = json['user_id'];
    var name = json['name'];
    var mail = json['email'];
    var token = json['token'];
    var refreshToken = json['refresh_token'];
    print(refreshToken);
    return HostLoginResponse(id, name, mail, token, refreshToken);
  }
}
