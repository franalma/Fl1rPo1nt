class HostPutUserQrResponse {
  String id = "";

  HostPutUserQrResponse(this.id);
  HostPutUserQrResponse.empty();
  

  factory HostPutUserQrResponse.fromJson(Map<String, dynamic> json) {
    return HostPutUserQrResponse(json['id']);
  }
}
