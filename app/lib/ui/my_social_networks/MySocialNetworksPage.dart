import 'package:app/app_localizations.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AppDrawerMenu.dart';
import 'package:app/ui/my_social_networks/NewSocialNetwork.dart';
import 'package:flutter/material.dart';

class MySocialNetworksPage extends StatefulWidget {
  @override
  State<MySocialNetworksPage> createState() {
    return _MySocialNetworksPage();
  }
}

class _MySocialNetworksPage extends State<MySocialNetworksPage> {
  List<SocialNetwork> networks = Session.user.networks;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.translate('app_name')),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  NavigatorApp.pushWithCallback(
                      NewSocialNetwork(), context, _onPop);
                },
              ),
            ]),
        body: _buildList());
  }

  void _onPop() {
    setState(() {
      networks = Session.user.networks;
    });
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: networks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Column(children: [
              Text(networks[index].networkId),
              Text(networks[index].name),
              Text(networks[index].value),
            ]),
          );
        });
  }
}
