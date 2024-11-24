import 'package:app/comms/model/request/HostPutUserContactRequest.dart';
import 'package:app/model/Session.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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

    if (values.length == 2) {
      HostPutUserContactRequest()
          .run(user.userId, values[1], values[0], flirt!.id.toString(),
              location!)
          .then((value) {
        if (value) {
          FlutterToast().showToast("Se ha añadido el usuario a tus contactos");
        } else {
          FlutterToast().showToast(
              "Puede que ya tengas a este usuario en tus contactos!");
        }
      });
    } else {
      FlutterToast().showToast("Error al añadir el usuario tus contactos");
    }

    NavigatorApp.pop(context);
  }

  Widget _buildCameraScanner() {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleAppBar(),
          actions: [
            IconButton(
              icon: Icon(Icons.flash_on),
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
