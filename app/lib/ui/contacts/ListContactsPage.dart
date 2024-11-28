import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserMatch.dart';
import 'package:app/ui/NavigatorApp.dart';

import 'package:app/ui/contacts/ContactDetailsPage.dart';
import 'package:app/ui/contacts/ShowContactDetailsPage.dart';
import 'package:app/ui/contacts/ShowConversationPage.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    Session.socketSubscription?.onMatchLost = _onNewBrokenMatchCallback;

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

  Widget _loadProfileImage(int index) {
    if (_matchs[index].profileImage == null) {
      return const CircleAvatar(
          radius: 80, // Size of the circle
          backgroundColor: Colors.red);
    }
    var url = "${_matchs[index].profileImage!}&quality=50&width=80&heigth=80";
    return SizedBox(
      height: 200,
      width: 80,
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: CircleAvatar(
            radius: 80, // Size of the circle
            backgroundImage: NetworkImage(url)),
      ),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
        itemCount: _matchs.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: _loadProfileImage(index),
                title: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: SizedBox(
                      width: 100,
                      child: Text(
                        _matchs[index].contactInfo!.name!,
                        style: TextStyle(fontSize: 20),
                      )),
                ),
                trailing: _buildNewMessages(index),
                onTap: () async {
                  Session.socketSubscription?.onMatchLost = null;
                  var values = await NavigatorApp.pushAndWait(
                      // ShowContactDetailsPage(_matchs[index]), context);
                      ContactDetailsPage(_matchs[index]), context);

                  var matchId = values["match_id"];
                  if (values["read"]) {
                    setState(() {
                      Session.socketSubscription
                          ?.clearPendingMessages(_matchs[index].matchId!);
                    });
                  }
                  Session.socketSubscription?.onMatchLost =
                      _onNewBrokenMatchCallback;

                  _deleteBrokenMatchs();

                  if (values["broken_match"]) {
                    if (matchId.isNotEmpty) {
                      for (var i = 0; i < _matchs.length; i++) {
                        if (_matchs[i].matchId == matchId) {
                          setState(() {
                            _matchs.removeAt(i);
                          });
                        }
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
    Log.d("n messages $nMessages");
    if (nMessages > 0) {
      return CircleAvatar(
          radius: 15,
          child: Text(nMessages.toString(), style: TextStyle(fontSize: 15)),
          backgroundColor: Colors.green);
    }
    return SizedBox(width: 20, height: 20, child: Container());
  }

  void _deleteBrokenMatchs() {
    try {
      var matchesLost = Session.socketSubscription?.mapMatchLost;
      for (var item in matchesLost!) {
        for (var i = 0; i < _matchs.length; i++) {
          if (_matchs[i].matchId == item) {
            setState(() {
              _matchs.removeAt(i);
            });
          }
        }
      }
    } catch (error) {
      print(error);
    }
  }

  void _onNewBrokenMatchCallback(String matchId) {
    try {
      for (var i = 0; i < _matchs.length; i++) {
        if (_matchs[i].matchId == matchId) {
          setState(() {
            _matchs.removeAt(i);
          });
        }
      }
    } catch (error) {
      print(error);
    }
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

  @override
  void dispose() {
    Session.socketSubscription?.onMatchLost = null;
    super.dispose();
  }
}
