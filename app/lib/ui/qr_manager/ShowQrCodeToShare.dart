import 'package:app/app_localizations.dart';
import 'package:app/model/QrValue.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/elements/AppDrawerMenu.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/CommonUtils.dart';
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

  Map<String, dynamic> qrObj = {};

  TextEditingController controller = TextEditingController();
  List selectedIndex = [];
  User user = Session.user;
  late String qrValue;

  @override
  void initState() {
    super.initState();
    if (user.qrDefaultId.isNotEmpty) {
       qrValue = "${user.qrDefaultId}:${user.userId}";
    } else {
      qrValue = "${user.qrValues[0].qrId}:${user.userId}";
    }
    Log.d("-->qr value: $qrValue");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(flexibleSpace: FlexibleAppBar()),
      body: Center(
        child: Container(
            child: user.qrValues.isNotEmpty
                ? QrImageView(
                    data: qrValue,
                    size: 300,
                  )
                : _buildNoQr()),
      ),
    );
  }

  Widget _buildNoQr() {
    return Center(
        child: Container(
      child: const Text("Debes añadir un código QR para compartir"),
    ));
  }
}
