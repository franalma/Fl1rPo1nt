import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/HostGetAllSocialNetworksRequest.dart';
import 'package:app/comms/model/request/HostUpdateUserSocialNetworksRequest.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AppDrawerMenu.dart';
import 'package:app/ui/elements/Navigator.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';

class NewSocialNetwork extends StatefulWidget {
  @override
  State<NewSocialNetwork> createState() {
    return _NewSocialNetwork();
  }
}

class _NewSocialNetwork extends State<NewSocialNetwork> {
  List<SocialNetwork> networks = [];
  User user = Session.user;
  String? selectedNetwork;
  List<String> values = [];
  TextEditingController editNetworkController = TextEditingController();
  TextEditingController editNameController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFromHost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.translate('app_name')),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  _onSaveData();
                },
              ),
            ]),
        body: _isLoading ? _buildLoading() : _buildEditOptions());
  }

  Widget _buildLoading() {
    return CircularProgressIndicator();
  }

  Widget _buildEditOptions() {
    return ListView(
      children: [
        Card(
          child: ListTile(
              title: Text("Introduce el nombre que quieres compartir "),
              subtitle: TextFormField(
                controller: editNameController,
                keyboardType: TextInputType.name,
              )),
        ),
        Card(
          child: ListTile(
              title: Text("Introduce el valor de tu red social"),
              subtitle: TextFormField(
                controller: editNetworkController,
                keyboardType: TextInputType.emailAddress,
              )),
        ),
        Card(
            child: Column(
          children: [
            Text("Selecciona la red social"),
            _buildSocialNetworkOptions()
          ],
        ))
      ],
    );
  }

  Widget _buildSocialNetworkOptions() {
    return DropdownButton<String>(
        value: selectedNetwork,
        hint: Text('Seleccione un item'),
        onChanged: (String? newValue) {
          setState(() {
            selectedNetwork = newValue!;
          });
        },
        items: networks.map<DropdownMenuItem<String>>((value) {
          print(value.name + " " + value.networkId);
          return DropdownMenuItem<String>(
            value: value.networkId,
            child: Text(value.name),
          );
        }).toList());
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts _fetchFromHost");
    HostGetAllSocialNetworksRequest().run().then((values) {
      for (var item in values) {
        networks
            .add(SocialNetwork(item.socialNetWorkId.toString(), item.name, ""));
      }
      // selectedNetwork = networks[0].name;
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _onSaveData() async {
    Log.d("Starts _onSaveData");
    var networksToUpate = user.networks;
    if (selectedNetwork != null) {
      var newNetwork =
          SocialNetwork("", selectedNetwork!, editNetworkController.text);
      networksToUpate.add(newNetwork);
      HostUpdateUserSocialNetworksRequest()
          .run(user.userId, networksToUpate)
          .then((value) {
        if (value.isEmpty) {
          FlutterToast().showToast("No se ha podido añadir la red");
          networksToUpate.remove(newNetwork);
        } else {
          NavigatorApp.pop(context);
        }
      });
    } else {
      FlutterToast().showToast("Debes rellenar todos los campos");
    }
  }
}
