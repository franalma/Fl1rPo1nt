import 'package:app/comms/model/request/matchs/HostDisableUserMatchRequest.dart';
import 'package:app/comms/model/request/matchs/HostUpdateMatchRequest.dart';
import 'package:app/comms/model/request/user/profile/HostGetUserPublicProfile.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserMatch.dart';
import 'package:app/model/UserPublicProfile.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/contacts/ShowContactAudiosPage.dart';
import 'package:app/ui/contacts/ShowContactPictures.dart';
import 'package:app/ui/contacts/ShowConversationPage.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/DefaultModalDialog.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/Gradient1.dart';
import 'package:app/ui/elements/SocialNetworkIcon.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  late bool _accessToPictures; 
  late bool _accessToAudios; 

  @override
  void initState() {
    _fetchFromHost();
    _accessToPictures =  widget._match.sharing!.allwoAccessToPictures!;
    _accessToAudios =  widget._match.sharing!.allwoAccessToPictures!;
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
                  Log.d(
                      "access to audios: ${widget._match.contactInfo!.allwoAccessToAudios}");
                  if (widget._match.contactInfo!.allwoAccessToAudios!) {
                    NavigatorApp.push(
                        ShowContactAudiosPage(
                            widget._match.contactInfo!.userId),
                        context);
                  } else {
                    DefaultModalDialog.showErrorDialog(
                        context,
                        "Este contacto no te ha compartido sus audios",
                        "Cerrar",
                        FontAwesomeIcons.lock);
                  }
                },
                icon: const Icon(Icons.voice_chat),
                iconSize: 30,
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  if (widget._match.contactInfo!.allwoAccessToPictures!) {
                    NavigatorApp.push(
                        ShowContactPictures(widget._match.contactInfo!.userId),
                        context);
                  } else {
                    DefaultModalDialog.showErrorDialog(
                        context,
                        "Este contacto no te ha compartido sus fotos",
                        "Cerrar",
                        FontAwesomeIcons.lock);
                  }
                },
                icon: const Icon(Icons.image),
                iconSize: 30,
                color: Colors.white,
              ),
              IconButton(
                  onPressed: () async {
                    await NavigatorApp.pushAndWait(
                        ShowConversationPage(widget._match), context);
                    _readMessages = true;
                  },
                  icon: const Icon(Icons.message),
                  iconSize: 30,
                  color: Colors.white),
              IconButton(
                  icon: const Icon(Icons.heart_broken,
                      size: 30, color: Colors.white),
                  onPressed: () async {
                    _brokenMatch = true;
                    _breakMatch();
                  }),
            ],
            flexibleSpace: FlexibleAppBar(),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _pop();
                }),
          ),
          body: _isLoading ? AlertDialogs().buildLoading() : _buildBody()),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfile(),
          const SizedBox(height: 5),
          _buildNameTitle(),
          const SizedBox(height: 5),
          _buildPhone(),
          const SizedBox(height: 5),
          _buildAccessControlPanel(),
          const SizedBox(height: 5),
          _buildSexInterest(),
          const SizedBox(height: 5),
          _buildBiography(),
          const SizedBox(height: 5),
          _buildHobbies(),
          const SizedBox(height: 5),
          _buildSocialNetworks(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildAccessControlPanel() {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 5, left: 20.0, right: 4.0, bottom: 10),
        child: Column(
          children: [
            const Text(
              "Cambiar acceso a tus contenidos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
              child: ListTile(
                title: const Text("Acceso a tus fotos"),
                leading: 
                    _accessToPictures? const Icon(FontAwesomeIcons.lockOpen)
                    : const Icon((FontAwesomeIcons.lock)),
                onTap: () {
                  _toggleAccessToPictures();
                },
              ),
            ),
            ListTile(
              title: const Text("Acceso a tus audios"),
              leading: _accessToAudios
                  ? const Icon(FontAwesomeIcons.lockOpen)
                  : const Icon((FontAwesomeIcons.lock)),
              onTap: () {
                _toggleAccessToAudios();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSexInterest() {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 5, left: 20.0, right: 4.0, bottom: 10),
        child: Column(
          children: [
            _buildSectionTitle("Mis preferencias..."),
            SizedBox(
              height: 30,
              child: ListTile(
                leading: Icon(
                  Icons.link,
                  color: Color(CommonUtils.colorToInt(
                      _userPublicProfile!.gender!.color!)),
                ),
                title: Text(
                    "Me identifico como ${_userPublicProfile!.gender!.name?.toLowerCase()}"),
              ),
            ),
            SizedBox(
              height: 30,
              child: ListTile(
                leading: Icon(
                  Icons.link,
                  color: Color(CommonUtils.colorToInt(
                      _userPublicProfile!.sexAlternative!.color)),
                ),
                title: Text(
                    "Soy ${_userPublicProfile!.sexAlternative!.name.toLowerCase()}"),
              ),
            ),
            SizedBox(
              height: 30,
              child: ListTile(
                leading: Icon(
                  Icons.link,
                  color: Color(CommonUtils.colorToInt(
                      _userPublicProfile!.relationShip!.color)),
                ),
                title: Text(
                    "Busco una relación ${_userPublicProfile!.relationShip!.value.toLowerCase()}"),
              ),
            ),
            SizedBox(
              height: 30,
              child: ListTile(
                leading: Icon(
                  Icons.link,
                  color: Color(CommonUtils.colorToInt(
                      _userPublicProfile!.genderInterest!.color!)),
                ),
                title: Text(
                    "El género que busco es ${_userPublicProfile!.genderInterest!.name!.toLowerCase()}"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNameTitle() {
    return Column(
      children: [
        Text(
          widget._match.contactInfo?.name ?? "Desconocid@",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          _userPublicProfile?.age != null
              ? "${_userPublicProfile?.age} años"
              : "",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProfile() {
    return SizedBox(
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
    );
  }

  Widget _buildSocialNetworks() {
    var networks = widget._match.sharing?.networks;
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 5, left: 20.0, right: 20.0, bottom: 10),
        child: Column(
          children: [
            _buildSectionTitle("Redes Sociales"),
            if (networks != null && networks.isNotEmpty)
              Column(
                children: List<Widget>.from(networks.map(
                  (entry) {
                    return ListTile(
                      leading: SocialNetworkIcon()
                          .resolveIconForNetWorkId(entry.networkId),
                      title: Text(entry.name),
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
    );
  }

  Widget _buildHobbies() {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 5, left: 20.0, right: 20.0, bottom: 10),
        child: Column(
          children: [
            _buildSectionTitle("Me interesa..."),
            if (_userPublicProfile?.hobbies != null &&
                _userPublicProfile!.hobbies!.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    List<Widget>.from(_userPublicProfile!.hobbies!.map((hobby) {
                  return Chip(
                    label: Text(hobby.name),
                    backgroundColor: Colors.teal.withOpacity(0.2),
                  );
                })),
              )
            else
              const Text("De momento no lo tengo claro"),
          ],
        ),
      ),
    );
  }

  Widget _buildBiography() {
    String biography = "No sabemos mucho";

    if (_userPublicProfile?.biography != null &&
        _userPublicProfile!.biography!.isNotEmpty) {
      biography = _userPublicProfile!.biography!;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 5, left: 20.0, right: 20.0, bottom: 10),
        child: Column(
          children: [
            _buildSectionTitle("Sobre mí..."),
            Text(
              biography,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPhone() {
    String text = "No tienes su teléfono";

    if (widget._match.contactInfo?.phone != null &&
        widget._match.contactInfo!.phone!.isNotEmpty) {
      text = widget._match.contactInfo!.phone!;
    }

    return Text(
      text,
      style: const TextStyle(fontSize: 16, color: Colors.teal),
    );
  }

  Future<void> _breakMatch() async {
    Log.d("Starts _breakMatch");
    await HostDisableUserMatchRequest()
        .run(widget._match.matchId!, _user.userId);
    _pop();
  }

  void _pop() {
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
      HostGetUserPublicProfile()
          .run(widget._match.contactInfo!.userId)
          .then((response) {
        if (response.profile != null) {
          setState(() {
            _userPublicProfile = response.profile;
            _isLoading = false;
          });
        } else {
          NavigatorApp.pop(context);
        }
      });
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }

  Future<void> _toggleAccessToAudios() async {
    Log.d("Starts _toggleAccessToAudios");
    try {
      AlertDialogs().buildLoadingModal(context);
      var audioAccess = !_accessToAudios; 
      HostUpdateMatchRequest()
          .updateAudioAccess(widget._match.matchId!, _user.userId, audioAccess)
          .then((_) {
        NavigatorApp.pop(context);
        setState(() {
          _accessToAudios = audioAccess; 
        });
      });
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }

  Future<void> _toggleAccessToPictures() async {
    Log.d("Starts _toggleAccessToPictures");
    try {
      AlertDialogs().buildLoadingModal(context);
      var picturesAccess = !_accessToPictures; 
      HostUpdateMatchRequest()
          .updatePictureAccess(widget._match.matchId!, _user.userId, picturesAccess)
          .then((_) {
        NavigatorApp.pop(context);
        setState(() {
          _accessToPictures = picturesAccess; 
        });
      });



    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}
