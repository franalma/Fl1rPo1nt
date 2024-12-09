import 'package:app/model/Session.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/services/NewMessageService.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/ads/AdsManager.dart';
import 'package:app/ui/contacts/ListContactsPage.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FancyButton.dart';
import 'package:app/ui/elements/FlirtPoint.dart';
import 'package:app/ui/map_explorer/MapExplorerPage.dart';
import 'package:app/ui/my_social_networks/MySocialNetworksPage.dart';
import 'package:app/ui/party_mode/PartyModePage.dart';
import 'package:app/ui/qr_manager/ListQrPage.dart';
import 'package:app/ui/smart_points/SmartPointsAddPage.dart';
import 'package:app/ui/user_profile/UserProfilePage.dart';
import 'package:app/ui/user_state/UserStatePage.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home2Page extends StatefulWidget {
  @override
  State<Home2Page> createState() => _Home2State();
}

class _Home2State extends State<Home2Page> {
  // late AdsManager _adsManager;
  @override
  void initState() {
    super.initState();
    // _adsManager = AdsManager(onAdaptativeBannerLoaded);
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
    // _adsManager.init(context);
    return Scaffold(
        appBar: AppBar(          
          actions: [
            IconButton(
                onPressed: () {
                  NavigatorApp.push(UserProfilePage(), context);
                },
                icon: Icon(Icons.account_circle))
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
          children: [_buildBody(), 
          // _adsManager.buildAdaptativeBannerd(context)
          
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
                text: 'Visibilidad',
                icon: FontAwesomeIcons.eye,
                color: Color.fromARGB(255, 237, 129, 6),
                onTap: () {
                  NavigatorApp.push(UserStatePage(), context);
                }),
            FancyButton(
                text: 'Modo fiesta',
                icon: FontAwesomeIcons.hands,
                color: Colors.blue,
                onTap: () {
                  NavigatorApp.push(PartyModePage(), context);
                }),
            FancyButton(
                text: 'Mis contactos',
                icon: Icons.favorite,
                color: Colors.pink,
                onTap: () {
                  NavigatorApp.push(ListContactsPage(), context);
                }),
            FancyButton(
                text: 'Explorar',
                icon: Icons.map,
                color: Colors.amber,
                onTap: () {
                  var location =
                      LatLng(Session.location!.lat, Session.location!.lon);
                  NavigatorApp.push(MapExplorerController(location), context);
                }),
            FancyButton(
                text: 'Mis QR',
                icon: Icons.qr_code,
                color: Color.fromARGB(255, 187, 23, 202),
                onTap: () {
                  
                  NavigatorApp.push(ListQrPage(), context);
                }),
            FancyButton(
                text: 'Mis Puntos',
                icon: Icons.nfc,
                color: Color.fromARGB(255, 91, 3, 61),
                onTap: () {                
                  NavigatorApp.push(SmartPointsPage(), context);
                }),
                 FancyButton(
                text: 'Mis redes',
                icon: FontAwesomeIcons.solidCirclePlay,
                color: Color.fromARGB(255, 85, 22, 244),
                onTap: () {
                   NavigatorApp.push(MySocialNetworksPage(), context);
                }),
            FancyButton(
                text: 'Eventos',
                icon: Icons.people,
                color: Colors.green,
                onTap: () {}),
          ],
        ),
      ),
    );
  }

  void onAdaptativeBannerLoaded(bool value) {
    Log.d("Starts onAdaptativeBannerLoaded");
    if (value) {
      setState(() {});
    }
  }
}
