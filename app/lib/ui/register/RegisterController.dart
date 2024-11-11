import 'package:app/comms/HostController.dart';
import 'package:app/comms/model/HostRegisterResponse.dart';


class RegisterCongroller {
  final HostController _hostController = HostController();

  Future<HostRegisterResponse> doRegister(String name, String phone,
      String email, String pass, String country, String city) async {
    return await _hostController.doRegister(
        name, "", phone, email, pass, country, city);
  }
}
