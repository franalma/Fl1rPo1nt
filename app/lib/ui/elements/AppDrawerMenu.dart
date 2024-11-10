import 'package:app/app_localizations.dart';
import 'package:flutter/material.dart';

class AppDrawerMenu{
  Drawer getDrawer(BuildContext context){
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
            title: const Text('Entrenamientos'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Dietas'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),

          ListTile(
            title: const Text('Consejos'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),

        ],
      )
    );
  }
}