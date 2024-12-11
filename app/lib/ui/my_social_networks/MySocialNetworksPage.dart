import 'package:app/comms/model/request/user/profile/HostUpdateUserSocialNetworksRequest.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/SlideRowLeft.dart';
import 'package:app/ui/elements/SocialNetworkIcon.dart';
import 'package:app/ui/my_social_networks/new_social_network/NewSocialNetwork.dart';
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
     
        appBar: AppBar(flexibleSpace: FlexibleAppBar(), actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              NavigatorApp.pushWithCallback(
                  NewSocialNetwork(null), context, _onPop);
            },
          ),
        ]),
        body: _isLoading ? AlertDialogs().buildLoading() : _buildList());
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
          networks[index].print();
          return SlideRowLeft(
            onSlide: () {
              _onDeleteSocialNetwork(index);
            },
            child: Column(
              children: [
                ListTile(
                    title: Text(networks[index].name),
                    leading: SocialNetworkIcon().resolveIconForNetWorkId(networks[index].networkId),
                    trailing: const Icon(Icons.arrow_forward_ios_sharp),
                    onTap: () {
                      NavigatorApp.pushWithCallback(
                          NewSocialNetwork(networks[index]), context, _onPop);
                    }),
                const Divider()
              ],
            ),
          );
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
