import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/HostUpdateUserSocialNetworksRequest.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/my_social_networks/new_social_network/NewSocialNetworkSelection.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';

class NewSocialNetwork extends StatefulWidget {
  final SocialNetwork? _socialNetworkSelected;
  NewSocialNetwork(this._socialNetworkSelected, {super.key});

  @override
  State<NewSocialNetwork> createState() {
    return _NewSocialNetwork();
  }
}

class _NewSocialNetwork extends State<NewSocialNetwork> {
  User user = Session.user;
  SocialNetwork? _socialNetworkSelected;
  TextEditingController editNetworkValueController = TextEditingController();
  TextEditingController editNetworkUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _socialNetworkSelected = widget._socialNetworkSelected;

    if (_socialNetworkSelected != null) {
      _socialNetworkSelected!.print();
      setState(() {
        editNetworkValueController.text = _socialNetworkSelected!.name;
        editNetworkUrlController.text = _socialNetworkSelected!.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
            flexibleSpace: FlexibleAppBar(),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  _onSaveData();
                },
              ),
            ]),
        body: _buildEditOptions());
  }

  Widget _buildEditOptions() {
    return ListView(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.translate("social_network"),
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: _socialNetworkSelected != null
              ? Text(_socialNetworkSelected!.networkId)
              : const Text(""),
          onTap: () {
            NavigatorApp.push(NewSocialNetworkSelection((network) {
              setState(() {
                _socialNetworkSelected = network;
              });
            }), context);
          },
          trailing: const Icon(Icons.arrow_forward_ios_sharp),
        ),
        const Divider(),
        ListTile(
          title: Text(AppLocalizations.of(context)!.translate("network_value"),
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(editNetworkValueController.text),
          onTap: () {
            AlertDialogs().showDialogEdit(
                context,
                editNetworkValueController.text,
                AppLocalizations.of(context)!.translate("network_value"),
                AppLocalizations.of(context)!.translate("input_value"),
                (result) {
              setState(() {
                editNetworkValueController.text = result;
              });
            });
          },
        ),
        Divider(),
        ListTile(
          title:
              const Text("Url ", style: TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(editNetworkUrlController.text),
          onTap: () {
            AlertDialogs().showDialogEdit(
                context,
                editNetworkUrlController.text,
                AppLocalizations.of(context)!.translate("network_url"),
                AppLocalizations.of(context)!.translate("input_value"),
                (result) {
              setState(() {
                editNetworkUrlController.text = result;
              });
            });
          },
        ),
        const Divider(),
      ],
    );
  }

  Future<void> _onSaveData() async {
    Log.d("Starts _onSaveData");
    var networksToUpate = user.networks;
    if (_socialNetworkSelected != null) {
      var newNetwork = SocialNetwork(_socialNetworkSelected!.name,
          editNetworkValueController.text, editNetworkUrlController.text);
      networksToUpate.add(newNetwork);
      HostUpdateUserSocialNetworksRequest()
          .run(user.userId, networksToUpate)
          .then((value) {
        if (value.isEmpty) {
          FlutterToast().showToast( AppLocalizations.of(context)!.translate("network_added_error"),);
          networksToUpate.remove(newNetwork);
        } else {
          NavigatorApp.pop(context);
        }
      });
    } else {
      FlutterToast().showToast(AppLocalizations.of(context)!.translate("all_fields_required"));
    }
  }
}
