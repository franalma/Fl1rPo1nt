import 'dart:convert';

import 'package:app/comms/model/request/HostSendMessageToUserRequest.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserMatch.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/chat_storage/ChatMessage.dart';
import 'package:app/ui/utils/chat_storage/HiveStorageHandler.dart';
import 'package:app/ui/utils/chat_storage/UserChatRoom.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ShowConversationPage extends StatefulWidget {
  UserMatch _userMatch;
  ShowConversationPage(this._userMatch);

  @override
  State<ShowConversationPage> createState() {
    return _ShowConversationPage();
  }
}

class _ShowConversationPage extends State<ShowConversationPage> {
  final User _user = Session.user;
  final List<Map<String, String>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final Box<UserChatRoom> _box =
      Session.socketSubscription!.chatStorage.database;
  HiveStorageHandler _storageHandler = Session.socketSubscription!.chatStorage;

  @override
  void initState() {
    _loadMessages();
    _listenDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleAppBar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Messages start from the bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - index - 1];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.teal[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(message['text']!),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: '¿Qué quieres decirle?',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  color: Colors.teal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    Log.d("Starts _sendMessge");
    final text = _messageController.text;
    await _storageHandler.put(_user.userId, text, 0, 1);

    if (text.isNotEmpty) {
      HostSendMessageToUserRequest()
          .run(widget._userMatch.matchId!, _user.userId,
              widget._userMatch.contactInfo!.userId, _messageController.text)
          .then((value) {
        setState(() {
          _messages.add({"text": text, "sender": "user"});
        });
      });

      _messageController.clear();
    }
  }

  void _listenDatabase() {
    Log.d("Starts _listenDatabase");
    Stream<BoxEvent> stream = _box.watch();
    stream.listen((event) {
      if (!event.deleted) {
        UserChatRoom room = event.value;

        ChatMessage chatMessage = room.messages.last;
        if (chatMessage.source == 0) {
          _onReceivedMessage(chatMessage.message, chatMessage.time);
        }
      }
    });
  }

  void _onReceivedMessage(String message, int time) {
    Log.d("Starts _onReceivedMessage");

    setState(() {
      _messages.add({"text": message, "sender": "bot"});
    });
  }

  void _loadMessages() {
    Log.d("Starts _loadMessages");
    UserChatRoom? room =
        _storageHandler.get(widget._userMatch.contactInfo!.userId);
    if (room != null) {
      for (var message in room.messages) {
        _messages.add({
          "text": message.message,
          "sender": message.source == 0 ? "bot" : "user"
        });
      }
    }
    setState(() {});
  }
}
