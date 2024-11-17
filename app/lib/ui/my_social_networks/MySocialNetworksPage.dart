import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/HostUpdateUserSocialNetworksRequest.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/my_social_networks/NewSocialNetwork.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MySocialNetworksPage extends StatefulWidget {
  const MySocialNetworksPage({super.key});

  @override
  State<MySocialNetworksPage> createState() {
    return _MySocialNetworksPage();
  }
}

class _MySocialNetworksPage extends State<MySocialNetworksPage> {
  List<SocialNetwork> networks = Session.user.networks;
  bool _isLoading = false;
  User user = Session.user;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: AppDrawerMenu().getDrawer(context),
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
        body: _isLoading ? _buildLoading() : _buildList());
  }

  void _onPop() {
    setState(() {
      networks = Session.user.networks;
    });
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: networks.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(networks[index].name),
              leading: _getIconFromNetwork(index),
              trailing: ElevatedButton(
                onPressed: () {
                  _onDeleteSocialNetwork(index);
                },
                child: Text("Eliminar"),
              ));
        });
  }

  Future<void> _onDeleteSocialNetwork(int index) async {
    Log.d("Starts _onDeleteSocialNetwork");
    setState(() {
      _isLoading = true;
    });
    networks.removeAt((index));
    HostUpdateUserSocialNetworksRequest()
        .run(user.userId, networks)
        .then((updates) {
      networks = updates
          .map((e) => SocialNetwork(e.networkId, e.name, e.value))
          .toList();
      user.networks = networks;
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget? _getIconFromNetwork(int index) {
    var network = networks[index];
    IconData? iconData;
    switch (network.networkId) {
      case "11":
        iconData = FontAwesomeIcons.twitter;
    }

    return Icon(
      iconData, // Twitter icon
      size: 20.0, // Size of the icon
      color: Colors.blue, // Color of the icon
    );
  }
}
