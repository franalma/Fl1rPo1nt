import 'package:app/app_localizations.dart';
import 'package:app/model/Session.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AppDrawerMenu.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGeneratePage extends StatefulWidget {
  @override
  State<QrGeneratePage> createState() {
    return _QrGeneratePage();
  }
}

class _QrGeneratePage extends State<QrGeneratePage> {
  List<Map<String, dynamic>> items = [
    {"name": "Nombre", "isChecked": false},
    {"name": "Teléfono", "isChecked": false},
    {"name": "Mail", "isChecked": false},
  ];
  TextEditingController controller = TextEditingController();
  List selectedIndex = [];

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
            child: Column(
          children: [
            const Text("Elige los valores para tu QR: "),
            Expanded(
                child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(items[index]["name"]),
                  value: items[index]["isChecked"],
                  onChanged: (bool? value) {
                    setState(() {
                      items[index]["isChecked"] = value!;
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
        )));
  }

  void updateValue(int index) {
    String text = "";
    controller.text = "";

    if (items[index]["isChecked"]) {
      selectedIndex.add(index);
    } else {
      selectedIndex.remove(index);
    }

    for (var value in selectedIndex) {
      switch (value) {
        case 0:
          {
            text = "$text${Session.user.name}:";
            break;
          }
        case 1:
          {
            text = "$text${Session.user.phone}:";
            break;
          }
      }
    }
    controller.text = text;
  }


  void onSaveQr()async {



  }
}
