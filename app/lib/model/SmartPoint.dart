import 'dart:convert';
import 'dart:typed_data';

import 'package:app/comms/model/request/points/HostGetPointsRequest.dart';
import 'package:app/comms/model/request/points/HostPutPointByUserIdRequest.dart';
import 'package:app/comms/model/request/points/HostUpdatePointRequest.dart';
import 'package:app/comms/model/response/smart_points/HostGetAllPointsByUserIdResponse.dart';
import 'package:app/comms/model/response/smart_points/HostGetPointByPointIdResponse.dart';
import 'package:app/comms/model/response/smart_points/HostPutPointByUserIdResponse.dart';
import 'package:app/comms/model/response/smart_points/HostUpdatePointResponse.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/ui/utils/Log.dart';

class SmartPoint {
  String? id;
  String? userId;
  int? status;
  String? name;
  String? phone;
  List<SocialNetwork>? networks;
  int? nUsed;

  SmartPoint(this.id, this.userId, this.status, this.name, this.phone,
      this.networks, this.nUsed);
  SmartPoint.empty();

  factory SmartPoint.fromJson(Map<String, dynamic> map) {
    try {
      Log.d("Starts  SmartPoint.fromJson ${jsonEncode(map)}");
      String id = map["point_id"];
      String userId = map["user_id"];
      int status = map["status"];
      int nUsed = map["times_used"];
      String name = map["user_name"];
      String phone = map["user_phone"];

      var networks =
          (map["networks"] as List).map((e) => SocialNetwork.load(e)).toList();

      return SmartPoint(id, userId, status, name, phone, networks, nUsed);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return SmartPoint.empty();
  }

  Future<HostGetAllPointsByUserIdResponse> getSmartPointByUserId(
      String userId) async {
    try {
      HostGetAllPointsByUserIdResponse response =
          await HostGetPointsRequest().runByUserID(userId);
      return response;
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostGetAllPointsByUserIdResponse.empty();
  }

  Future<HostGetPointByPointIdResponse> getSmartPointByPointId(
      String pointId) async {
    try {
      HostGetPointByPointIdResponse response =
          await HostGetPointsRequest().runByPointId(pointId);
      return response;
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostGetPointByPointIdResponse.empty();
  }

  Future<HostUpdatePointResponse> updatePointStatusByPointId(
      String pointId, int status) async {
    try {
      HostUpdatePointResponse response =
          await HostUpdatePointRequest().runByPointId(pointId, status);
      return response;
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostUpdatePointResponse.empty();
  }

  Future<HostPutPointByUserIdResponse> putSmartPointByByUserId(String userId,
      String userName, String phone, List<SocialNetwork> networks) async {
    try {
      HostPutPointByUserIdResponse response =
          await HostPutPointByUserIdRequest()
              .run(userId, userName, phone, networks);
      return response;
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostPutPointByUserIdResponse.empty();
  }
}
