import 'package:app/app_localizations.dart';
import 'package:app/model/Flirt.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AppDrawerMenu.dart';
import 'package:app/ui/qr_manager/qr_add/QrGeneratePage.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';

class FlirtsPage extends StatefulWidget {
  @override
  State<FlirtsPage> createState() {
    return _FlirtsPage();
  }
}

class _FlirtsPage extends State<FlirtsPage> {
  List<Flirt> flirtList = [];
  bool _isLoading = true;
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
        itemCount: flirtList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Column(children: [
              Text(flirtList[index].id),              
            ]),
          );
        });
  } 
}
