import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/HostGetAllSocialNetworksRequest.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/ui/NavigatorApp.dart';
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
        // drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.translate('app_name')),
        ),
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
                leading: const Icon(Icons.access_alarm),
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
        networks
            .add(SocialNetwork(item.name, item.name, ""));
      }
      setState(() {
        _isLoading = false;
      });
    });
  }
}
