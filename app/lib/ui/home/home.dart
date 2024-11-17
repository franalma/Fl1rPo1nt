import 'dart:convert';

import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/flirt/HostDisableFlirtByFlirtIdUserId.dart';
import 'package:app/comms/model/request/flirt/HostPutFlirtByUserIdRequest.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/AppDrawerMenu.dart';
import 'package:app/ui/qr_manager/QrCodeScannerPage.dart';
import 'package:app/ui/qr_manager/ShowQrCodeToShare.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isEnabled = false;
  Color? _sexAltColor;
  Color? _relAltColor;
  User user = Session.user;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    Session.socketSubscription?.onNewContactRequested =
        _handleNewContactRequest;
  }

  void _handleNewContactRequest(String data) {
    Log.d("data received: $data");
    var map = jsonDecode(data);
    var contactRequested = map["message"]["requested_user_id"];
    AlertDialogs().showAlertNewContactAdded(context, contactRequested);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.translate('app_name')),
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
            ]),
        body: _isLoading
            ? _buildLoading()
            : Center(
                child: _isEnabled
                    ? _buildEnabledFlirtPanel()
                    : _buildDisabledFlirtPanel(),
              ));
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildDisabledFlirtPanel() {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: const Color.fromARGB(255, 243, 243, 244),
          ),
        ),
        Expanded(
          child: Container(
            color: const Color.fromARGB(255, 243, 243, 244),
          ),
        ),
        Positioned(
          top: 50, // Ajusta la posición del botón en la primera parte
          left: 20,
          child: FloatingActionButton(
            onPressed: () {
              _onStartFlirt();
            },
            child: const Text("Dale!"),
          ),
        ),
      ],
    );
  }

  Widget _buildEnabledFlirtPanel() {
    return Column(
      children: [
        Expanded(
          child: Container(color: _sexAltColor),
        ),
        Expanded(
          child: Container(color: _relAltColor),
        ),
        Positioned(
          top: 50, // Ajusta la posición del botón en la primera parte
          left: 20,
          child: FloatingActionButton(
            onPressed: () {
              _onStopFlirt();
            },
            child: const Text("Parar!"),
          ),
        ),
      ],
    );
  }

  void onErrorLocationHandler(String message) {
    FlutterToast().showToast(message);
  }

  void _onStartFlirt() async {
    if (user.sexAlternatives.color == null ||
        user.sexAlternatives.color == null) {
      FlutterToast()
          .showToast("Debes indicar tus preferencias antes de comenzar");
      return;
    } else {
      _sexAltColor = Color(CommonUtils.colorToInt(user.sexAlternatives.color));
      _relAltColor = Color(CommonUtils.colorToInt(user.relationShip.color));
    }
    setState(() {
      _isLoading = true;
    });

    LocationHandler handler = LocationHandler(onErrorLocationHandler);
    Location location = await handler.getCurrentLocation();

    if (location.lat == 0 && location.lon == 0) {
      FlutterToast().showToast("No ha sido posible obtener la localización");
      setState(() {
        _isLoading = false;
      });
    } else {
      Session.location = location;
      HostPutFlirtByUserIdRequest().run(user, location).then((value) {
        if (value.flirt != null) {
          user.isFlirting = true;
          Session.currentFlirt = value.flirt!;
          setState(() {
            _isEnabled = true;
            _isLoading = false;
          });
        } else {
          FlutterToast().showToast("No ha sido posible comenzar el Flirt");
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void _onStopFlirt() async {
    setState(() {
      _isLoading = true;
    });

    HostDisableFlirtByFlirtIdUserId()
        .run(user, Session.currentFlirt!)
        .then((value) {
      if (value) {
        setState(() {
          _isEnabled = false;
          user.isFlirting = false;
          _isLoading = false;
        });
      } else {
        FlutterToast().showToast("No ha sido posible desactivar el Flirt");
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
}
