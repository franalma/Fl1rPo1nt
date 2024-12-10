class ChatMessageItem {
  int? time;
  String? message;
  String? senderId;
  String? receiverId;

  ChatMessageItem(this.time, this.message, this.senderId, this.receiverId);
  ChatMessageItem.empty();

  factory ChatMessageItem.fromHost(Map<String, dynamic> json) {
    return ChatMessageItem(
        json["time"], json["message"], json["sender_id"], json["receiver_id"]);
  }
}
