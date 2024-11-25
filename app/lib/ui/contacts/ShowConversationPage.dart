import 'dart:convert';

import 'package:app/comms/model/request/HostSendMessageToUserRequest.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserMatch.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    Session.socketSubscription?.onNewChatMessage = _onReceivedMessage;
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

  void _onReceivedMessage(String user, String data) {
    Log.d("Starts _onReceivedMessage");
    Map<String, dynamic> map = jsonDecode(data);
    setState(() {
      _messages.add({"text": map["message"], "sender": "bot"});
    });
  }
}
