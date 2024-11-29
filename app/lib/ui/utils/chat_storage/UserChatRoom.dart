import 'package:app/ui/utils/chat_storage/ChatMessage.dart';
import 'package:hive/hive.dart';



@HiveType(typeId: 10) // Assign a unique type ID
class UserChatRoom{
  
  @HiveField(0) // Field ID
  List<ChatMessage> messages; 

  UserChatRoom(this.messages);
}