import 'package:app/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.translate('app_name'))),
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
                    });
                  },
                );
              },
            )),
            const Spacer(), // Este widget empuja el botón hacia abajo
            ElevatedButton(
              onPressed: () {
                
                generateQrCode();
              },
              child: Text('Generar QR'),
            ),
          ],
        )));
  }

  void generateQrCode(){
      QrImage qr = QrImage(data:"fadfdsa");

           
           
  }
}
