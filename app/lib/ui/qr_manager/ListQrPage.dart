import 'dart:convert';
import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/qr/HostUpdateUserQrRequest.dart';

import 'package:app/model/QrValue.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/SlideRowLeft.dart';
import 'package:app/ui/qr_manager/NewQrGeneratePage.dart';
import 'package:app/ui/qr_manager/model/DataToSave.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ListQrPage extends StatefulWidget {
  @override
  State<ListQrPage> createState() {
    return _ListQrPage();
  }
}

class _ListQrPage extends State<ListQrPage> {
  List<QrValue> qrList = Session.user.qrValues;
  User user = Session.user;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.translate('app_name')),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  NavigatorApp.pushWithCallback(
                      QrGeneratePage(), context, _onPop);
                },
              ),
            ]),
        body: _buildList());
  }

  void _onPop() {
    setState(() {
      qrList = Session.user.qrValues;
    });
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: qrList.length,
        itemBuilder: (context, index) {                
          DataToSave data =
              DataToSave.fromJson(jsonDecode(qrList[index].content));
          return Column(
            children: [
              SlideRowLeft(
                onSlide: () => _removeItem(index),
                child: ListTile(
                  title: Text(qrList[index].name),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data.userName.isNotEmpty) Text(AppLocalizations.of(context)!.translate("your_name")),
                        if (data.userPhone.isNotEmpty) Text(AppLocalizations.of(context)!.translate("your_phone")),
                        for (var item in data.networks) Text(item.networkId)
                      ]),
                  leading: _buildQrCode(index),
                ),
              ),
              const Divider()
            ],
          );
        });
  }

  void _removeItem(int index) {
    Log.d("Starts _removeItem");
    qrList.removeAt(index);
    HostUpdateUserQrRequest().run(user.userId, qrList).then((value) {
      qrList = value.map((item) => item.qrValue).toList();
      user.qrValues = qrList;
      setState(() {});
    });
  }

  Widget _buildQrCode(int index) {
    var foregroundColor = Color(Colors.black.value);
    var backgroundColor = Color(Colors.white.value);

    if (user.relationShip.color.isNotEmpty) {
      foregroundColor = Color(CommonUtils.colorToInt(user.relationShip.color));
    }
    if (user.sexAlternatives.color.isNotEmpty) {
      backgroundColor =
          Color(CommonUtils.colorToInt(user.sexAlternatives.color));
    }
    return QrImageView(
        data: qrList[index].content,
        size: 30,
        // ignore: deprecated_member_use
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor);
  }
}
