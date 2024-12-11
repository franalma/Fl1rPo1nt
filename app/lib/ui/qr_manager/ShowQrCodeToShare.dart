import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ads/AdsManager.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShowQrCodeToShare extends StatefulWidget {
  @override
  State<ShowQrCodeToShare> createState() {
    return _ShowQrCodeToShare();
  }
}

class _ShowQrCodeToShare extends State<ShowQrCodeToShare> {
  List<Map<String, dynamic>> qrItems = [];
  late AdsManager adsManager;
  bool _isAdLoadedBanner = false;
  Map<String, dynamic> qrObj = {};

  TextEditingController controller = TextEditingController();
  List selectedIndex = [];
  User user = Session.user;
  late String qrValue;

  @override
  void initState() {
    super.initState();

    adsManager = AdsManager((value) => _loadedAd(value));

    if (user.qrDefaultId.isNotEmpty) {
      qrValue = "${user.qrDefaultId}:${user.userId}";
    } else {
      qrValue = "${user.qrValues[0].qrId}:${user.userId}";
    }
    Log.d("-->qr value: $qrValue");
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
      appBar: AppBar(flexibleSpace: FlexibleAppBar()),
      body: Stack(children: [
        Center(
          child: Container(
              child: user.qrValues.isNotEmpty
                  ? QrImageView(
                      data: qrValue,
                      size: 300,
                    )
                  : _buildNoQr()),
        ),
        if (_isAdLoadedBanner) adsManager.buildAdaptativeBannerd(context)
      ]),
    );
  }

  Widget _buildNoQr() {
    return Center(
        child: Container(
      child: const Text("Debes añadir un código QR para compartir"),
    ));
  }
}
