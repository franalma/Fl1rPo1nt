import 'package:app/app_localizations.dart';

import 'package:app/model/Session.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/qr_manager/model/DataToSave.dart';

import 'package:flutter/material.dart';

class NewQrShareOptions extends StatefulWidget {
  @override
  State<NewQrShareOptions> createState() {
    return _NewQrShareOptions();
  }
}

class _NewQrShareOptions extends State<NewQrShareOptions> {
  List<Map<String, dynamic>> qrItems = [];
  List<SocialNetwork> networks = [];

  TextEditingController controller = TextEditingController();
  List selectedIndex = [];
  User user = Session.user;
  bool _isNameSelected = false;
  bool _isPhoneSelected = false;
  @override
  void initState() {
    networks = user.networks;
    super.initState();
  }

  Widget _buildSocialNetwors() {
    return Expanded(
      child: ListView.builder(
        itemCount: networks.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              CheckboxListTile(
                title: Text(networks[index].name),
                value: selectedIndex.contains(index),
                onChanged: (bool? value) {
                  setState(() {
                    if (value!) {
                      selectedIndex.add(index);
                    } else {
                      selectedIndex.remove(index);
                    }
                  });
                },
              ),
              const Divider()
            ],
          );
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleAppBar(),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _onPop();
                // Pass a value and navigate back
              }),
        ),
        body: Column(
          children: [
            CheckboxListTile(
              title: const Text("Nombre"),
              subtitle: Text(user.name),
              value: _isNameSelected,
              onChanged: (value) {
                setState(() {
                  _isNameSelected = value!;
                });
              },
            ),
            const Divider(),
            CheckboxListTile(
              title: const Text("Tus fotos"),              
              value: _isNameSelected,
              onChanged: (value) {
                setState(() {
                  _isNameSelected = value!;
                });
              },
            ),
            const Divider(),
            CheckboxListTile(
              title: const Text("Tus audios"),              
              value: _isNameSelected,
              onChanged: (value) {
                setState(() {
                  _isNameSelected = value!;
                });
              },
            ),
            const Divider(),
            user.phone.isNotEmpty
                ? CheckboxListTile(
                    title: const Text("Teléfono"),
                    subtitle: Text(user.name),
                    value: _isPhoneSelected,
                    onChanged: (value) {
                      setState(() {
                        _isPhoneSelected = value!;
                      });
                    },
                  )
                : Container(),
            user.phone.isNotEmpty ? const Divider() : Container(),
            _buildSocialNetwors(),
          ],
        ));
  }

  void _onPop() {
    List<SocialNetwork> socialNetWorksSelected = [];
    for (var item in selectedIndex) {
      socialNetWorksSelected.add(networks[item]);
    }
    DataToSave dataToSave = DataToSave(_isNameSelected ? user.name : "",
        _isPhoneSelected ? user.phone : "", socialNetWorksSelected);

    NavigatorApp.popWith(context, dataToSave);
  }
}
