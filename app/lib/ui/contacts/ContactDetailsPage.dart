

import 'package:app/comms/model/request/matchs/HostDisableUserMatchRequest.dart';
import 'package:app/comms/model/request/user/profile/HostGetUserPublicProfile.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserMatch.dart';
import 'package:app/model/UserPublicProfile.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/contacts/ShowContactPictures.dart';
import 'package:app/ui/contacts/ShowConversationPage.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/Gradient1.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';

class ContactDetailsPage extends StatefulWidget {
  UserMatch _match;

  ContactDetailsPage(this._match);

  @override
  State<ContactDetailsPage> createState() {
    return _ContactDetailsPage();
  }
}


class _ContactDetailsPage extends State<ContactDetailsPage> {
  bool _readMessages = false;
  bool _brokenMatch = false;
  final User _user = Session.user;
  bool _isLoading = true; 
  UserPublicProfile? _userPublicProfile;

  
  final Map<String, dynamic> contact = {
    "name": "Mi ligue",
    "email": "alice@example.com",
    "phone": "+1234567890",
    "avatar": "https://via.placeholder.com/150",
    "bio":
        "Alice is a software developer with over 5 years of experience in building mobile and web applications. She loves exploring new technologies and mentoring aspiring developers.",
    "hobbies": ["Photography", "Traveling", "Reading", "Perros", "Gatos"],
    "networks": {
      "Twitter": "https://twitter.com/alice",
      "LinkedIn": "https://linkedin.com/in/alice",
      "GitHub": "https://github.com/alice"
    }
  };

  @override
  void initState() {
    _fetchFromHost();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  NavigatorApp.push(ShowContactPictures(widget._match), context);
                },
                icon: const Icon(Icons.image),
                iconSize: 30),
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
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // _pop();
              }),
        ),
        body: _isLoading ? AlertDialogs().buildLoading():_buildBody()
      ),
    );
  }
  Widget _buildBody(){
    return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: Gradient1().getLinearGradient(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              "${widget._match.profileImage!}&width=100&height=100&quality=60"),
                          fit: BoxFit.fill, // Customize fit here
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Name and Title
              Text(
              widget._match.contactInfo?.name?? "Desconocid@",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),

              // Phone and Email
              Text(
                contact['phone'] ?? "No tenemos el teléfono",
                style: const TextStyle(fontSize: 16, color: Colors.teal),
              ),

              const SizedBox(height: 20),

              // Biography Section

              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 20.0, right: 20.0, bottom: 10),
                  child: Column(
                    children: [
                      _buildSectionTitle("Sobre mí..."),
                      Text(
                        _userPublicProfile?.biography??"No sabemos mucho",
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Hobbies Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 20.0, right: 20.0, bottom: 10),
                  child: Column(
                    children: [
                      _buildSectionTitle("Me interesa..."),
                      if (_userPublicProfile?.hobbies != null &&
                          _userPublicProfile?.hobbies is List)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              List<Widget>.from(contact['hobbies'].map((hobby) {
                            return Chip(
                              label: Text(hobby),
                              backgroundColor: Colors.teal.withOpacity(0.2),
                            );
                          })),
                        )
                      else
                        const Text("De momento no lo tengo claro"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Social Networks Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 20.0, right: 20.0, bottom: 10),
                  child: Column(
                    children: [
                      _buildSectionTitle("Redes Sociales"),
                      if (contact['networks'] != null &&
                          contact['networks'] is Map)
                        Column(
                          children:
                              List<Widget>.from(contact['networks'].entries.map(
                            (entry) {
                              return ListTile(
                                leading: const Icon(
                                  Icons.link,
                                  color: Colors.blueAccent,
                                ),
                                title: Text(entry.key),
                                subtitle: Text(entry.value),
                                onTap: () {
                                  // Add your logic to open the URL
                                  print("Open ${entry.value}");
                                },
                              );
                            },
                          )),
                        )
                      else
                        const Text("No te han compatido las redes sociales"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
  }

  Future<void> _breakMatch() async {
    Log.d("Starts _breakMatch");
    await HostDisableUserMatchRequest().run(widget._match.matchId!, _user.userId);
    _pop(context);
  }

  void _pop(BuildContext context) {
    NavigatorApp.popWith(context, {
      "broken_match": _brokenMatch,
      "read": _readMessages,
      "match_id": widget._match.matchId
    });
  }

  // Helper to build section titles
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts _fetchFromHost");
    
    try {
      HostGetUserPublicProfile().run(_user.userId).then((response) {
        if (response.profile != null) {
          setState(() {
            _userPublicProfile = response.profile;
            _isLoading = false; 
          });
        }else{
          NavigatorApp.pop(context);
        }
      });
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}
