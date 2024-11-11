class HostRegisterResponse {
  String id = "";

  HostRegisterResponse(this.id);
  HostRegisterResponse.empty();
  

  factory HostRegisterResponse.fromJson(Map<String, dynamic> json) {
    return HostRegisterResponse(json['id']);
  }
}
