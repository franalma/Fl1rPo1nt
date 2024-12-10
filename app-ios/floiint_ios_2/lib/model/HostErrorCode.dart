import 'package:app/ui/utils/Log.dart';

class HostErrorCode {
  int status;
  int code;
  String description;

  HostErrorCode(this.status, this.code, this.description);
  factory HostErrorCode.undefined() => HostErrorCode(0, 9999999, "Unknown");
  factory HostErrorCode.fromJson(Map<String, dynamic> map) {
    try {
      Log.d("Starts HostErrorCode.fromJson");
      return HostErrorCode(
          map["status"], map["error_code"], map["description"]);
    } catch (error) {
      Log.d("$error");
    }
    return HostErrorCode.undefined();
  }
}

enum HostErrorCodesValue {
  NoError(0, "0"),
  UserNotActivated(-100, "Account not activated"),
  UserExist(-101, "User exists"),
  NotPossibleToRegiserUser(-102, "Not possible to register user"),
  WrongUserPass(-103, "Wrong user/pass"),
  UserNotExist(-104, "User not exists"),
  UserBlocked(-105, "User blocked"),
  NoFlirtsFound(-106, "No flirts found"),

  UserInYourContacts(-401, "User in your contacts"),

  InternalServerError(-500, "Server error"),

  Unknown(999999, "");

  final int code;
  final String description;

  const HostErrorCodesValue(this.code, this.description);

  static HostErrorCodesValue parse(int code) {
    for (var item in HostErrorCodesValue.values) {
      if (item.code == code) {
        return item;
      }
    }
    return HostErrorCodesValue.Unknown;
  }
}
