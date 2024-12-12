import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/Session.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../comms/model/request/matchs/HostPutUserContactRequest.dart';

class QrCodeScannerPage extends StatefulWidget {
  @override
  _QrCodeScannerPage createState() => _QrCodeScannerPage();
}

class _QrCodeScannerPage extends State<QrCodeScannerPage> {
  final MobileScannerController controller = MobileScannerController();

  @override
  void initState() {
    super.initState();
    controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCameraScanner();
  }

  Future<void> _onQrScanned(String value) async {
    Log.d("_onQrScanned");
    var user = Session.user;
    var flirt = Session.currentFlirt;
    var location = Session.location;
    var values = value.split(":");
    TextStyle styleMessages =
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    if (values.length == 2) {
      HostPutUserContactRequest()
          .run(user.userId, user.qrDefaultId, values[1], values[0],
              flirt!.id.toString(), location!, ContactUser.qr)
          .then((value) {
        if (value.code == HostErrorCodesValue.NoError.code) {
          AlertDialogs().showModalDialogMessage(
              context,
              200,
              FontAwesomeIcons.user,
              40,
              Colors.green,
              "Nuevo contacto añadido",
              styleMessages,
              "Cerrar");
        } else if (value.code == HostErrorCodesValue.UserInYourContacts.code) {
          AlertDialogs().showModalDialogMessage(
              context,
              200,
              FontAwesomeIcons.exclamation,
              40,
              Colors.red,
              "Ya tienes este contacto!",
              styleMessages,
              "Cerrar");
        }
      });
    } else {
      AlertDialogs().showModalDialogMessage(
          context,
          200,
          FontAwesomeIcons.circleExclamation,
          40,
          Colors.red,
          "QR no válido",
          styleMessages,
          "Cerrar");
    }

    NavigatorApp.pop(context);
  }

  Widget _buildCameraScanner() {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleAppBar(),
          actions: [
            IconButton(
              icon: const Icon(Icons.flash_on),
              onPressed: () {
                controller.toggleTorch();
              },
            ),
          ],
        ),
        body: SizedBox(
            height: 600,
            child: MobileScanner(onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;

              for (final barcode in barcodes) {
                if (barcode.rawValue?.toString() != null) {
                  _onQrScanned(barcode.rawValue.toString());
                  controller.stop();
                  break;
                }
              }
            })));
  }

  @override
  void dispose() {
    super.dispose();
    controller.stop();
  }
}
