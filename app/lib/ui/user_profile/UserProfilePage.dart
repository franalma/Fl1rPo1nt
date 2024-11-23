import 'package:app/app_localizations.dart';
import 'package:app/main.dart';
import 'package:app/model/SecureStorage.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/flirts/FlirtsStatsPage.dart';
import 'package:app/ui/my_social_networks/MySocialNetworksPage.dart';
import 'package:app/ui/qr_manager/ListQrPage.dart';
import 'package:app/ui/user_profile/UserDataPage.dart';
import 'package:app/ui/user_state/UserStatePage.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() {
    return _UserProfilePage();
  }
}

class _UserProfilePage extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
         
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
        body: _buildList());
  }

  Widget _buildList() {
    return ListView(
      children: [
        ListTile(
            title: const Text("Mis datos", style: TextStyle(fontSize: 20)),
            trailing:
                const Icon(Icons.arrow_forward_ios), // Add a left arrow icon
            onTap: () => NavigatorApp.push(UserDataPage(), context)),
        Divider(),
        ListTile(
            title: Text("Mi estado",style: TextStyle(fontSize: 20)),
            trailing: Icon(Icons.arrow_forward_ios), // Add a left arrow icon
            onTap: () => NavigatorApp.push(UserStatePage(), context)),
        Divider(),
        ListTile(
            title: Text("Mis QR",style: TextStyle(fontSize: 20)),
            trailing: Icon(Icons.arrow_forward_ios), // Add a left arrow icon
            onTap: () => NavigatorApp.push(ListQrPage(), context)),
        Divider(),
        ListTile(
            title: Text("Mis redes",style: TextStyle(fontSize: 20)),
            trailing: Icon(Icons.arrow_forward_ios), // Add a left arrow icon
            onTap: () => NavigatorApp.push(MySocialNetworksPage(), context)),
        Divider(),
        ListTile(
            title: Text("Mis estadísticas",style: TextStyle(fontSize: 20)),
            trailing: const Icon(Icons.arrow_forward_ios), // Add a left arrow icon
            onTap: () => NavigatorApp.push(FlirtsStatsPage(), context)),
        Divider(),
        ListTile(
            title: const Text(
              "Cerrar sesión",
              style: TextStyle(color: Colors.red,fontSize: 20),
            ),
            onTap: () => _closeSession())
      ],
    );
  }

  void _closeSession() async {
    await SecureStorage().deleteSecureData("user_id");
    await SecureStorage().deleteSecureData("token");
    await SecureStorage().deleteSecureData("refresh_token");
    await NavigatorApp.pushAndRemoveUntil(context, const MyApp());
  }
}
