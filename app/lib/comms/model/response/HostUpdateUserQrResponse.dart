import 'package:app/model/QrValue.dart';

class HostUpdateUserQrResponse {
  QrValue qrValue;

  HostUpdateUserQrResponse(this.qrValue);
  

  factory HostUpdateUserQrResponse.fromJson(Map<String, dynamic> json) {
    return HostUpdateUserQrResponse(QrValue.load(json));
  }
}
