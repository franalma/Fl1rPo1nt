import 'package:app/comms/HostController.dart';
import 'package:app/comms/model/HostRegisterResponse.dart';

class RegisterDelegate {
  void onSuccess(bool result) {}
  void onFailure(bool result) {}

}

class LoginController {
  final HostController _hostController = HostController();

  Future<HostRegisterResponse> doRegister(String user, String pass) async {
    return await _hostController.doRegister(user, pass);
  }
}