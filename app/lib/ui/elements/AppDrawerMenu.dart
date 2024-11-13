import 'package:app/app_localizations.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/map_explorer/MapExplorerPage.dart';
import 'package:app/ui/my_social_networks/MySocialNetworksPage.dart';
import 'package:app/ui/qr_manager/QrPage.dart';
import 'package:app/ui/user_profile/UserProfilePage.dart';
import 'package:app/ui/user_state/UserStatePage.dart';
import 'package:app/ui/utils/location.dart';
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
          child: Text(AppLocalizations.of(context)!.translate("app_name")),
        ),
        ListTile(
          title: const Text('Explorar'),
          onTap: () {
            launchMapExplorer(context);
          },
        ),
        ListTile(
          title: const Text('Mis QR'),
          onTap: () {
            NavigatorApp.push(QrPage(), context);
          },
        ),
        ListTile(
          title: const Text('Mi perfil'),
          onTap: () {
            NavigatorApp.push(UserProfilePage(), context);
          },
        ),
        ListTile(
          title: const Text('Mis redes'),
          onTap: () {
            NavigatorApp.push(MySocialNetworksPage(), context);
          },
        ),
        ListTile(
          title: const Text('Mi estado'),
          onTap: () {
            NavigatorApp.push(UserStatePage(), context);
          },
        ),
        ListTile(
          title: const Text('Mis contactos'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: const Text('Cerrar sesión'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
      ],
    ));
  }

  void onErrorLocation(String message) {}

  void launchMapExplorer(BuildContext context) async {
    LocationHandler(onErrorLocation).getCurrentLocation().then((value) {
      LatLng coordinates = LatLng(value.lat, value.lon);
      print("-->coordinates: "+coordinates.latitude.toString()+":"+coordinates.longitude.toString());
      NavigatorApp.push(MapExplorerController(coordinates), context);
    });
  }
}
