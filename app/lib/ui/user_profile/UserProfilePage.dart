import 'package:app/app_localizations.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AppDrawerMenu.dart';
import 'package:app/ui/my_social_networks/MySocialNetworksPage.dart';
import 'package:app/ui/qr_manager/ListQrPage.dart';
import 'package:app/ui/user_state/UserStatePage.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() {
    return _UserProfilePage();
  }
}

class _UserProfilePage extends State<UserProfilePage> {
  List<String> menuList = ["Estado", "Mis QR", "Mis redes", "Cerrar sesión"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.translate('app_name')),
        ),
        body: _buildList());
  }

  Widget _buildList() {
    return ListView(
      children: [
        ListTile(
            title: Text("Mi estado"),
            trailing: Icon(Icons.arrow_forward_ios), // Add a left arrow icon
            onTap: () => NavigatorApp.push(UserStatePage(), context)),
        Divider(),
        ListTile(
            title: Text("Mis QR"),
            trailing: Icon(Icons.arrow_forward_ios), // Add a left arrow icon
            onTap: () => NavigatorApp.push(ListQrPage(), context)),
        Divider(),
        ListTile(
            title: Text("Mis redes"),
            trailing: Icon(Icons.arrow_forward_ios), // Add a left arrow icon
            onTap: () => NavigatorApp.push(MySocialNetworksPage(), context)),
        Divider(),
        ListTile(
            title: Text("Cerrar sesión"),
            trailing: Icon(Icons.arrow_forward_ios), // Add a left arrow icon
            onTap: () => NavigatorApp.push(UserStatePage(), context)),
      ],
    );
  }
}
