class HostAllQrResponse {
  String userId = "";
  String qrId = "";
  String qrContent = "";
  int createdAt = -1;

  HostAllQrResponse(this.userId, this.qrId, this.qrContent, this.createdAt);
  HostAllQrResponse.empty();

  factory HostAllQrResponse.fromJson(Map<String, dynamic> json) {
    return HostAllQrResponse(json["user_id"], json["qr_id"], json["qr_content"],
        json["qr_created_at"]);
  }
}
