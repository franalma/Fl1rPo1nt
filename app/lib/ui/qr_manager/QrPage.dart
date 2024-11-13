import 'package:app/app_localizations.dart';
import 'package:app/model/QrValue.dart';
import 'package:app/model/Session.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AppDrawerMenu.dart';
import 'package:app/ui/qr_manager/qr_add/QrGeneratePage.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPage extends StatefulWidget {
  @override
  State<QrPage> createState() {
    return _QrPage();
  }
}

class _QrPage extends State<QrPage> {
  List<QrValue> qrList = Session.user.qrValues;

  @override
  void initState() {
    super.initState();
  }

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
        body: _buildList());
  }

  
  Widget _buildList() {
    return ListView.builder(
        itemCount: qrList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Column(children: [
              Text(qrList[index].qrId),
              QrImageView(data: qrList[index].content, size: 100)
            ]),
          );
        });
  } 
}
