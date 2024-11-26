import 'package:app/ui/utils/chat_storage/ChatMessage.dart';
import 'package:hive/hive.dart';

part 'UserChatRoom.g.dart'; // Required for code generation

@HiveType(typeId: 10) // Assign a unique type ID
class UserChatRoom{
  
  @HiveField(0) // Field ID
  List<ChatMessage> messages; 

  UserChatRoom(this.messages);
}