import 'dart:convert';

import 'package:app/model/ChatMessage.dart';
import 'package:app/model/Session.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:app/comms/model/HostContants.dart';

class SocketSubscriptionController {
  late IO.Socket socket;
  String serverMessage = "Waiting for updates...";
  Map<String, Function(ChatMessageItem)?> chatroomGlobal = {};
  Map<String, int> newMessages = {};
  late Function(String) onNewContactRequested;
  Function?  onReload; 

  SocketSubscriptionController initializeSocketConnection() {
    socket = IO.io(HostActions.SOCKET_LISTEN.url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'query': {'user_id': Session.user.userId},
    });

    socket.on('new_contact_request', (data) {
      onNewContactRequested(data);
    });

    socket.on('chat_message', (input) async {
      Log.d("chat message $input");
      Map<String, dynamic> data = jsonDecode(input);
      String matchId = data["match_id"];
      String senderId = data["sender_id"];
      String message = data["message"];
      String receiverId = data["receiver_id"];
      int time = data["send_at"];

      var messageItem = ChatMessageItem(time, message, senderId, receiverId);

      if (chatroomGlobal.containsKey(matchId)) {
        var callback = chatroomGlobal[matchId]!;
        print("------>");
        print(callback);
        callback(messageItem);
      } else {
        print("addding");
        int? nMsg = newMessages[matchId] == null ? 0 : newMessages[matchId];
        nMsg = nMsg! + 1;
        newMessages[matchId] = nMsg;
        if (onReload != null ){
          onReload!(); 
        }
      }
    });
    return this;
  }

  void setSocketCallback(Function(ChatMessageItem) callback, String matchId) {
    chatroomGlobal[matchId] = callback;
  }

  void removeSocketCallback(String matchId) {
    chatroomGlobal.remove(matchId);
  }

  int getPendingMessagesForMap(String matchId) {
    if (!newMessages.containsKey(matchId)) {
      return 0;
    }
    return newMessages[matchId]!;
  }
  void clearPendingMessages(String matchId){
    newMessages[matchId] = 0;
  }
}
