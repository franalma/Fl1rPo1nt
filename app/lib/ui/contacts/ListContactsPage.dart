import 'package:app/comms/model/request/HostGetUserMacthsRequest.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserMatch.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/contacts/ShowConversationPage.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:flutter/material.dart';

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
