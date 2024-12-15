import 'dart:convert';
import 'package:app/comms/model/request/points/HostDeletePointByPointId.dart';
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
  bool? audioAccess; 
  bool? picturesAccess;

  SmartPoint(this.id, this.userId, this.status, this.name, this.phone,
      this.networks, this.nUsed, this.audioAccess, this.picturesAccess);
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
      bool audioAcess = map["audios"];
      bool pictureAccess = map["pictures"];

      var networks =
          (map["networks"] as List).map((e) => SocialNetwork.load(e)).toList();

      return SmartPoint(id, userId, status, name, phone, networks, nUsed, audioAcess, pictureAccess);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return SmartPoint.empty();
  }

  Future<HostGetAllPointsByUserIdResponse> getSmartPointByUserId(
      String userId) async {
    Log.d("Starts getSmartPointByUserId $userId");
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
    Log.d("Starts getSmartPointByPointId $pointId");
    try {
      HostGetPointByPointIdResponse response =
          await HostGetPointsRequest().runByPointId(pointId);
      return response;
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostGetPointByPointIdResponse.empty();
  }

  Future<HostUpdatePointResponse> updatePointStatusByPointId(int status) async {
    Log.d("Starts updatePointStatusByPointId");
    try {
      HostUpdatePointResponse response =
          await HostUpdatePointRequest().runByPointId(id!, status);
      return response;
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostUpdatePointResponse.empty();
  }

  Future<HostPutPointByUserIdResponse> putSmartPointByByUserId(String userId,
      String userName, String phone, List<SocialNetwork> networks, bool pictures, bool audios) async {
    Log.d("Starts putSmartPointByByUserId");
    try {
      HostPutPointByUserIdResponse response =
          await HostPutPointByUserIdRequest()
              .run(userId, userName, phone, networks, pictures, audios);
      return response;
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostPutPointByUserIdResponse.empty();
  }

  Future<bool> deleteSmartPointByPointId() async {
    Log.d("Starts deleteSmartPointByPointId: $id");
    try {
      bool result = await HostDeletePointByPointId().run(id);
      return result; 
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return false;
  }


}
