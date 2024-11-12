import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/HostAllQrRequest.dart';
import 'package:app/comms/model/response/HostAllQrResponse.dart';
import 'package:app/model/session.dart';
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
  List<HostAllQrResponse> qrList = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadFromHost();
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
        body: _isLoading ? _buildLoading() : _buildList());
  }

  Widget _buildLoading(){
    return  const Center(child: CircularProgressIndicator());
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: qrList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Column(children: [
              Text(qrList[index].qrId),
              QrImageView(data: qrList[index].qrContent, size: 100)
            ]),
          );
        });
  }

  Future<void> _loadFromHost() async {
    String userId = Session.user.userId;
    HostAllQrRequest().run(userId).then((value) {
      qrList = value;
      setState(() {
        Log.d("$value: len ${qrList.length}");
        _isLoading = false;
      });
    });
  }
}
