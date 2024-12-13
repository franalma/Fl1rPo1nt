import 'package:app/comms/model/request/matchs/HostPutUserContactRequest.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserPublicProfile.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/contacts/ShowContactAudiosPage.dart';
import 'package:app/ui/contacts/ShowContactPictures.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/DefaultModalDialog.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/Gradient1.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactDetailsPageFromMap extends StatefulWidget {
  UserPublicProfile _profile;

  ContactDetailsPageFromMap(this._profile);

  @override
  State<ContactDetailsPageFromMap> createState() {
    return _ContactDetailsPageForMap();
  }
}

class _ContactDetailsPageForMap extends State<ContactDetailsPageFromMap> {
  @override
  void initState() {
    Log.d("Starts _ContactDetailsPageForMap::initState");
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
                  NavigatorApp.push(
                      ShowContactAudiosPage(widget._profile.id!), context);
                },
                icon: const Icon(Icons.voice_chat),
                iconSize: 30,
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  NavigatorApp.push(
                      ShowContactPictures(widget._profile.id!), context);
                },
                icon: const Icon(Icons.image),
                iconSize: 30,
                color: Colors.white,
              ),
              IconButton(
                  icon: const Icon(FontAwesomeIcons.add,
                      size: 30, color: Colors.white),
                  onPressed: () {
                    _addContact();
                  }),
            ],
            flexibleSpace: FlexibleAppBar(),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _pop();
                }),
          ),
          body: _buildBody()),
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
          _buildSexInterest(),
          const SizedBox(height: 5),
          _buildBiography(),
          const SizedBox(height: 5),
          _buildHobbies(),
          const SizedBox(height: 5),
        ],
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
                  color: Color(
                      CommonUtils.colorToInt(widget._profile.gender!.color!)),
                ),
                title: Text(
                    "Me identifico como ${widget._profile.gender!.name?.toLowerCase()}"),
              ),
            ),
            SizedBox(
              height: 30,
              child: ListTile(
                leading: Icon(
                  Icons.link,
                  color: Color(CommonUtils.colorToInt(
                      widget._profile.sexAlternative!.color)),
                ),
                title: Text(
                    "Soy ${widget._profile.sexAlternative!.name.toLowerCase()}"),
              ),
            ),
            SizedBox(
              height: 30,
              child: ListTile(
                leading: Icon(
                  Icons.link,
                  color: Color(CommonUtils.colorToInt(
                      widget._profile.relationShip!.color)),
                ),
                title: Text(
                    "Busco una relación ${widget._profile.relationShip!.value.toLowerCase()}"),
              ),
            ),
            SizedBox(
              height: 30,
              child: ListTile(
                leading: Icon(
                  Icons.link,
                  color: Color(CommonUtils.colorToInt(
                      widget._profile.genderInterest!.color!)),
                ),
                title: Text(
                    "El género que busco es ${widget._profile.genderInterest!.name!.toLowerCase()}"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNameTitle() {
    return Text(
      widget._profile.name ?? "Desconocid@",
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
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
                    "${widget._profile.profileImage!}&width=100&height=100&quality=60"),
                fit: BoxFit.fill, // Customize fit here
              ),
            ),
          ),
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
            if (widget._profile.hobbies != null &&
                widget._profile.hobbies!.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    List<Widget>.from(widget._profile.hobbies!.map((hobby) {
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

    if (widget._profile.biography != null &&
        widget._profile.biography!.isNotEmpty) {
      biography = widget._profile.biography!;
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

  Future<void> _addContact() async {
    Log.d("Starts _addContact");
    User user = Session.user;
    try {
      AlertDialogs().buildLoadingModal(context);
      HostPutUserContactRequest()
          .run(
              user.userId,
              user.qrDefaultId,
              widget._profile.id!,
              widget._profile.defaultQrId!,
              Session.currentFlirt!.id,
              Session.location!,
              ContactUser.map)
          .then((response) {
        if (response.code == HostErrorCodesValue.NoError.code) {
          NavigatorApp.pop(context);
          DefaultModalDialog.showErrorDialog(context, "Nuevo contacto añadido",
              "Cerrar", FontAwesomeIcons.user,
              iconColor: Colors.green);
        } else {
          NavigatorApp.pop(context);
          DefaultModalDialog.showErrorDialog(
              context,
              "No se ha podido añadir el contacto",
              "Cerrar",
              FontAwesomeIcons.exclamation);
        }
      });
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }

  void _pop() {
    NavigatorApp.pop(context);
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
}
