import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/chat_storage/ChatMessage.dart';
import 'package:app/ui/utils/chat_storage/UserChatRoom.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorageHandler {
  late Box<UserChatRoom> database;

  Future<void> init() async {
    Log.d("Starts init");
    await Hive.initFlutter();
    Hive.registerAdapter(UserChatRoomAdapter());
    Hive.registerAdapter(ChatMessageAdapter());
    database = await Hive.openBox<UserChatRoom>('myBox');
  }

  Future<void> put(String sender, String message, int time, int source) async {
    Log.d("Starts put");
    ChatMessage newMessage = ChatMessage(
        time: time, message: message, senderId: sender, source: source);
    if (database.containsKey(sender)) {
      var room = database.get(sender)!;
      room.messages.add(newMessage);
      await database.put(sender, room);
    } else {
      List<ChatMessage> messages = List.of([newMessage]);
      await database.put(sender, UserChatRoom(messages));
    }
  }

  UserChatRoom? get(String sender) {
    Log.d("Starts get");
    if (database.containsKey(sender)) {
      UserChatRoom data = database.get(sender)!;
      return data;
    }
    return UserChatRoom([]);
  }

  // Future<void> remove(String sender) async {
  //   Log.d("Starts remove");
  // }
  // int length(){
  //   return database.length;
  // }
}
