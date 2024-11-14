import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/HostUpdateUserQrRequest.dart';
import 'package:app/model/QrValue.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AppDrawerMenu.dart';
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
  List<Map<String, dynamic>> qrItems = [];

  Map<String, dynamic> qrObj = {};

  TextEditingController controller = TextEditingController();
  List selectedIndex = [];
  User user = Session.user;
  TextEditingController _qrEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfoForQr();
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
                  onSaveQr();
                },
              ),
            ]),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: _qrEditingController,
                decoration: const InputDecoration(labelText: 'Nombre de tu QR'),
                keyboardType: TextInputType.emailAddress,
              ),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Elige los valores para tu QR: ",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: qrItems.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(qrItems[index]["name"]),
                    value: qrItems[index]["isChecked"],
                    onChanged: (bool? value) {
                      setState(() {
                        qrItems[index]["isChecked"] = value!;
                        updateValue(index);
                      });
                    },
                  );
                },
              )),
              const Spacer(), // Este widget empuja el botón hacia abajo
              (selectedIndex.isNotEmpty)
                  ? QrImageView(data: controller.text, size: 200)
                  : Container()
            ],
          ),
        )));
  }

  void updateValue(int index) {
    Log.d("updateValue: $index");
    String text = "";
    controller.text = "";

    try {
      if (qrItems[index]["isChecked"]) {
        selectedIndex.add(index);
      } else {
        selectedIndex.remove(index);
      }
      for (var item in qrItems) {
        if (item["isChecked"]) {        
          text = "${text + ";" + item["name"]}:" + item["value"];
        }
      }
      // text = qrItems.map((e) {
      //   if (e["isChecked"]) {
      //     return e["name"] + ":" + e["value"];
      //   }
      //   return "";
      // }).toString();
    } catch (error) {
      Log.d(error.toString());
    }

    controller.text = text;
  }

  Future<void> onSaveQr() async {
    Log.d("Starts onSaveQr:${controller.text}");
    if (controller.text.isEmpty) {
      FlutterToast().showToast("Es necesario que selecciones algún valor");
    } else {
      // var values = controller.text.split(",");
      // print(values);
      // List<dynamic> preparedList = [];

      // for (var it in values) {
      //   if (it.isNotEmpty) {
      //     print("-->it:$it");
      //     print(it.split(":"));
      //     preparedList
      //         .add({"name": it.split(":")[0], "value": it.split(":")[1]});
      //   }
      // }

      // preparedList.map((e) => print(e["name"] + ":" + e["value"])).toList();

      QrValue qrValue = QrValue(user.userId, "",_qrEditingController.text , controller.text);
      user.qrValues.add(qrValue);
      HostUpdateUserQrRequest().run(user.userId, user.qrValues).then((result) {
        if (result) {
          NavigatorApp.pop(context);
        } else {
          user.qrValues.remove(qrValue);
          FlutterToast().showToast("No ha sido posible actualizar los valores");
        }
      });
    }
  }

  void _loadUserInfoForQr() {
    Log.d("Starts _loadUserInfoForQr");
    qrItems.add({"name": "Nombre", "isChecked": false, "value": user.name});
    if (user.phone.isNotEmpty) {
      qrItems
          .add({"name": "Teléfono", "isChecked": false, "value": user.phone});
    }

    if (user.networks != null) {
      qrItems.addAll(user.networks
          .map((e) => {"name": e.name, "isChecked": false, "value": e.value})
          .toList());
    }
  }
}
