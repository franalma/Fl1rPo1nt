import 'dart:convert';
import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/HostUpdateUserDefaultQr.dart';
import 'package:app/comms/model/request/qr/HostUpdateUserQrRequest.dart';

import 'package:app/model/QrValue.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
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
  int _selectedQr = 0;
  User user = Session.user;
  @override
  void initState() {
    for (var index = 0; index < qrList.length; index++) {
      if (qrList[index].qrId == user.qrDefaultId) {
        _selectedQr = index;
        break;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
            flexibleSpace: FlexibleAppBar(),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _beforeDispose();
                }),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.add,
                ),
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
                        if (data.userName.isNotEmpty)
                          Text(AppLocalizations.of(context)!
                              .translate("your_name")),
                        if (data.userPhone.isNotEmpty)
                          Text(AppLocalizations.of(context)!
                              .translate("your_phone")),
                        for (var item in data.networks) Text(item.networkId)
                      ]),
                  leading: _buildQrCode(index),
                  trailing: Radio(
                      value: index,
                      groupValue: _selectedQr,
                      onChanged: ((value) {
                        setState(() {
                          _selectedQr = value!;
                        });
                      })),
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
      setState(() {
        _selectedQr = 0;
      });
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

  Future<void> _beforeDispose() async {
    Log.d("Starts _beforeDispose");
    if (qrList.isNotEmpty) {
      if (user.qrDefaultId != qrList[_selectedQr].qrId) {
        bool result = await HostUpdateUserDefaultQr()
            .run(user.userId, qrList[_selectedQr].qrId);
        if (result) {
          user.qrDefaultId = qrList[_selectedQr].qrId;
          NavigatorApp.pop(context);
        }
      }else{
          NavigatorApp.pop(context);
      }
      
    } else {
      NavigatorApp.pop(context);
    }
  }
}
