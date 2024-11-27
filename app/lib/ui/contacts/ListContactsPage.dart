import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserMatch.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/contacts/ShowContactDetailsPage.dart';
import 'package:app/ui/contacts/ShowConversationPage.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../comms/model/request/matchs/HostGetUserMacthsRequest.dart';

class ListContactsPage extends StatefulWidget {
  @override
  State<ListContactsPage> createState() {
    return _ListContactsPage();
  }
}

class _ListContactsPage extends State<ListContactsPage> {
  List<UserMatch> _matchs = [];
  bool _isLoading = true;
  final User _user = Session.user;

  @override
  void initState() {
    Session.socketSubscription?.onReload = _onNewMessageReload;

    super.initState();
    _fetchFromHost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleAppBar(),
        ),
        body: _isLoading ? AlertDialogs().buildLoading() : _buildBody());
  }

  Widget _buildBody() {
    return ListView.builder(
        itemCount: _matchs.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: GestureDetector(
                    child: const CircleAvatar(backgroundColor: Colors.amber),
                    onTap: () {
                      NavigatorApp.push(ShowContactDetailsPage(_matchs[index]), context);
                    }),
                title: Text(_matchs[index].contactInfo!.name!),
                trailing: _buildNewMessages(index),
                onTap: () async {
                  setState(() {
                    Session.socketSubscription
                        ?.clearPendingMessages(_matchs[index].matchId!);
                  });
                  var matchId = await NavigatorApp.pushAndWait(
                      ShowConversationPage(_matchs[index]), context);
                  if (matchId.isNotEmpty) {
                    for (var i = 0; i < _matchs.length; i++) {
                      if (_matchs[i].matchId == matchId) {
                        setState(() {
                          _matchs.removeAt(i);
                        });
                      }
                    }
                  }
                },
              ),
              const Divider()
            ],
          );
        });
  }

  Widget _buildNewMessages(int index) {
    Log.d("Starts _buildNewMessages");
    var match = _matchs[index];
    int nMessages =
        Session.socketSubscription!.getPendingMessagesForMap(match.matchId!);
    print("--nMessages: " + nMessages.toString());
    if (nMessages > 0) {
      return Text(nMessages.toString());
    }
    return SizedBox(width: 20, height: 20, child: Container());
  }

  Future<void> _fetchFromHost() async {
    HostGetUserMacthsRequest().run(_user.userId).then((matches) {
      if (matches.matchs != null) {
        _matchs = matches.matchs!;
      }

      setState(() {
        _isLoading = false;
      });
    });
  }

  void _onNewMessageReload() {
    setState(() {});
  }
}
