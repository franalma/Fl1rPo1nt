import 'package:app/ui/utils/Log.dart';

class QrValue {
  String userId = "";
  String qrId = "";
  String name = "";
  String content = "";

  QrValue(this.userId, this.qrId, this.name, this.content);
  QrValue.empty();

  factory QrValue.load(Map<String, dynamic> map) {
    try {
      Log.d("Starts QrValue.load");
      if (map.isNotEmpty) {
        var item =
            QrValue(map["user_id"], map["qr_id"], map["name"], map["content"]);
        return item;
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return QrValue.empty();
  }

  Map<String, dynamic> toHost() {
    return {"name": name, "content": content, "user_id": userId};
  }
}
