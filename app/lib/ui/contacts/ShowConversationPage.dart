import 'package:app/comms/model/request/HostSendMessageToUserRequest.dart';
import 'package:app/comms/model/request/chat/HostClearChatByUserId.dart';
import 'package:app/comms/model/request/chat/HostGetChatroomMessagesRequest.dart';
import 'package:app/comms/model/request/matchs/HostDisableUserMatchRequest.dart';
import 'package:app/model/ChatMessage.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserMatch.dart';
import 'package:app/ui/NavigatorApp.dart';
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
    _loadMessages();
    Session.socketSubscription!
        .setSocketCallback(_onNewChatMessage, widget._userMatch.matchId!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleAppBar(),
        leading: IconButton(icon:const Icon(Icons.arrow_back), onPressed: (){NavigatorApp.popWith(context, "");}),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.heart_broken,
                size: 30,
              ),
              onPressed: () async {
                _breakMatch();
              }),
          IconButton(
              icon: const Icon(
                Icons.delete_forever,
                size: 30,
              ),
              onPressed: () async {
                await _clearChat();
              })
        ],
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

  Future<void> _loadMessages() async {
    Log.d("Starts _loadMessages");
    HostGetChatroomMessagesRequest()
        .run(widget._userMatch.matchId!, _user.userId)
        .then((response) {
      var messages = response.chatMessages!;
      for (var item in messages) {
        _messages.add({
          "text": item.message!,
          "sender": item.senderId == _user.userId ? "user" : "bot"
        });
      }
      setState(() {});
    });
  }

  void _onNewChatMessage(ChatMessageItem item) {
    setState(() {
      _messages.add({
        "text": item.message!,
        "sender": item.senderId == _user.userId ? "user" : "bot"
      });
    });
  }

  @override
  void dispose() {
    Session.socketSubscription
        ?.removeSocketCallback(widget._userMatch.matchId!);
    super.dispose();
  }

  Future<void> _clearChat() async {
    Log.d("Starts _clearChat");
    await HostClearChatByUserId().run(widget._userMatch.matchId!, _user.userId);
    setState(() {
      _messages.clear();
    });
  }

  Future<void> _breakMatch() async {
    Log.d("Starts _breakMatch");
    await HostDisableUserMatchRequest().run(widget._userMatch.matchId!, _user.userId);
    NavigatorApp.popWith(context, widget._userMatch.matchId);
  }
}
