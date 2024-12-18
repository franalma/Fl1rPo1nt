import 'dart:convert';

import 'package:app/app_localizations.dart';

import 'package:app/comms/model/request/flirt/HostDisableFlirtByFlirtIdUserId.dart';
import 'package:app/comms/model/request/flirt/HostGetUserFlirtsRequest.dart';
import 'package:app/comms/model/request/flirt/HostPutFlirtByUserIdRequest.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/services/LocationService.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ads/GoogleAds.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/qr_manager/QrCodeScannerPage.dart';
import 'package:app/ui/qr_manager/ShowQrCodeToShare.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isEnabled = false;
  Color? _sexAltColor;
  Color? _relAltColor;
  User user = Session.user;
  bool _isLoading = true;
  GoogleAds? _googleAds;
  bool _isBannerLoaded = false;
  bool _isAdaptativeAdLoaded = false;
  LocationService? _locationService;

  @override
  void initState() {
    super.initState();
    Session.socketSubscription?.onNewContactRequested =
        _handleNewContactRequest;

    if (!Session.flirtAlreadyLoaded) {
      _fetchFlirtStateFromHost();
    } else {
      _loadLocalFlirt();
    }

    _googleAds = GoogleAds();
    _googleAds!.loadBanner((value) {
      _isBannerLoaded = value;
    });
  }

  void _handleNewContactRequest(String data) {
    Log.d("data received: $data");
    try {
      var map = jsonDecode(data);
      Map<String, dynamic> message = map["message"]["requested_user"];
      String name = message["name"] ?? "Desconocid@";
      String urlImage = message["profile_image"] is Map
          ? message["profile_image"]["url"]
          : "";
      AlertDialogs().showCustomModalDialog(context, name, urlImage);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }

  Widget _buildBanner() {
    if (_isBannerLoaded) {
      return Positioned(
        bottom: 16, // Distance from the bottom of the screen
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            height: _googleAds!.bannerAd.size.height.toDouble(),
            width: _googleAds!.bannerAd.size.width.toDouble(),
            child: AdWidget(ad: _googleAds!.bannerAd),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildAdaptativeBannerd() {
    if (_isAdaptativeAdLoaded) {
      return Positioned(
        bottom: 80, // Distance from the bottom of the screen
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            // height: _googleAds!.adaptiveBannerAd.size.height.toDouble(),
            // width: _googleAds!.adaptiveBannerAd.size.width.toDouble(),
            // child: AdWidget(ad: _googleAds!.adaptiveBannerAd),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    _googleAds!.loadAdaptiveBanner(context, (value) {
      _isAdaptativeAdLoaded = value;
    });
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56.0), // Height of the AppBarP
          child: AppBar(
              leading: _isEnabled
                  ? IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () {
                        _onStopFlirt();
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        _onStartFlirt();
                      },
                    ),
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
              ]),
        ),
        body: Stack(
          children: [
            _isLoading
                ? _buildLoading()
                : Center(
                    child: _isEnabled
                        ? _buildEnabledFlirtPanelPoint()
                        : Container()
                    // : _buildDisabledFlirtPanel(),
                    ),
            // _buildBanner(),
            _buildAdaptativeBannerd()
          ],
        ));
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildDisabledFlirtPanel() {
    return Center(
      child: GestureDetector(
        onTap: () {
          _onStartFlirt();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green], // Two-color gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30), // Rounded corners
          ),
          child: Text(
            "Comienza un Floiint!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnabledFlirtPanelPoint() {
    return Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: SizedBox(
          width: 300, // Width of the circle
          height:
              300, // Height of the circle (same as width for a perfect circle)
          child: Stack(children: [
            Container(
              width: 150,
              decoration: BoxDecoration(
                color: _sexAltColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(200),
                  bottomLeft: Radius.circular(200),
                ),
              ),
            ),
            // Second half color
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 150, // Half the total width
                decoration: BoxDecoration(
                  color: _relAltColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(200),
                    bottomRight: Radius.circular(200),
                  ),
                ),
              ),
            ),
          ]),
        ));
  }

  void onErrorLocationHandler(String message) {
    FlutterToast().showToast(message);
  }

  void _fetchFlirtStateFromHost() async {
    LocationHandler handler = LocationHandler(onErrorLocationHandler);
    Location location = await handler.getCurrentLocation();

    if (location.lat == 0 && location.lon == 0) {
      FlutterToast().showToast("No ha sido posible obtener la localización");
      setState(() {
        _isLoading = false;
      });
    } else {
      HostGetUserFlirtsRequest().run(Session.user.userId, 1).then((value) {
        if (value.flirts != null && value.flirts!.isNotEmpty) {
          Session.user.isFlirting = true;
          _sexAltColor =
              Color(CommonUtils.colorToInt(user.sexAlternatives.color));
          _relAltColor = Color(CommonUtils.colorToInt(user.relationShip.color));
          Session.location = location;
          var flirt = value.flirts?[0];
          Session.currentFlirt = flirt;
          _locationService = LocationService(Session.currentFlirt!);
          _locationService?.startSendingLocation();
          setState(() {
            _isEnabled = true;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _isEnabled = false;
          });
        }
        Session.flirtAlreadyLoaded = true;
      });
    }
  }

  void _loadLocalFlirt() async {
    Log.d("Starts _loadLocalFlirt");
    if (Session.user.isFlirting) {
      _isEnabled = true;
      _sexAltColor = Color(CommonUtils.colorToInt(user.sexAlternatives.color));
      _relAltColor = Color(CommonUtils.colorToInt(user.relationShip.color));
    } else {
      _isEnabled = false;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onStartFlirt() async {
    if (user.sexAlternatives.color.isEmpty ||
        user.sexAlternatives.color.isEmpty) {
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
          _locationService = LocationService(Session.currentFlirt!);
          _locationService?.startSendingLocation();
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
    Log.d("Starts _onStopFlirt");
    try {
      _locationService?.stopSendingLocation();
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
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }

  @override
  void dispose() {
    if (_googleAds != null) {
      // _googleAds!.dispose();
    }

    super.dispose();
  }
}
