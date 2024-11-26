import 'package:hive/hive.dart';

part 'ChatMessage.g.dart'; // Required for code generation
//flutter packages pub run build_runner build

@HiveType(typeId: 0) // Assign a unique type ID

class ChatMessage {
  @HiveField(0) // Field ID
  final int time;
  @HiveField(1) // Field ID
  final String message;
  @HiveField(2) // Field ID
  String senderId;
  @HiveField(3) // Field ID
  int source;

  ChatMessage(
      {required this.time,
      required this.message,
      required this.senderId,
      required this.source});

  // ChatMessage(this.time, this.message, this.senderId, this.source);
  // Map<String, dynamic> toJson() {
  //   return {
  //     "time": time,
  //     "message": message,
  //     "sender_id": senderId,
  //     "source": source
  //   };
  // }
}
