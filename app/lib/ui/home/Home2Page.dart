import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/services/NewMessageService.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/contacts/ListContactsPage.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/DefaultModalDialog.dart';
import 'package:app/ui/elements/FancyButton.dart';
import 'package:app/ui/map_explorer/MapFilterCriterialsPage.dart';
import 'package:app/ui/my_social_networks/MySocialNetworksPage.dart';
import 'package:app/ui/party_mode/PartyModePage.dart';
import 'package:app/ui/qr_manager/ListQrPage.dart';
import 'package:app/ui/smart_points/SmartPointsListPage.dart';
import 'package:app/ui/user_profile/UserProfilePage.dart';
import 'package:app/ui/user_state/UserStatePage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home2Page extends StatefulWidget {
  @override
  State<Home2Page> createState() => _Home2State();
}

class _Home2State extends State<Home2Page> {
  final User _user = Session.user;

  @override
  void initState() {
    super.initState();
    Session.socketSubscription?.onNewContactRequested =
        _handleNewContactRequest;
  }

  void _handleNewContactRequest(String message) {
    NewMessageServie().handleNewContactRequest(message, onNewMessage);
  }

  void onNewMessage(String name, String url) {
    AlertDialogs().showCustomModalDialog(context, name, url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  NavigatorApp.push(UserProfilePage(), context);
                },
                icon: const Icon(Icons.account_circle))
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            _buildBody(),
          ],
        ));
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          shrinkWrap: true, // Allows GridView to take only the needed space
          crossAxisCount: 2, // Two buttons per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            FancyButton(
                text: 'Mi estado',
                icon: FontAwesomeIcons.eye,
                color: const Color.fromARGB(255, 237, 129, 6),
                onTap: () {
                  NavigatorApp.push(UserStatePage(), context);
                }),
            FancyButton(
                text: 'Mis redes',
                icon: FontAwesomeIcons.solidCirclePlay,
                color: Color.fromARGB(255, 85, 22, 244),
                onTap: () {
                  NavigatorApp.push(MySocialNetworksPage(), context);
                }),
            FancyButton(
                text: 'Mis QR',
                icon: Icons.qr_code,
                color: Color.fromARGB(255, 187, 23, 202),
                onTap: () {
                  NavigatorApp.push(ListQrPage(), context);
                }),
            FancyButton(
                text: 'Modo fiesta',
                icon: FontAwesomeIcons.hands,
                color: Colors.blue,
                onTap: () {
                  if (_user.isFlirting) {
                    if (_user.qrValues.isEmpty) {
                      DefaultModalDialog.showErrorDialog(context, "Debes crear al menos un QR para compartir", "Cerrar", FontAwesomeIcons.exclamation);
                    } else {
                      NavigatorApp.push(PartyModePage(), context);
                    }
                  } else {
                    AlertDialogs().showModalDialogMessage(
                        context,
                        200,
                        Icons.visibility,
                        50,
                        Colors.red,
                        "Debes hacerte visible para comenzar la fiesta",
                        const TextStyle(fontSize: 18),
                        "Cerrar");
                  }
                }),
            FancyButton(
                text: 'Mis contactos',
                icon: Icons.favorite,
                color: Colors.pink,
                onTap: () {
                  NavigatorApp.push(ListContactsPage(), context);
                }),
            FancyButton(
                text: 'Buscar',
                icon: Icons.search,
                color: Colors.amber,
                onTap: () {
                  if (Session.location != null) {                    
                    NavigatorApp.push(MapFilterCriterialsPage(), context);
                  } else {
                    DefaultModalDialog.showErrorDialog(
                        context,
                        "Debes activar tu ubicación para poder acceder al mapa",
                        "Cerrar",
                        FontAwesomeIcons.exclamation);
                  }
                }),
            FancyButton(
                text: 'Mis Puntos',
                icon: Icons.nfc,
                color: const Color.fromARGB(255, 91, 3, 61),
                onTap: () {
                  NavigatorApp.push(SmartPointsListPage(), context);
                }),
            FancyButton(                
                text: 'Dónde ir',
                icon: Icons.people,
                color: Colors.green,
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}
