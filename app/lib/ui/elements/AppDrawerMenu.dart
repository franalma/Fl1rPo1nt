import 'package:app/app_localizations.dart';
import 'package:app/model/Session.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/contacts/ListContactsPage.dart';
import 'package:app/ui/elements/CircleProfileImage.dart';
import 'package:app/ui/map_explorer/MapExplorerPage.dart';
import 'package:app/ui/my_social_networks/MySocialNetworksPage.dart';
import 'package:app/ui/point_interest/ListPointOfInterestPage.dart';
import 'package:app/ui/qr_manager/ListQrPage.dart';
import 'package:app/ui/user_profile/UserProfilePage.dart';
import 'package:app/ui/utils/location.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppDrawerMenu {
  Drawer getDrawer(BuildContext context) {
    return Drawer(
        child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30, // Size of the circle
                backgroundImage: NetworkImage(
                  'https://images.ctfassets.net/denf86kkcx7r/4IPlg4Qazd4sFRuCUHIJ1T/f6c71da7eec727babcd554d843a528b8/gatocomuneuropeo-97?fm=webp&w=913', // Replace with your image URL'
                ),
              ),
              Text("usser name"),
              Text("Escanos"),
              Text("Escaneado"),
            ],
          ),
        ),
        ListTile(
          leading:
              const Icon(Icons.account_box_rounded), // Icon at the beginning
          title: const Text('Mi perfil'),

          onTap: () {
            NavigatorApp.push(UserProfilePage(), context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.map_outlined), // Icon at the beginning
          title: const Text('Explorar'),
          onTap: () {
            launchMapExplorer(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.place_outlined),
          title: const Text('Puntos de interés'),
          onTap: () {
            NavigatorApp.push(ListPointOfInterestPage(), context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.message),
          title: const Text('Mis contactos'),
          onTap: () {
            NavigatorApp.push(ListContactsPage(), context);
          },
        ),
      ],
    ));
  }

  void onErrorLocation(String message) {}

  void launchMapExplorer(BuildContext context) async {
    if (Session.user.isFlirting) {
      LocationHandler(onErrorLocation).getCurrentLocation().then((value) {
        LatLng coordinates = LatLng(value.lat, value.lon);

        NavigatorApp.push(MapExplorerController(coordinates), context);
      });
    } else {
      FlutterToast().showToast("Debes comenzar a ligar para ver el mapa");
    }
  }
}
