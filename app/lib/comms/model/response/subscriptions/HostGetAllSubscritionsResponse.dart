import 'package:app/comms/model/response/BaseCustomResponse.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/Subscription.dart';
import 'package:app/ui/utils/Log.dart';

class HostGetAllSubscritionsResponse extends BaseCustomResponse {
  List<Subscription>? subscriptions;

  HostGetAllSubscritionsResponse(this.subscriptions, super.hostErrorCode);
  HostGetAllSubscritionsResponse.empty() : super(null);

  factory HostGetAllSubscritionsResponse.fromJson(Map<String, dynamic> json) {
    try {
      HostErrorCode hostErrorCode = HostErrorCode.fromJson(json);
      var values = json["subscriptions"] as List;
      var subscriptions = values.map((e) => Subscription.fromJson(e)).toList();
      return HostGetAllSubscritionsResponse(subscriptions, hostErrorCode);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostGetAllSubscritionsResponse.empty();
  }
}
