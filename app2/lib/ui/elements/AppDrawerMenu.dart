import 'package:app/app_localizations.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/qr_manager/QrPage.dart';
import 'package:app/ui/user_profile/UserProfilePage.dart';
import 'package:flutter/material.dart';

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
            // Update the state of the app.
            // ...
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
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: const Text('Mi estado'),
          onTap: () {
            // Update the state of the app.
            // ...
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
}
