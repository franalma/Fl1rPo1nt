import 'package:app/comms/model/request/matchs/HostDisableUserMatchRequest.dart';
import 'package:app/comms/model/request/user/profile/HostGetUserPublicProfile.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserMatch.dart';
import 'package:app/model/UserPublicProfile.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/contacts/ShowConversationPage.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/Gradient1.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';

class ShowContactDetailsPage extends StatefulWidget {
  UserMatch _match;

  ShowContactDetailsPage(this._match);

  @override
  State<ShowContactDetailsPage> createState() {
    return _ShowContactDetailsPage();
  }
}

class _ShowContactDetailsPage extends State<ShowContactDetailsPage> {
  final User _user = Session.user;
  UserPublicProfile? _userPublicProfile;
  bool _readMessages = false;
  bool _brokenMatch = false;

  @override
  void initState() {
    _fetchFromHost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _pop();
            }),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.image), iconSize: 30),
          IconButton(
              onPressed: () async {
                await NavigatorApp.pushAndWait(
                    ShowConversationPage(widget._match), context);
                _readMessages = true;
              },
              icon: const Icon(Icons.message),
              iconSize: 30),
          IconButton(
              icon: const Icon(
                Icons.heart_broken,
                size: 30,
              ),
              onPressed: () async {
                _brokenMatch = true;
                _breakMatch();
              }),
        ],
        flexibleSpace: FlexibleAppBar(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildNameBlock() {
    String? name = widget._match.contactInfo!.name;
    if (name != null && name.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 250,
          height: 100,
          child: Card(
              child: Center(
            child: Column(
              children: [
                const Text(
                  "Datos básicos",
                  style: TextStyle(fontSize: 30),
                ),
                Row(
                  children: [const Text("Nombre:"), Text(name)],
                ),
              ],
            ),
          )),
        ),
      );
    }
    return Container();
  }

  Widget _buildHowToContactInfo() {
    var contactInfo = widget._match.contactInfo;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: Column(
        children: [
          const Text(
            "Redes compartidas",
            style: TextStyle(fontSize: 30),
          ),
          Row(
            children: [
              if (contactInfo != null && contactInfo.networks != null)
                for (var item in contactInfo.networks!) Text(item.name)
            ],
          ),
        ],
      )),
    );
  }

  Future<void> _breakMatch() async {
    Log.d("Starts _breakMatch");
    await HostDisableUserMatchRequest()
        .run(widget._match.matchId!, _user.userId);
    _pop();
  }

  Widget _buildBiography() {
    var biography = _userPublicProfile!.biography;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: Column(
        children: [
          Divider(),
          const Text(
            "Sobre tu contacto..",
            style: TextStyle(fontSize: 30),
          ),
          Text(
            biography!,
          ),
          Divider(),
        ],
      )),
    );
  }

  void _pop() {
    NavigatorApp.popWith(context, {
      "broken_match": _brokenMatch,
      "read": _readMessages,
      "match_id": widget._match.matchId
    });
  }

  Widget _buildHobbies() {
    var hobbies = _userPublicProfile!.hobbies;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: Column(
        children: [
          Text("Aficiones..", style: TextStyle(fontSize: 20)),
          for (var item in hobbies!)
            Text(
              item.toString(),
              style: TextStyle(fontSize: 15),
            ),
          Divider(),
        ],
      )),
    );
  }

  Widget _buildLookingFor() {
    return Container();
  }

  Widget _buildSource() {
    return Container();
  }

  Widget _buildHeader() {
    return SizedBox(
      child: Container(
        decoration: Gradient1().getLinearGradient(),
        child: Column(
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _loadImageProfile(),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildHeader(),
        // _buildNameBlock(),
        // _buildHowToContactInfo(),
        // _buildBiography(),
        // _buildHobbies(),
        // _buildLookingFor(),
        // _buildSource()
      ],
    );
  }

  Widget _loadImageProfile() {
    Log.d("Starts _loadImageProfile");
    if (_userPublicProfile != null &&
        _userPublicProfile!.profileImage != null) {
      var image = _userPublicProfile!.profileImage!;

      return CircleAvatar(maxRadius: 80, backgroundImage: image);
    }
    return const CircleAvatar(maxRadius: 80, backgroundColor: Colors.red);
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts _fetchFromHost");
    try {
      HostGetUserPublicProfile().run(_user.userId).then((response) {
        if (response.profile != null) {
          setState(() {
            _userPublicProfile = response.profile;
          });
        }
      });
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}
