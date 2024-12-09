import 'package:app/ads/GoogleAds.dart';
import 'package:app/comms/model/request/flirt/HostDisableFlirtByFlirtIdUserId.dart';
import 'package:app/comms/model/request/flirt/HostGetUserFlirtsRequest.dart';
import 'package:app/comms/model/request/flirt/HostPutFlirtByUserIdRequest.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/services/LocationService.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/ads/AdsManager.dart';
import 'package:app/ui/elements/FlirtPoint.dart';
import 'package:app/ui/login/components/my_button.dart';
import 'package:app/ui/qr_manager/QrCodeScannerPage.dart';
import 'package:app/ui/qr_manager/ShowQrCodeToShare.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';

class PartyModePage extends StatefulWidget {
  @override
  State<PartyModePage> createState() {
    return _PartyModeState();
  }
}

class _PartyModeState extends State<PartyModePage> {
  bool _isEnabled = false;
  Color? _sexAltColor;
  Color? _relAltColor;
  User user = Session.user;
  bool _isLoading = true;
  LocationService? _locationService;
  late AdsManager adsManager;
  bool _isAdLoadedBanner = false;

  @override
  void initState() {
    adsManager = AdsManager((value) => _loadedAd(value));

    if (!Session.flirtAlreadyLoaded) {
      _fetchFlirtStateFromHost();
    } else {
      _loadLocalFlirt();
    }

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
    adsManager.init(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56.0), // Height of the AppBarP
          child: AppBar(

              // leading: _isEnabled
              //     ? IconButton(
              //         icon: const Icon(Icons.stop),
              //         onPressed: () {
              //           _onStopFlirt();
              //         },
              //       )
              //     : IconButton(
              //         icon: const Icon(Icons.play_arrow),
              //         onPressed: () {
              //           _onStartFlirt();
              //         },
              //       ),
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
                        : _buildDisabledPanel()
                    // : _buildDisabledFlirtPanel(),
                    ),
            // _buildBanner(),
            // _buildAdaptativeBannerd()

            if (_isAdLoadedBanner) adsManager.buildAdaptativeBannerd(context)
          ],
        ));
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildDisabledPanel() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center content vertically
        children: [
          const SizedBox(height: 25),
          MyButton(
            text: "Hazte visible",
            onTap: () {
              _onStartFlirt();
            },
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  Widget _buildEnabledFlirtPanelPoint() {
    double radius = 200;
    double width = 300;
    double heigth = 300;
    return Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center
          children: [
            FlirtPoint()
                .build(width, heigth, radius, _sexAltColor!, _relAltColor!),
            const SizedBox(height: 100),
            // MyButton(
            //   text: "Parar",
            //   onTap: () {
            //     _onStopFlirt();
            //   },
            // ),
            // const SizedBox(height: 70)
          ],
        ));
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
}
