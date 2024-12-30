import 'dart:ui';

import 'package:app/ui/utils/CommonUtils.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';

class Subscription {
  String? id;
  int? ads;
  int? radioVisibility;
  int? smartPoints;
  Color? color;
  int? validUntil;
  String? transactionDate;

  Subscription(this.id, this.ads, this.radioVisibility, this.smartPoints,
      this.color, this.validUntil, this.transactionDate);
  Subscription.empty();

  factory Subscription.fromJson(Map<String, dynamic> map) {
    Log.d("Starts Subscription.fromJson");
    try {
      int ads = 0;
      int radioVisibility = 0;
      int smartPoints = 0;
      int validUntil = 0;
      Color color = Colors.white;
      String transactionDate = "";

      if (map.isNotEmpty) {
        String id = map["type"];

        if (map.containsKey("ads")) {
          ads = map["ads"];
        }
        if (map.containsKey("radio_visibility")) {
          radioVisibility = map["radio_visibility"];
        }
        if (map.containsKey("smart_points")) {
          smartPoints = map["smart_points"];
        }
        if (map.containsKey("valid_until")) {
          validUntil = map["valid_until"];
        }
        if (map.containsKey("background")) {
          color = Color(CommonUtils.colorToInt(map["background"]));
        }
        if (map.containsKey("transaction_date")) {
          transactionDate =map["transaction_date"];
        }

        return Subscription(
            id, ads, radioVisibility, smartPoints, color, validUntil,transactionDate);
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return Subscription.empty();
  }
}
