import 'dart:convert';
import 'package:app/ui/utils/Log.dart';


class NewMessageServie{

    void handleNewContactRequest(String data, Function(String, String) onMessage) {
    Log.d("data received: $data");
    try {
      var map = jsonDecode(data);
      Map<String, dynamic> message = map["message"]["requested_user"];
      String name = message["name"] ?? "Desconocid@";
      String urlImage = message["profile_image"] is Map
          ? message["profile_image"]["url"]
          : "";
      onMessage(name, urlImage);

      
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}