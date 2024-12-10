import 'package:app/model/ChatMessage.dart';
import 'package:app/ui/utils/Log.dart';

class HostGetChatroomMessagesResponse {
  List<ChatMessageItem>? chatMessages;

  HostGetChatroomMessagesResponse(this.chatMessages);
  HostGetChatroomMessagesResponse.empty();

  factory HostGetChatroomMessagesResponse.fromJson(List<dynamic> json) {
    Log.d("Starts HostGetChatroomMessagesResponse");
    var values = json.map((e) {
      return ChatMessageItem.fromHost(e);
    }).toList();
    return HostGetChatroomMessagesResponse(values);
  }
}
