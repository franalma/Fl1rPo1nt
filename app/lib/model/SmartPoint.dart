import 'dart:convert';

import 'package:app/ui/utils/Log.dart';

class SmartPoint {
  String? id;
  String? qrId;
  String? userId;
  bool? active;

  SmartPoint(this.id, this.qrId, this.userId, this.active);
  SmartPoint.empty();

  factory SmartPoint.fromJson(Map<String, dynamic> map) {
    try {
      Log.d("Starts  SmartPoint.fromJson ${jsonEncode(map)}");
      String id = map["id"];
      String qrId = map["qr_id"];
      String userId = map["qr_id"];
      bool active = map["active"];
      return SmartPoint(id, qrId, userId, active);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return SmartPoint.empty();
  }
}
