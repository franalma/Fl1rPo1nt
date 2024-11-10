import 'package:app/app_localizations.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AppDrawerMenu.dart';
import 'package:app/ui/qr_manager/qr_add/QrGeneratePage.dart';
import 'package:flutter/material.dart';

class QrPage extends StatefulWidget {
  @override
  State<QrPage> createState() {
    return _QrPage();
  }
}

class _QrPage extends State<QrPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.translate('app_name')),
            actions: [
              IconButton(
                icon: const Icon(Icons.add), 
                onPressed: () {                  
                  NavigatorApp.push(QrGeneratePage(), context);      
                },
              ),
            ]),
        body: Center(
            child: Column(
          children: [],
        )));
  }
}
