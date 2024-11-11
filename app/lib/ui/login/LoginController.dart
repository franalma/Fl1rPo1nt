import 'package:app/comms/HostController.dart';
import 'package:app/comms/model/HostLoginResponse.dart';


class LoginController {
  final HostController _hostController = HostController();

  Future<HostLoginResponse> doLogin(String user, String pass) async {
    return await _hostController.doLogin(user, pass);
  }
}
