import 'dart:convert';

import 'package:app/comms/model/request/matchs/HostPutUserContactRequest.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/SmartPoint.dart';
import 'package:app/model/User.dart';
import 'package:app/services/DeviceInfoService.dart';
import 'package:app/services/NfcService.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ads/AdsManager.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/DefaultModalDialog.dart';
import 'package:app/ui/elements/FlirtPoint.dart';
import 'package:app/ui/qr_manager/QrCodeScannerPage.dart';
import 'package:app/ui/qr_manager/ShowQrCodeToShare.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PartyModePage extends StatefulWidget {
  @override
  State<PartyModePage> createState() {
    return _PartyModeState();
  }
}

class _PartyModeState extends State<PartyModePage> {
  User user = Session.user;
  // late AdsManager adsManager;
  bool _isAdLoadedBanner = false;

  @override
  void initState() {
    // adsManager = AdsManager((value) => _loadedAd(value));

    super.initState();
  }

  void _loadedAd(value) {
    Log.d("Starts _loadedAd $value");
    setState(() {
      _isAdLoadedBanner = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // adsManager.init(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56.0), // Height of the AppBarP
          child: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      if (user.isFlirting) {
                        NavigatorApp.push(QrCodeScannerPage(), context);
                      } else {
                        FlutterToast()
                            .showToast("Debes comenzar a ligar para acceder");
                      }
                    },
                    icon: const Icon(Icons.camera_enhance)),
                IconButton(
                    onPressed: () {
                      if (user.isFlirting) {
                        NavigatorApp.push(ShowQrCodeToShare(), context);
                      } else {
                        FlutterToast()
                            .showToast("Debes comenzar a ligar para acceder");
                      }
                    },
                    icon: const Icon(Icons.qr_code)),
                IconButton(
                    onPressed: () async {
                      if (user.isFlirting) {
                        _readPoint();
                      } else {
                        FlutterToast()
                            .showToast("Debes comenzar a ligar para acceder");
                      }
                    },
                    icon: const Icon(Icons.nfc)),
              ]),
        ),
        body: Stack(
          children: [
            Center(
                child: user.isFlirting
                    ? _buildEnabledFlirtPanelPoint()
                    : _buildDisabledPanel()),
            // if (_isAdLoadedBanner) adsManager.buildAdaptativeBannerd(context)
          ],
        ));
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildDisabledPanel() {
    return const Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center content vertically
        children: [
          SizedBox(height: 25),
          SizedBox(height: 70),
        ],
      ),
    );
  }

  Widget _buildEnabledFlirtPanelPoint() {
    double radius = 200;
    double width = MediaQuery.of(context).size.width.toDouble() - 20;
    double heigth = MediaQuery.of(context).size.width.toDouble() - 20;
    Color sexColor = Color(CommonUtils.colorToInt(user.sexAlternatives.color));
    Color relColor = Color(CommonUtils.colorToInt(user.relationShip.color));
    return Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center
          children: [
            FlirtPoint().build(width, heigth, radius, sexColor, relColor),
            const SizedBox(height: 100),
          ],
        ));
  }

  void nfcCallBack(String pointId) async {
    Log.d("Starts nfcCallBack");
    try {
      Log.d("-->nfc value $pointId");
      NavigatorApp.pop(context);

      if (pointId.isNotEmpty) {
        var response = await SmartPoint.empty().getSmartPointByPointId(pointId);

        if (response.point != null) {
          var message = "Nuevo contacto:${response.point!.name}";
          DefaultModalDialog.showErrorDialog(context, "Nuevo contacto añadido",
              "Cerrar", FontAwesomeIcons.user,
              iconColor: Colors.green);
        }
      } else {
        DefaultModalDialog.showErrorDialog(
            context,
            "No se han encontrado datos en el SmartPoint",
            "Cerrar",
            FontAwesomeIcons.exclamation);
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }

  void _readPoint() async {
    Log.d("Starts _readdPoint");
    try {
      if (Deviceinfoservice.nfcAvailable) {
        DefaultModalDialog.showErrorDialog(
            context,
            "Acerca el smartpoint de tu nuevo contacto",
            "Cerrar",
            FontAwesomeIcons.nfcSymbol,
            iconColor: Colors.black);

        NfcService nfcService = NfcService();
        var bInit = await nfcService.init();
        if (bInit) {
          String pointId = await nfcService.readNfc(30);
          var pointResponse =
              await SmartPoint.empty().getSmartPointByPointId(pointId);
          if (pointResponse.point != null) {
            SmartPoint point = pointResponse.point!;
            print("user_id:" +user.userId);
            print("qr_id:"+user.qrDefaultId);
            print( "point_user-id:"+ point.userId!);            
            print("point_id:"+point.id!);
            print("flirt_id:"+Session.currentFlirt!.id);
            print("location:"+Session.location!.toString());
            HostPutUserContactRequest()
                .run(user.userId, user.qrDefaultId, point.userId!, point.id!,
                    Session.currentFlirt!.id, Session.location!, ContactUser.point)
                .then((value) {

                });
          }
        }
      } else {
        DefaultModalDialog.showErrorDialog(
            context,
            "No ha sido posible iniciar el NFC de tu dispositivo",
            "Cerrar",
            FontAwesomeIcons.exclamation);
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}
