import 'dart:convert';

import 'package:app/model/Session.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/chat_storage/HiveStorageHandler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:app/comms/model/HostContants.dart';

class SocketSubscriptionController {
  late IO.Socket socket;
  String serverMessage = "Waiting for updates...";

  late Function(String) onNewContactRequested;
  // late Function(String, String ) onNewChatMessage;
  HiveStorageHandler chatStorage = HiveStorageHandler(); 

  SocketSubscriptionController initializeSocketConnection() {
    // Connect to the Node.js server
    socket = IO.io(HostActions.SOCKET_LISTEN.url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'query': {'user_id': Session.user.userId},
    });
    chatStorage.init().then((value) => chatStorage.get("92b4deca-5df3-4c0a-b3de-40d38652d8f5")); 

    // Listen for updates from the server
    socket.on('new_contact_request', (data) {
      onNewContactRequested(data);
    });


    socket.on('chat_message', (input) async {
      Log.d ("chat message $input");
      Map<String, dynamic>  data = jsonDecode(input);
      String senderId = data["sender_id"];
      String message = data["message"];
      int time = data["send_at"];
      await chatStorage.put(senderId, message, time, 0);
      // onNewChatMessage(data, data);

    });
    return this;
  }
}
