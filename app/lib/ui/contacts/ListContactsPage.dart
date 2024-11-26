import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserMatch.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/contacts/ShowConversationPage.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
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

  // Box <List<Map<String, dynamic>>> _box = Session.socketSubscription!.chatStorage.database;

  @override
  void initState() {
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
                    onTap: () {}),
                title: Text(_matchs[index].contactInfo!.name!),
                onTap: () {
                  NavigatorApp.push(
                      ShowConversationPage(_matchs[index]), context);
                },
              ),
              const Divider()
            ],
          );
        });
  }

  // Widget _buildBody() {
  //   return ValueListenableBuilder(
  //       valueListenable: _box.listenable(),
  //       builder: (context, box, _) {
  //         return ListView.builder(
  //           itemCount: box.length,
  //           itemBuilder: (context, index) {
  //             var message = box.getAt(index);
  //             return ListTile(
  //               title: Text(message.toString())
  //             );
            
  //         });
  //       });
  // }




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
}
