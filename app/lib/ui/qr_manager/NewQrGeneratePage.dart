import 'dart:convert';

import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/qr/HostUpdateUserQrRequest.dart';

import 'package:app/model/QrValue.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/qr_manager/NewQrShareOptions.dart';
import 'package:app/ui/qr_manager/model/DataToSave.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGeneratePage extends StatefulWidget {
  @override
  State<QrGeneratePage> createState() {
    return _QrGeneratePage();
  }
}

class _QrGeneratePage extends State<QrGeneratePage> {
  TextEditingController controller = TextEditingController();

  User user = Session.user;
  final TextEditingController _qrNameController = TextEditingController();
  DataToSave? dataToSave;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildBody() {
    return Column(
      children: [
        ListTile(
          title: Text(
            "Nombre de tu QR",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          leading: Icon(Icons.qr_code),
          subtitle: Text(_qrNameController.text),
          onTap: () => AlertDialogs().showDialogEdit(
              context,
              _qrNameController.text,
              "Nombre de tu QR",
              "Introduce un valor", (value) {
            setState(() {
              _qrNameController.text = value;
            });
          }),
        ),
        Divider(),
        ListTile(
          title: const Text("Valores a compartir",
              style: TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(""),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () async {
            dataToSave = null;
            var result =
                await NavigatorApp.pushAndWait(NewQrShareOptions(), context)
                    as DataToSave;

            setState(() {
              dataToSave = result;
              controller.text = jsonEncode(dataToSave!.toJson());
            });
          },
        ),
        _buildQrPreview()
      ],
    );
  }

  void onQrInfoSelected(
      String name, String phone, List<SocialNetwork> networks) {
    Log.d("Starts onQrInfoSelected");

    dataToSave = DataToSave(name, phone, networks);
  }

  Widget _buildQrPreview() {
    // Este widget empuja el botón hacia abajo
    return controller.text.isNotEmpty
        ? QrImageView(data: controller.text, size: 200)
        : Container();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
            flexibleSpace: FlexibleAppBar(),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  onSaveQr();
                },
              ),
            ]),
        body: _buildBody());
  }

  Future<void> onSaveQr() async {
    Log.d("Starts onSaveQr:${controller.text}");
    if (controller.text.isEmpty) {
      FlutterToast().showToast("Es necesario que selecciones algún valor");
    } else if (_qrNameController.text.isEmpty) {
      FlutterToast().showToast("Es necesario un nombre para tu QR");
    } else {
      QrValue qrValue =
          QrValue(user.userId, "", _qrNameController.text, controller.text);
      user.qrValues.add(qrValue);
      HostUpdateUserQrRequest().run(user.userId, user.qrValues).then((result) {
        user.qrValues = result.map((e) => e.qrValue).toList();
        NavigatorApp.pop(context);
      });
    }
  }
}
