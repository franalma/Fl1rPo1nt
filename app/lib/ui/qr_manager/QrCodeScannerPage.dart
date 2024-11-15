import 'package:app/ui/utils/Log.dart';
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
    
    return Container(); 
  }

  Future<void> _onQrScanned() async {
    Log.d("_onQrScanned");


  }

  Widget _buildCameraScanner(){
    return Scaffold(
        appBar: AppBar(
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
                print("-->qr value: " + barcode.rawValue.toString() ??
                    "No Data found in QR");
              }
            })));
  }
  @override
  void dispose() {    
    super.dispose();
    controller.stop();
  }
  
}
