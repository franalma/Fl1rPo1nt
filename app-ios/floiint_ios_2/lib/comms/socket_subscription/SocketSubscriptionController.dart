import 'dart:convert';

import 'package:app/model/ChatMessage.dart';
import 'package:app/model/SecureStorage.dart';
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
  Function(String)? onReload;
  List<String> mapMatchLost = [];
  Function(String)? onMatchLost;
  
  
  SocketSubscriptionController initializeSocketConnection() {
    
    socket = IO.io(HostChatActions.socketListen.build(), <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'query': {'user_id': Session.user.userId},
    });

    socket.on('new_contact_request', (data) {
      onNewContactRequested(data);
    });

    socket.on('match_lost', (input) async {
      Log.d("match lost $input");
      Map<String, dynamic> data = jsonDecode(input);
      String matchId = data["match_id"];

      if (onMatchLost != null) {
        onMatchLost!(matchId);
      } else {
        mapMatchLost.add(matchId);
      }
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
        callback(messageItem);
      } else {
        // int nMsg = newMessages[matchId] ?? 0;
        // nMsg = nMsg + 1;
        // newMessages[matchId] = nMsg;
        await saveNewChatMessages(matchId);

        if (onReload != null) {
          onReload!(matchId);
        }
      }
    });
    return this;
  }

  Future<void> saveNewChatMessages(String matchId) async {
    Log.d("Starts saveNewChatMessages:$matchId");
    
    var storage = SecureStorage();
    String value = await storage.getSecureData(matchId) ?? "0";
    int cont = int.parse(value);
    cont = cont + 1;
    await storage.saveSecureData(matchId, cont.toString());
  }

  Future<int> getPendingMessagesForMatchId(String matchId) async {
    Log.d("Starts saveNewChatMessages:$matchId");
    var storage = SecureStorage();
    String value = await storage.getSecureData(matchId) ?? "0";
    return int.parse(value);
  }

  Future<void> clearPendingMessageForMacthId(String matchId) async {
    Log.d("Starts saveNewChatMessages:$matchId");
    var storage = SecureStorage();
    await storage.deleteSecureData(matchId);
  }

  void setSocketCallback(Function(ChatMessageItem) callback, String matchId) {
    chatroomGlobal[matchId] = callback;
  }

  void removeSocketCallback(String matchId) {
    chatroomGlobal.remove(matchId);
  }

  Future<int> getPendingMessagesForMap(String matchId) async {
    // if (!newMessages.containsKey(matchId)) {
    //   return 0;
    // }
    // return newMessages[matchId]!;
    return await getPendingMessagesForMatchId(matchId);
  }

  Future<void> clearPendingMessages(String matchId) async {
    // newMessages[matchId] = 0;
    await clearPendingMessageForMacthId(matchId);
  }
}
