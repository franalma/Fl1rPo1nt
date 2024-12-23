import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/fix_values/HostGetAllSocialNetworksRequest.dart';

import 'package:app/model/SocialNetwork.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/SocialNetworkIcon.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';

class NewSocialNetworkSelection extends StatefulWidget {
  Function(SocialNetwork) onSelected;

  NewSocialNetworkSelection(this.onSelected, {super.key});

  @override
  State<NewSocialNetworkSelection> createState() {
    return _NewSocialNetworkSelection();
  }
}

class _NewSocialNetworkSelection extends State<NewSocialNetworkSelection> {
  List<SocialNetwork> networks = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchFromHost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        appBar: AppBar(flexibleSpace: FlexibleAppBar()),
        body: _isLoading ? _buildLoading() : _buildEditOptions());
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildEditOptions() {
    return ListView.builder(
        itemCount: networks.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(networks[index].name),
                leading: SocialNetworkIcon().resolveIconForNetWorkId(networks[index].name),
                onTap: () {
                  widget.onSelected(networks[index]);
                  NavigatorApp.pop(context);
                },
              ),
              const Divider()
            ],
          );
        });
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts _fetchFromHost");
    HostGetAllSocialNetworksRequest().run().then((values) {
      for (var item in values) {
        networks.add(SocialNetwork(item.name, item.name, ""));
      }
      setState(() {
        _isLoading = false;
      });
    });
  }
}
